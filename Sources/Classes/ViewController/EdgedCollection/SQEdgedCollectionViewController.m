//
//  SQEdgedCollectionViewController.m
//  FitService
//
//  Created by Sequenia on 06/06/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import "SQEdgedCollectionViewController.h"

@interface SQEdgedCollectionViewController () {
    UICollectionView *edgedCollectionView;
    UIPageControl *pageControl;

    NSMutableArray *reuseIdentifiers;
}

@end

@implementation SQEdgedCollectionViewController

- (void) registerCellWithIdentifier:(NSString *)identifier nibName:(NSString *)nibName{
    if(!reuseIdentifiers){
        reuseIdentifiers = [NSMutableArray array];
    }
    [edgedCollectionView registerNib:[UINib nibWithNibName:nibName bundle:[NSBundle bundleForClass:[self class]]] forCellWithReuseIdentifier:identifier];
    [reuseIdentifiers addObject:identifier];
}

- (void) setContent:(NSArray *)content{
    _content = content;
    pageControl.numberOfPages = content.count;
    [edgedCollectionView reloadData];
}

- (void) setPageIndicatorColor:(UIColor *)pageIndicatorColor{
    _pageIndicatorColor = pageIndicatorColor;
    pageControl.pageIndicatorTintColor = pageIndicatorColor;
}

- (void) setPageInidicatorCurPageColor:(UIColor *)pageInidicatorCurPageColor{
    _pageInidicatorCurPageColor = pageInidicatorCurPageColor;
    pageControl.currentPageIndicatorTintColor = pageInidicatorCurPageColor;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _currentPage = 0;
    _currentOffset = 0;
    pageControl.numberOfPages = 0;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [layout setSectionInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [layout setMinimumInteritemSpacing:0];
    [layout setMinimumLineSpacing:0];
    
    edgedCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) collectionViewLayout:layout];
    edgedCollectionView.backgroundColor = [UIColor clearColor];
    edgedCollectionView.delegate = self;
    edgedCollectionView.dataSource = self;
    edgedCollectionView.showsVerticalScrollIndicator = NO;
    edgedCollectionView.showsHorizontalScrollIndicator = NO;
    edgedCollectionView.pagingEnabled = NO;
    edgedCollectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    edgedCollectionView.alwaysBounceHorizontal = YES;
    edgedCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:edgedCollectionView];
    
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 37)];
    [pageControl setContentMode:UIViewContentModeCenter];
    pageControl.pageIndicatorTintColor = _pageIndicatorColor;
    pageControl.currentPageIndicatorTintColor = _pageInidicatorCurPageColor;
    [pageControl setUserInteractionEnabled:NO];
    pageControl.hidesForSinglePage = YES;
    pageControl.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:pageControl];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_content count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(_cellWidth, _cellHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, _cellHorizontalInset / 2.f, 0, _cellHorizontalInset / 2.f);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifiers.firstObject forIndexPath:indexPath];
    return cell;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    CGFloat kMaxIndex = [_content count] - 1;
    CGFloat targetX;
    if (velocity.x < 0) {
        targetX = scrollView.contentOffset.x - _cellHorizontalInset;
    } else
        targetX = scrollView.contentOffset.x + velocity.x * _cellHorizontalInset;
    
    CGFloat targetIndex = round(targetX / (edgedCollectionView.frame.size.width - _cellHorizontalInset + _cellSpacing));
    if (velocity.x > 0) {
        targetIndex = ceil(targetX / (edgedCollectionView.frame.size.width - _cellHorizontalInset + _cellSpacing));
    } else if (velocity.x < 0) {
        targetIndex = floor(targetX / (edgedCollectionView.frame.size.width - _cellHorizontalInset + _cellSpacing));
    }
    
    if(fabs(targetIndex - _currentPage) > 1){
        if(targetIndex - _currentPage > 0 && velocity.x > 0){
            targetIndex = _currentPage + 1;
        }
        else if (targetIndex - _currentPage < 0 && velocity.x < 0){
            targetIndex = _currentPage - 1;
        }
    }
    
    if (fabs(velocity.x) < FLT_EPSILON){
        targetIndex = _currentPage;
    }
    
    if (targetIndex < 0)
        targetIndex = 0;
    if (targetIndex > kMaxIndex)
        targetIndex = kMaxIndex;
    
    targetContentOffset->x = targetIndex * (edgedCollectionView.frame.size.width - _cellHorizontalInset + _cellSpacing);
    _currentPage = targetIndex;
    pageControl.currentPage = _currentPage;
}

- (void) setPageControllBottomSpacing:(CGFloat)bottomSpacing{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict[@"pageControl"] = pageControl;
    dict[@"edgedCollectionView"] = edgedCollectionView;
    
    NSString *format = @"|-0-[edgedCollectionView]-0-|";
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:dict];
    [self.view addConstraints:constraints];
    
    format = @"V:|-0-[edgedCollectionView]-0-|";
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:dict];
    [self.view addConstraints:constraints];
    
    format = [NSString stringWithFormat:@"V:[pageControl(height)]-%f-|", bottomSpacing];
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:@{@"height":@37.0} views:dict];
    [self.view addConstraints:constraints];
    
    format = @"|-10-[pageControl]-10-|";
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:dict];
    [self.view addConstraints:constraints];
    
    [self.view sendSubviewToBack:edgedCollectionView];
}

- (void) setCollectionViewTopSpacing:(CGFloat)topSpacing height:(CGFloat)collectHeight controllSpacing:(CGFloat)spacing{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict[@"pageControl"] = pageControl;
    dict[@"edgedCollectionView"] = edgedCollectionView;
    
    NSString *format = @"|-0-[edgedCollectionView]-0-|";
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:dict];
    [self.view addConstraints:constraints];
    
    format = [NSString stringWithFormat:@"V:|-%f-[edgedCollectionView(height)]", topSpacing];
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:@{@"height": @(collectHeight)} views:dict];
    [self.view addConstraints:constraints];
    
    format = [NSString stringWithFormat:@"V:[edgedCollectionView]-%f-[pageControl(height)]", spacing];
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:@{@"height":@37.0} views:dict];
    [self.view addConstraints:constraints];
    
    format = @"|-10-[pageControl]-10-|";
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:dict];
    [self.view addConstraints:constraints];
    
    [self.view sendSubviewToBack:edgedCollectionView];
    
    
}


@end
