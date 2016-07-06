//
//  SQNewsContainerViewController.m
//  FitService
//
//  Created by Sequenia on 06/06/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import "SQNewsContainerViewController.h"

@interface SQNewsContainerViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate> {
    NSUInteger prevIndex;
    CGSize contentSize;
    NSMutableArray *startPoints;
    UIScrollView *pageControllScrollView;
    CGFloat pageWidth;
    BOOL tapSwitch;
}

@end

@implementation SQNewsContainerViewController

- (id)init{
    self = [super init];
    if(self){
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _newsPages = [NSMutableArray array];
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    pageWidth = screenSize.width;
}

- (void) initPagesWithTitles:(NSArray *)titles{
    if(titles.count > 1){
        _dateSegmentControl = [[UISegmentedControl alloc] initWithItems:titles];
        [_dateSegmentControl addTarget:self
                                action:@selector(showViewControllerAtIndex)
                      forControlEvents:UIControlEventValueChanged];
        
        [_dateSegmentControl setSelectedSegmentIndex:0];
        [_dateSegmentControl sizeToFit];
        CGRect frame = _dateSegmentControl.frame;
        frame.size.width = self.view.frame.size.width;
        _dateSegmentControl.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
        [_dateSegmentControl setTintAdjustmentMode:UIViewTintAdjustmentModeNormal];
        [self.view addSubview:_dateSegmentControl];
        
        self.underLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, _dateSegmentControl.frame.size.height - 4, _dateSegmentControl.frame.size.width / 2, 4)];
        [_dateSegmentControl addSubview:_underLine];
        
        startPoints = [NSMutableArray array];
        
        CGFloat startPoint = 0.f;
        CGFloat step = CGRectGetWidth(self.view.frame) / titles.count;
        while (startPoint < CGRectGetWidth(self.view.frame)) {
            [startPoints addObject:@(startPoint)];
            startPoint += step;
        }
    }
    
    [self initPages];
}


- (void) initPages{
    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    _pageViewController.dataSource = self;
    _pageViewController.delegate = self;
    
    // Change the size of page view controller
    CGFloat topY = 0;
    if(_dateSegmentControl){
        topY = CGRectGetHeight(_dateSegmentControl.frame);
    }
    _pageViewController.view.frame = CGRectMake(0, topY, self.view.frame.size.width, self.view.frame.size.height - topY);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    
    for (UIView *view in _pageViewController.view.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            pageControllScrollView = (UIScrollView *)view;
            [pageControllScrollView setDelegate:self];
            contentSize = pageControllScrollView.contentSize;
            break;
        }
    }
    
    if(_newsPages.count <= 1){
        pageControllScrollView.scrollEnabled = NO;
    }
    else{
        pageControllScrollView.scrollEnabled = YES;
    }
    [self showViewControllerAtIndex];
}

- (void)showViewControllerAtIndex {
    UIViewController *startingViewController = [self viewControllerAtIndex:[_dateSegmentControl selectedSegmentIndex]];
    tapSwitch = YES;
    [self moveUnderlineAtSelectedIndex];
    NSArray *viewControllers = @[startingViewController];
    if(prevIndex > [_dateSegmentControl selectedSegmentIndex]){
        [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    }
    else{
        [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    }
    prevIndex = [_dateSegmentControl selectedSegmentIndex];
    [_pageViewController didMoveToParentViewController:self];
}


- (UIViewController *)viewControllerAtIndex:(NSUInteger)index
{
    return [_newsPages objectAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [_newsPages indexOfObject:viewController];
    prevIndex = index;
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    index--;
    return [self viewControllerAtIndex:index];
}

-(void) pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed{
    UIViewController *currentView = [pageViewController.viewControllers objectAtIndex:0];
    [_dateSegmentControl setSelectedSegmentIndex:[_newsPages indexOfObject:currentView]];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [_newsPages indexOfObject:viewController];
    prevIndex = index;
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    if (index == 2) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

-(void) scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if(tapSwitch)
        tapSwitch = NO;
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    [self moveUnderlineAtPoint:scrollView.contentOffset.x];
}

- (void)moveUnderlineAtPoint:(CGFloat) point{
    if(!tapSwitch){
        
        point -= pageWidth;
        point += [_dateSegmentControl selectedSegmentIndex] * pageWidth;
        [UIView transitionWithView:_underLine
                          duration:0.25
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            CGRect frame = _underLine.frame;
                            frame.origin.x = point / 2;
                            _underLine.frame = frame;
                        } completion:^ (BOOL completion){
                            
                        }];
    }
}

- (void)moveUnderlineAtSelectedIndex {
    NSNumber *point = [startPoints objectAtIndex:[_dateSegmentControl selectedSegmentIndex]];
    [UIView transitionWithView:_underLine
                      duration:0.25
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        CGRect frame = _underLine.frame;
                        frame.origin.x = [point floatValue];
                        _underLine.frame = frame;
                    } completion:^ (BOOL completion){
                        tapSwitch = YES;
                    }];
}

- (void)onSelectNews:(id)news{
    
}

- (void) showNewsDetail:(id)news{
    
}

@end
