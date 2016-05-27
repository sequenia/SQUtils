//
//  UIColor+SQExtended.h
//  VseMayki
//
//  Created by Sequenia on 17/05/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (SQExtended)

+ (UIColor *)sq_colorWithRGBString:(NSString *)hexString;

- (NSString *)sq_encodeToRGBString;

@end
