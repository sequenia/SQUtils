//
//  UITextView+SQExtended.h
//  Pods
//
//  Created by Nikolay Kagala on 26/05/16.
//
//

#import <UIKit/UIKit.h>

@interface UITextView (SQExtended)

- (void)sq_setButtonWithTitle: (NSString*) title
                       action: (SEL) selector
                    andTarget: (id) target;

@end
