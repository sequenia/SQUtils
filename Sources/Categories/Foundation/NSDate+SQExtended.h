//
//  NSDate+SQExtended.h
//  GeoSearch
//
//  Created by Nikolay Kagala on 25/02/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (SQExtended)

+ (NSDate *)sq_GMTDate;

@end

@interface NSDateFormatter (SQExtended)

+ (NSDateFormatter*) sq_dateFormatterDateOnly;

+ (NSDateFormatter*) sq_dateFormatterTimeOnly;

+ (NSDateFormatter*) sq_dateFormatter;

@end
