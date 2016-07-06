//
//  UITextField+SQExtended.m
//  GeoSearch
//
//  Created by Nikolay Kagala on 26/01/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import "UITextField+SQExtended.h"

@implementation UITextField (SQExtended)

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
