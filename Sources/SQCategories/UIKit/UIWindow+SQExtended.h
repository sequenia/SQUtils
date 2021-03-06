//
//  UIWindow+SQExtended.h
//  SQUtils
//
//  Created by Nikolay Kagala on 31/05/16.
//  Copyright © 2016 Nikolay Kagala. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWindow (SQExtended)

- (void)sq_setRootViewController: (UIViewController *)rootViewController animated: (BOOL)animated;

- (void)sq_setRootViewController:(UIViewController *)rootViewController
                        animated:(BOOL)animated
                      completion:(void (^)())completion;

@end
