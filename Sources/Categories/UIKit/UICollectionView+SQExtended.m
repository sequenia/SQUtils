//
//  UICollectionView+SQExtended.m
//  GeoSearch
//
//  Created by Nikolay Kagala on 28/03/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import "UICollectionView+SQExtended.h"

@implementation UICollectionView (SQExtended)

- (NSIndexPath*) sq_indexPathOfVisibleItem {
    CGRect visibleRect = (CGRect){.origin = self.contentOffset, .size = self.bounds.size};
    CGPoint visiblePoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect));
    return [self indexPathForItemAtPoint:visiblePoint];
}

@end