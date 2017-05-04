//
//  UIWindow+SQExtended.m
//  SQUtils
//
//  Created by Nikolay Kagala on 31/05/16.
//  Copyright © 2016 Nikolay Kagala. All rights reserved.
//

#import "UIWindow+SQExtended.h"

@implementation UIWindow (SQExtended)

- (void)sq_setRootViewController: (UIViewController *)rootViewController animated: (BOOL)animated {
  [self sq_setRootViewController:rootViewController
                        animated:animated
                      completion:nil];
}

- (void)sq_setRootViewController:(UIViewController *)rootViewController
                        animated:(BOOL)animated
                      completion:(void (^)())completion {
  if (animated) {
    UIView *snapShotView = [self snapshotViewAfterScreenUpdates:YES];
    [rootViewController.view addSubview:snapShotView];
    
    self.rootViewController = rootViewController;
    
    [UIView animateWithDuration:0.3 animations:^{
      snapShotView.layer.opacity = 0;
      snapShotView.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5);
    } completion:^(BOOL finished) {
      [snapShotView removeFromSuperview];
      if (completion) {
        completion();
      }
    }];
  }
  else {
    self.rootViewController = rootViewController;
    if (completion) {
      completion();
    }
  }
}

@end
