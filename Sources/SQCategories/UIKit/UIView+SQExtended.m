//
//  UIView+NKExtended.m
//  GeoSearch
//
//  Created by Nick on 01/03/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import "UIView+SQExtended.h"

@implementation UIView (SQExtended)

- (CGFloat) sq_topY {
    return CGRectGetMinY(self.frame);
}

- (CGFloat) sq_bottomY {
    return CGRectGetMaxY(self.frame);
}

- (CGFloat) sq_leftX {
    return CGRectGetMinX(self.frame);
}

- (CGFloat) sq_rightX {
    return CGRectGetMaxX(self.frame);
}

- (CGFloat) sq_width {
    return CGRectGetWidth(self.frame);
}

- (CGFloat) sq_height {
    return CGRectGetHeight(self.frame);
}

- (UIView*)sq_findSuperviewViewWithClass: (Class) clazz {
    if ([self isKindOfClass: clazz]){
        return self;
    } else if (self.superview){
        return [self.superview sq_findSuperviewViewWithClass: clazz];
    } else {
        return nil;
    }
}

- (void)sq_layoutIfNeededAnimatedWithDuration: (NSTimeInterval) duration {
    [UIView animateWithDuration: duration
                     animations:^{
                         [self layoutIfNeeded];
                     }];
}

+ (UINib *) sq_loadNibByClassName {
    return [UINib nibWithNibName: NSStringFromClass([self class])
                          bundle: [NSBundle bundleForClass: [self class]]];
}

+ (UIView *) sq_loadFromNibByClassName {
    NSString* nibName = NSStringFromClass([self class]);
    NSBundle* bundle = [NSBundle bundleForClass: [self class]];
    NSArray *subviewArray = [bundle loadNibNamed: nibName owner:self options:nil];
    return subviewArray.firstObject;
}

- (void)sq_shake {
    CABasicAnimation *animation =
    [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setDuration:0.1];
    [animation setRepeatCount:2];
    [animation setAutoreverses:YES];
    [animation setFromValue:[NSValue valueWithCGPoint:
                             CGPointMake([self center].x - 3.0f, [self center].y)]];
    [animation setToValue:[NSValue valueWithCGPoint:
                           CGPointMake([self center].x + 3.0f, [self center].y)]];
    [[self layer] addAnimation:animation forKey:@"position"];
}

- (void)sq_setHidden: (BOOL) hidden animated: (BOOL) animated {
    CGFloat duration = animated ? 0.3 : 0.0;
    CGFloat alpha = hidden ? 0.0 : 1.0;
    [UIView animateWithDuration: duration
                     animations:^{
                         self.alpha = alpha;
                     }];
}

- (UIImage*)sq_image {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0.0f);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    UIImage * snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snapshotImage;
}

@end
