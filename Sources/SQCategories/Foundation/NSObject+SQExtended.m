//
//  NSObject+SQExtended.m
//  Pods
//
//  Created by sequenia on 13/10/16.
//
//

#import "NSObject+SQExtended.h"

@implementation NSObject (SQExtended)

- (NSString *)sq_className {
    return NSStringFromClass([self class]);
}


@end
