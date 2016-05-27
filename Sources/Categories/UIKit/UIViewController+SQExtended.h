//
//  UIViewController+SQExtended.h
//  Pods
//
//  Created by Nikolay Kagala on 26/05/16.
//
//

#import <UIKit/UIKit.h>

@interface UIViewController (SQExtended)

+ (instancetype)sq_viewControllerFromMainStoryBoard;

+ (instancetype)sq_viewControllerFromStoryBoardWithName: (NSString*) name;

@end
