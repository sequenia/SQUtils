//
//  SQSheetLayout.m
//  PhotoTest
//
//  Created by Sequenia on 22/06/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import "SQSheetLayout.h"
#import "SQSheetSeparator.h"

@implementation SQSheetLayout

static NSString * const separatorReuseIdentifier = @"SQSheetSeparator";

- (id)init{
    self = [super init];
    if(self){
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self initialize];
    }
    return self;
}

- (void) initialize{
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.minimumLineSpacing = 0;
    self.minimumInteritemSpacing = 0;
    [self registerClass:[SQSheetSeparator class] forDecorationViewOfKind:@"SQSheetSeparator"];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSArray *layoutAttributesArray = [super layoutAttributesForElementsInRect:rect];
    
    NSMutableArray *decorationAttributes = [NSMutableArray array];
    NSArray *visibleIndexPaths = [self indexPathsOfSeparatorsInRect:rect]; // will implement below
    
    for (NSIndexPath *indexPath in visibleIndexPaths) {
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForDecorationViewOfKind:@"SQSheetSeparator" atIndexPath:indexPath];
        [decorationAttributes addObject:attributes];
    }
    
    return [layoutAttributesArray arrayByAddingObjectsFromArray:decorationAttributes];
}

- (NSArray*)indexPathsOfSeparatorsInRect:(CGRect)rect {
    NSInteger firstCellIndexToShow = floorf(rect.origin.y / self.itemSize.height);
    NSInteger lastCellIndexToShow = floorf((rect.origin.y + CGRectGetHeight(rect)) / self.itemSize.height);
    NSInteger countOfItems = [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:0];
    
    NSMutableArray* indexPaths = [NSMutableArray new];
    for (NSInteger i = MAX(firstCellIndexToShow, 0); i <= lastCellIndexToShow; i++) {
        if (i < countOfItems) {
            [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
    }
    return indexPaths;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)decorationViewKind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:decorationViewKind withIndexPath:indexPath];
    
    CGFloat itemSize = 0;
    if(indexPath.row != 0){
        itemSize = 55;
    }
    
    CGFloat decorationOffset = self.previewCellHeight + (indexPath.row * itemSize) + indexPath.row * self.minimumLineSpacing;
    layoutAttributes.frame = CGRectMake(0.0, decorationOffset, self.collectionViewContentSize.width, 1);
    layoutAttributes.zIndex = 1000;
    
    return layoutAttributes;
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingDecorationElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)decorationIndexPath {
    UICollectionViewLayoutAttributes *layoutAttributes =  [self layoutAttributesForDecorationViewOfKind:elementKind atIndexPath:decorationIndexPath];
    return layoutAttributes;
}

@end
