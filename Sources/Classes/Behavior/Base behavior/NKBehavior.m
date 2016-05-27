//
//  NKBehavior.m
//  GeoSearch
//
//  Created by Nikolay Kagala on 28/03/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import <objc/runtime.h>
#import "NKBehavior.h"

@interface NKBehavior ()

@end

@implementation NKBehavior

- (void) setOwner: (id) owner {
    if (_owner != owner){
        [self releaseLifeTimeFromObject: _owner];
        _owner = owner;
        [self bindLifeTimeToObject: _owner];
    }
}

- (void) bindLifeTimeToObject: (id) object {
    objc_setAssociatedObject(object, (__bridge void *)self, self, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void) releaseLifeTimeFromObject: (id) object {
    objc_setAssociatedObject(object, (__bridge void *)self, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
