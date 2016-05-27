//
//  UIView+SQExtended.h
//  GeoSearch
//
//  Created by Nick on 01/03/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SQExtended)

- (UIView*)sq_findSuperviewViewWithClass: (Class) clazz;

- (void)sq_layoutIfNeededAnimatedWithDuration: (NSTimeInterval) duration;

+ (instancetype)sq_loadFromNibByClassName;

- (void)sq_shake;

@end
