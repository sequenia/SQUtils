//
//  NSArray+SQExtended.h
//  MusicPlayer
//
//  Created by Denis Baluev on 18/12/15.
//  Copyright © 2015 Sequenia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (SQExtended)

- (id)sq_objectAtIndexOrNil:(NSInteger)index;

- (NSArray*)sq_map: (id(^)(id obj)) block;

- (NSArray*)sq_filter: (BOOL(^)(id obj)) block;

- (NSString *) sq_jsonString;

@end
