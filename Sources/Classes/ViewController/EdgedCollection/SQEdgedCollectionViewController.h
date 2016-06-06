//
//  SQEdgedCollectionViewController.h
//  FitService
//
//  Created by Sequenia on 06/06/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface SQEdgedCollectionViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) IBInspectable UIColor *pageIndicatorColor;
@property (nonatomic, strong) IBInspectable UIColor *pageInidicatorCurPageColor;
@property (nonatomic) IBInspectable CGFloat cellHorizontalInset;
@property (nonatomic) IBInspectable CGFloat cellSpacing;
@property (nonatomic) IBInspectable CGFloat cellWidth;
@property (nonatomic) IBInspectable CGFloat cellHeight;

@property (nonatomic, strong) NSArray *content;

@property (nonatomic) NSInteger currentPage;
@property (nonatomic) CGFloat currentOffset;

- (void) registerCellWithIdentifier:(NSString *)identifier nibName:(NSString *)nibName;
- (void) setPageControllBottomSpacing:(CGFloat)bottomSpacing;
- (void) setCollectionViewTopSpacing:(CGFloat)topSpacing height:(CGFloat)collectHeight controllSpacing:(CGFloat)spacing;

@end
