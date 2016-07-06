//
//  UITextView+SQExtended.m
//  Pods
//
//  Created by Nikolay Kagala on 26/05/16.
//
//

#import "UITextView+SQExtended.h"

@implementation UITextView (SQExtended)

- (void)sq_setButtonWithTitle: (NSString*) title
                       action: (SEL) selector
                    andTarget: (id) target{
    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
    [keyboardDoneButtonView sizeToFit];
    UIBarButtonItem* button = [[UIBarButtonItem alloc] initWithTitle: title
                                                               style: UIBarButtonItemStylePlain
                                                              target: target
                                                              action: selector];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:button, nil]];
    self.inputAccessoryView = keyboardDoneButtonView;
}

@end
