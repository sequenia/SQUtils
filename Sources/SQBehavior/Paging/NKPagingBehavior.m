//
//  NKPagingBehavior.m
//  GeoSearch
//
//  Created by Nikolay Kagala on 28/03/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import "NKPagingBehavior.h"
#import "SQCategories.h"

static NSString* const reusableIdentifier = @"Cell";

@interface NKPagingBehavior () <UICollectionViewDataSource,
                                UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) UICollectionView* collectionView;

@property (weak, nonatomic) UIViewController* owner;

@property (weak, nonatomic, readonly) UIView* view;

@end

@implementation NKPagingBehavior

@dynamic owner;

- (void) awakeFromNib {
    self.collectionView = [self createCollectionView];
    
    self.pageControl.numberOfPages = self.pages.count;
}

- (UICollectionView*) createCollectionView {
    CGRect frame = self.view.bounds;
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setItemSize: frame.size];
    [layout setScrollDirection: UICollectionViewScrollDirectionHorizontal];
    [layout setMinimumLineSpacing:0.0];
    [layout setMinimumInteritemSpacing: 0.0];
    UICollectionView* collectionView = [[UICollectionView alloc] initWithFrame: frame
                                                          collectionViewLayout: layout];
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.pagingEnabled = YES;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [collectionView registerClass: [UICollectionViewCell class] forCellWithReuseIdentifier: reusableIdentifier];
    [self.view insertSubview: collectionView atIndex: 0];
    return collectionView;
}

#pragma mark - Helper

- (UIView*) pageAtIndexPath: (NSIndexPath*) indexPath {
    return [self pageAtIndex: indexPath.row];
}

- (UIView*) pageAtIndex: (NSUInteger) index {
    if (index >= self.pages.count){
        return nil;
    }
    return self.pages[index];
}

#pragma mark - Custom accessors

- (UIView *)view {
    return self.owner.view;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.pages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSInteger pageViewTag = 1000;
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier: reusableIdentifier
                                                                           forIndexPath: indexPath];
    cell.backgroundColor = [self.view backgroundColor];
    UIView* page = [self pageAtIndexPath: indexPath];
    page.tag = pageViewTag;
    page.frame = cell.bounds;
    page.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [[cell viewWithTag: pageViewTag] removeFromSuperview];
    [cell addSubview: page];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSIndexPath* visibleIndexPath = [self.collectionView sq_indexPathOfVisibleItem];
    self.pageControl.currentPage = visibleIndexPath.row;
}

@end
