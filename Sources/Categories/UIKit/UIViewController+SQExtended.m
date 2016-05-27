//
//  UIViewController+SQExtended.m
//  Pods
//
//  Created by Nikolay Kagala on 26/05/16.
//
//

#import "UIViewController+SQExtended.h"

@implementation UIViewController (SQExtended)

+ (instancetype)sq_viewControllerFromMainStoryBoard {
    return [self sq_viewControllerFromStoryBoardWithName: @"Main"];
}

+ (instancetype)sq_viewControllerFromStoryBoardWithName: (NSString*) name {
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName: name bundle: nil];
    return [storyboard instantiateViewControllerWithIdentifier: NSStringFromClass([self class])];
}

@end
