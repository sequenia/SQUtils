//
//  NSError+SQExtended.m
//  Domopult
//
//  Created by Nikolay Kagala on 17/05/16.
//  Copyright © 2016 sequenia. All rights reserved.
//

#import "NSError+SQExtended.h"

@implementation NSError (SQExtended)

+ (instancetype) applicationErrorWithDescription: (NSString*) description {
    return [NSError applicationErrorWithCode: 0 andDescription: description];
}

+ (instancetype) applicationErrorWithCode: (NSInteger) errorCode andDescription: (NSString*) description {
    return [NSError errorWithCode: errorCode
                      description: description
                        andDomain: [[NSBundle mainBundle] bundleIdentifier]];
}

+ (instancetype) errorWithCode: (NSInteger) code
                   description: (NSString*) description
                     andDomain: (NSString*) domain{
    NSDictionary* params = nil;
    if (description){
        params = @{NSLocalizedDescriptionKey : description};
    }
    return [NSError errorWithDomain: domain
                               code: code
                           userInfo: params];
}

@end
