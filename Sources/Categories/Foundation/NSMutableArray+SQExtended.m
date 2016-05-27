//
//  NSMutableArray+SQExtended.m
//  GeoSearch
//
//  Created by Nikolay Kagala on 04/04/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import "NSMutableArray+SQExtended.h"

@implementation NSMutableArray (SQExtended)

@end

@implementation NSMutableArray (SQQueue)

- (void)sq_enqueue: (id) object {
    [self addObject: object];
}

- (id)sq_dequeue {
    id object = [self lastObject];
    [self removeLastObject];
    return object;
}

- (id)sq_peek {
    return [self lastObject];
}

@end