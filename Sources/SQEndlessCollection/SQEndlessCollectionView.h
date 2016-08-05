//
//  SQEndlessCollectionView.h
//  VseMayki
//
//  Created by Sequenia on 01/06/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SQPageControl.h"

IB_DESIGNABLE
@interface SQEndlessCollectionView : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>{
    
}

@property (nonatomic, strong) UICollectionView *endlessCollectionView;

@property (nonatomic) IBInspectable BOOL animatedReload;
@property (nonatomic) IBInspectable BOOL timerEnabled;
@property (nonatomic) IBInspectable double timerLength;

@property (nonatomic, strong) IBInspectable UIColor *pageIndicatorColor;
@property (nonatomic, strong) IBInspectable UIColor *pageInidicatorCurPageColor;

@property (nonatomic, strong) IBInspectable UIImage *pageIndicatorImage;
@property (nonatomic, strong) IBInspectable UIImage *pageInidicatorCurPageImage;

@property (nonatomic) CGFloat bottomPageIndicatorSpacing;
@property (nonatomic, strong) NSArray *content;
@property (nonatomic) BOOL enableDidScrollEvent;

- (void) registerCellWithIdentifier:(NSString *)identifier nibName:(NSString *)nibName;

@end

