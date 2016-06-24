//
//  SQPresentationController.m
//  PhotoTest
//
//  Created by Sequenia on 24/06/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import "SQPresentationController.h"

@interface SQPresentationController ()

@property (nonatomic, readonly) UIView *dimmingView;

@end

@implementation SQPresentationController

- (UIView *)dimmingView {
    static UIView *instance = nil;
    if (instance == nil) {
        instance = [[UIView alloc] initWithFrame:self.containerView.bounds];
        instance.backgroundColor = [UIColor colorWithWhite:0 alpha:0.39];
        instance.userInteractionEnabled = YES;
        instance.alpha = 0.f;
        [instance addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgViewTapped:)]];
    }
    return instance;
}


- (void)bgViewTapped:(UITapGestureRecognizer *)sender{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (CGRect) frameOfPresentedViewInContainerView{
    return self.containerView.bounds;
}

- (CGSize) sizeForChildContentContainer:(id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize{
    return parentSize;
}

- (void)presentationTransitionWillBegin{
    self.dimmingView.frame = self.containerView.bounds;
    [self.containerView insertSubview:self.dimmingView atIndex:0];
    id<UIViewControllerTransitionCoordinator> coordinator = self.presentedViewController.transitionCoordinator;
    if(coordinator){
        [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
            self.dimmingView.alpha = 1.f;
        } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
            
        }];
    }
    else{
        self.dimmingView.alpha = 1.f;
    }
}

- (void) dismissalTransitionWillBegin{
    id<UIViewControllerTransitionCoordinator> coordinator = self.presentedViewController.transitionCoordinator;
    if(coordinator){
        [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
            self.dimmingView.alpha = 0.f;
        } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
            
        }];
    }
    else{
        self.dimmingView.alpha = 0.f;
    }
}

- (void) dismissalTransitionDidEnd:(BOOL)completed{
    if(completed){
        [self.dimmingView removeFromSuperview];
    }
}

- (void)containerViewWillLayoutSubviews {
    self.dimmingView.frame = self.containerView.bounds;
    self.presentedView.frame = [self frameOfPresentedViewInContainerView];
}

@end
