//
//  UINavigationController+SQExtended.m
//  SQUtils
//
//  Created by Nikolay Kagala on 17/06/16.
//  Copyright © 2016 Nikolay Kagala. All rights reserved.
//

#import "UINavigationController+SQExtended.h"

@implementation UINavigationController (SQExtended)

- (void) sq_popToRootViewControllerAnimatedWithCompletion: (void(^)()) completion {
    [self sq_perfromBlockInTransaction:^void{
        [self.navigationController popViewControllerAnimated: YES];
    } withCompletion: completion];
}

- (void) sq_pushViewControllerAnimatedWithCompletion: (void(^)()) completion {
    [self sq_perfromBlockInTransaction:^void{
        [self.navigationController popViewControllerAnimated: YES];
    } withCompletion: completion];
}

- (void) sq_perfromBlockInTransaction: (void(^)()) block
                       withCompletion: (void(^)()) completion {
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        if (completion) { completion(); }
    }];
    if (block) { block(); }
    [CATransaction commit];
}

@end
