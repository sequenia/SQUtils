//
//  UINavigationController+SQExtended.h
//  SQUtils
//
//  Created by Nikolay Kagala on 17/06/16.
//  Copyright © 2016 Nikolay Kagala. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (SQExtended)

- (void) sq_popToRootViewControllerAnimatedWithCompletion: (void(^)()) completion;

- (void) sq_pushViewControllerAnimatedWithCompletion: (void(^)()) completion;

@end
