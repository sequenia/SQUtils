//
//  NSArray+SQExtended.m
//  MusicPlayer
//
//  Created by Denis Baluev on 18/12/15.
//  Copyright © 2015 Sequenia. All rights reserved.
//

#import "NSArray+SQExtended.h"

@implementation NSArray (SQExtended)

- (id)sq_objectAtIndexOrNil:(NSInteger)index {
    if (index >= 0 && index < self.count){
        return [self objectAtIndex: index];
    }
    return nil;
}

#pragma mark - HOM

- (NSArray*)sq_map: (id(^)(id obj)) block {
    NSMutableArray* mappedArray = [[NSMutableArray alloc] initWithCapacity: self.count];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id newObject = block(obj);
        if (newObject){
            [mappedArray addObject: newObject];
        } else {
            NSLog(@"Attempt to insert nil in an array while mapping");
        }
    }];
    return mappedArray;
}

- (NSArray*)sq_filter: (BOOL(^)(id obj)) block {
    NSMutableArray* filteredArray = [[NSMutableArray alloc] initWithCapacity: self.count];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (block(obj)){
            [filteredArray addObject: obj];
        }
    }];
    return filteredArray;
}

- (NSString *) sq_jsonString {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject: self
                                                       options: NSJSONWritingPrettyPrinted
                                                         error: &error];
    if (!jsonData) {
        NSLog(@"sq_jsonString: error: %@", error.localizedDescription);
        return @"[]";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

@end
