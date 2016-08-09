//
//  NSDictionary+SQExtended.h
//  GeoSearch
//
//  Created by Nikolay Kagala on 04/02/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (SQExtended)

- (NSString*)sq_urlEncodedString;

- (NSArray*)sq_valuesForKeys: (NSArray*) keys;

- (NSString *)sq_jsonString;

@end
