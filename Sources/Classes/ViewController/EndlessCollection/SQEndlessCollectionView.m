//
//  SQEndlessCollectionView.m
//  VseMayki
//
//  Created by Sequenia on 01/06/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import "SQEndlessCollectionView.h"

@interface SQEndlessCollectionView () {
    UICollectionView *endlessCollectionView;
    UIPageControl *pageControl;
    
    NSInteger originalCount;
    NSTimer *timer;
    NSInteger currentItem;
    
    CGFloat contentOffsetWhenFullyScrolledRight;
    CGFloat prevOffset;
    BOOL enableDidScrollEvent;
    double yVelocity;
    BOOL initialScrollDone;
    
    NSMutableArray *reuseIdentifiers;
}

@end

static double prevCallTime = 0;
static double prevCallOffset = 0;

@implementation SQEndlessCollectionView

- (void) registerCellWithIdentifier:(NSString *)identifier nibName:(NSString *)nibName{
    [reuseIdentifiers addObject:identifier];
    [endlessCollectionView registerNib:[UINib nibWithNibName:nibName bundle:[NSBundle bundleForClass:[self class]]] forCellWithReuseIdentifier:identifier];
}

- (void) viewDidLoad{
    [super viewDidLoad];
    
    _timerEnabled = YES;
    
    currentItem = 0;
    reuseIdentifiers = [NSMutableArray array];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [layout setSectionInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [layout setMinimumInteritemSpacing:0];
    [layout setMinimumLineSpacing:0];
    
    endlessCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) collectionViewLayout:layout];
    endlessCollectionView.delegate = self;
    endlessCollectionView.dataSource = self;
    endlessCollectionView.showsVerticalScrollIndicator = NO;
    endlessCollectionView.showsHorizontalScrollIndicator = NO;
    endlessCollectionView.pagingEnabled = YES;
    endlessCollectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    endlessCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:endlessCollectionView];
    
    initialScrollDone = NO;
    
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 37)];
    [pageControl setContentMode:UIViewContentModeCenter];
    pageControl.pageIndicatorTintColor = _pageIndicatorColor;
    pageControl.currentPageIndicatorTintColor = _pageInidicatorCurPageColor;
    [pageControl setUserInteractionEnabled:NO];
    pageControl.hidesForSinglePage = YES;
    pageControl.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:pageControl];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (!initialScrollDone) {
        initialScrollDone = YES;
        enableDidScrollEvent = NO;
        [endlessCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:currentItem inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    }
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    contentOffsetWhenFullyScrolledRight = self.view.frame.size.width * ([_content count] -1);
    return [_content count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[reuseIdentifiers firstObject] forIndexPath:indexPath];
    enableDidScrollEvent = YES;
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(enableDidScrollEvent){
        double curCallTime = CACurrentMediaTime();
        double timeDelta = curCallTime - prevCallTime;
        double curCallOffset = endlessCollectionView.contentOffset.x;
        double offsetDelta = curCallOffset - prevCallOffset;
        BOOL isScrollToBottom;
        if(prevCallOffset < curCallOffset)
            isScrollToBottom = YES;
        else
            isScrollToBottom = NO;
        
        yVelocity = offsetDelta / timeDelta;
        prevCallTime = curCallTime;
        prevCallOffset = curCallOffset;
        if(originalCount != 1){
            if (scrollView.contentOffset.x >= contentOffsetWhenFullyScrolledRight) {
                NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:1 inSection:0];
                [endlessCollectionView scrollToItemAtIndexPath:newIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
                currentItem = 1;
                
            } else if (scrollView.contentOffset.x <= 0)  {
                NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:([_content count] -2) inSection:0];
                [endlessCollectionView scrollToItemAtIndexPath:newIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
                currentItem = [_content count] - 2;
            }
        }
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    prevOffset = scrollView.contentOffset.x;
}

-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(originalCount != 1){
        [self reloadTimer];
    }
}

- (void)processCurrentIndex:(NSInteger)nextPage {
    if(nextPage == 0){
        nextPage = [_content count] - 2;
    }
    else if(nextPage == [_content count] - 1){
        nextPage = 0;
    }
    else{
        nextPage = nextPage - 1;
    }
    pageControl.currentPage = nextPage;
}


- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if(fabs(prevOffset - targetContentOffset->x) != 0 && originalCount != 1){
        if(prevOffset < targetContentOffset->x){
            currentItem++;
        }
        else{
            currentItem--;
        }
        CGFloat rawPageValue = targetContentOffset->x / self.view.frame.size.width;
        CGFloat nextPage = (velocity.x > 0.0) ? ceil(rawPageValue) : floor(rawPageValue);
        [self processCurrentIndex:nextPage];
    }
}

-(void) changeScrollPosition{
    if(originalCount != 1){
        currentItem++;
        if(currentItem == [_content count]){
            currentItem = 1;
        }
        [self processCurrentIndex:currentItem];
        @try {
            [endlessCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:currentItem inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
        }
        @catch (NSException *exception) {
            NSLog(@"%@", exception);
        }
    }
}


- (void) setContent:(NSArray *)content{
    originalCount = content.count;
    pageControl.numberOfPages = originalCount;
    if(content.count > 1){
        id firstItem = content[0];
        id lastItem = [content lastObject];
        
        NSMutableArray *workingArray = [content mutableCopy];
        
        // Add the copy of the last item to the beginning
        [workingArray insertObject:lastItem atIndex:0];
        
        // Add the copy of the first item to the end
        [workingArray addObject:firstItem];
        
        // Update the collection view's data source property
        _content =  [NSArray arrayWithArray:workingArray];
        if(originalCount > 0){
            enableDidScrollEvent = NO;
            currentItem = 1;
            [self processCurrentIndex:1];
            [self reloadTimer];
        }
    }
    else{
        _content = content;
        currentItem = 0;
        [timer invalidate];
    }
    
    if(_animatedReload){
        CATransition *transition = [CATransition animation];
        transition.duration = 0.4;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionFade;
        transition.subtype = kCATransitionFromTop;
        [endlessCollectionView.layer addAnimation:transition forKey:nil];
    }
    
    [endlessCollectionView reloadData];
    [endlessCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:currentItem inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
}

- (void) reloadTimer{
    if(_timerEnabled){
        [timer invalidate];
        timer = [NSTimer scheduledTimerWithTimeInterval:_timerLength target:self selector:@selector(changeScrollPosition) userInfo:nil repeats:YES];
    }
}

- (void) setBottomPageIndicatorSpacing:(CGFloat)bottomPageIndicatorSpacing{
    _bottomPageIndicatorSpacing = bottomPageIndicatorSpacing;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict[@"pageControl"] = pageControl;
    dict[@"endlessCollectionView"] = endlessCollectionView;
    
    NSString *format = @"|-0-[endlessCollectionView]-0-|";
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:dict];
    [self.view addConstraints:constraints];
    
    format = @"V:|-0-[endlessCollectionView]-0-|";
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:dict];
    [self.view addConstraints:constraints];
    
    format = [NSString stringWithFormat:@"V:[pageControl(height)]-%f-|", _bottomPageIndicatorSpacing];
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:@{@"height":@37.0} views:dict];
    [self.view addConstraints:constraints];
    
    format = @"|-10-[pageControl]-10-|";
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:dict];
    [self.view addConstraints:constraints];
    
    [self.view sendSubviewToBack:endlessCollectionView];
}

@end
