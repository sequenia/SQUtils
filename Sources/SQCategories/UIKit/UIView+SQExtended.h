//
//  UIView+SQExtended.h
//  GeoSearch
//
//  Created by Nick on 01/03/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SQExtended)

@property (nonatomic) CGFloat sq_topY;
@property (nonatomic) CGFloat sq_bottomY;
@property (nonatomic) CGFloat sq_leftX;
@property (nonatomic) CGFloat sq_rightX;

@property (nonatomic) CGFloat sq_width;
@property (nonatomic) CGFloat sq_height;

- (UIView*)sq_findSuperviewViewWithClass: (Class) clazz;

- (void)sq_layoutIfNeededAnimatedWithDuration: (NSTimeInterval) duration;

+ (instancetype)sq_loadFromNibByClassName;

+ (UINib *)sq_loadNibByClassName;

- (void)sq_shake;

- (void)sq_setHidden: (BOOL) hidden animated: (BOOL) animated;

- (UIImage*)sq_image;

@end
