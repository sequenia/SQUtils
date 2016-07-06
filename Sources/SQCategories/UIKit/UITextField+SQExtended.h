//
//  UITextField+SQExtended.h
//  GeoSearch
//
//  Created by Nikolay Kagala on 26/01/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (SQExtended)

- (void)sq_setButtonWithTitle: (NSString*) title
                       action: (SEL) selector
                    andTarget: (id) target;

@end
