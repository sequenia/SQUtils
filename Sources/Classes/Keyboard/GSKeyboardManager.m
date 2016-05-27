//
//  GSKeyboardManager.m
//  GeoSearch
//
//  Created by Nikolay Kagala on 29/01/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import "GSKeyboardManager.h"

@interface GSKeyboardManager ()

@property (weak, nonatomic) UIView* view;

@property (assign, nonatomic) CGPoint originalCenterOfView;

@end

@implementation GSKeyboardManager

- (instancetype) init {
    [NSException raise: @"Unavailable initializer"
                format: @"You should use the designated initializer for class [%@].", NSStringFromClass([self class])];
    return nil;
}

- (instancetype) initWithMainView: (UIView*) view {
    if (self = [super init]) {
        _view = view;
    }
    return self;
}

#pragma mark - Notifications

- (void) startListeningKeyboardNotifications {
    _originalCenterOfView = self.view.center;
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc addObserver: self selector: @selector(keyboardWillShow:) name: UIKeyboardWillShowNotification object: nil];
    [nc addObserver: self selector: @selector(keyboardWillHide:) name: UIKeyboardWillHideNotification object: nil];
}

- (void) stopListeningKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

#pragma mark - Handle keyboard appearance

- (void) keyboardWillShow: (NSNotification*) notification {
    CGRect frame = [self keyboardFrameFromNotification: notification];
    CGFloat responderMaxY = [self currentResponderMaxY];
    CGFloat padding = 8.0;
    CGFloat keyboardMinY = CGRectGetMinY(frame) - padding;
    if (responderMaxY <= keyboardMinY){
        return;
    }
    CGPoint center = self.originalCenterOfView;
    CGPoint newCenter = CGPointMake(center.x, center.y - (responderMaxY - keyboardMinY));
    NSTimeInterval duration = [self keyboardAnimationDurationFromNotification: notification];
    [UIView animateWithDuration: duration
                     animations:^{
                         self.view.center = newCenter;
                     }];
}

- (void) keyboardWillHide: (NSNotification*) notification {
    NSTimeInterval duration = [self keyboardAnimationDurationFromNotification: notification];
    [UIView animateWithDuration: duration
                     animations: ^{
                         self.view.center = self.originalCenterOfView;
                     }];
}

- (CGRect) keyboardFrameFromNotification: (NSNotification*) notification {
    NSValue* rectValue = notification.userInfo[UIKeyboardFrameEndUserInfoKey];
    return [rectValue CGRectValue];;
}

- (NSTimeInterval) keyboardAnimationDurationFromNotification: (NSNotification*) notification {
    NSNumber* durationValue = notification.userInfo[UIKeyboardAnimationDurationUserInfoKey];
    return [durationValue floatValue];
}

- (CGFloat) currentResponderMaxY {
    UIView* responder = (UIView*)[self findFirstResponderInView: self.view];
    CGRect rectInView = [responder convertRect: responder.bounds toView: self.view.window];
    CGFloat maxY = CGRectGetMaxY(rectInView);
    return maxY;
}

- (id)findFirstResponderInView: (UIView*) view{
    if (view.isFirstResponder) {
        return view;
    }
    for (UIView *subView in view.subviews) {
        id responder = [self findFirstResponderInView: subView];
        if (responder) return responder;
    }
    return nil;
}

@end
