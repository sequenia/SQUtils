//
//  NSError+SQExtended.h
//  Domopult
//
//  Created by Nikolay Kagala on 17/05/16.
//  Copyright © 2016 sequenia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (SQExtended)

+ (instancetype) applicationErrorWithDescription: (NSString*) description;

+ (instancetype) applicationErrorWithCode: (NSInteger) errorCode andDescription: (NSString*) description;

@end
