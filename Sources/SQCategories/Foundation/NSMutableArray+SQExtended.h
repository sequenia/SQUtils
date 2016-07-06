//
//  NSMutableArray+SQExtended.h
//  GeoSearch
//
//  Created by Nikolay Kagala on 04/04/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (SQExtended)

@end

@interface NSMutableArray (SQQueue)

- (void)sq_enqueue: (id) object;

- (id)sq_dequeue;

- (id)sq_peek;

@end
