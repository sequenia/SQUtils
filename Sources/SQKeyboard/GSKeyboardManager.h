//
//  GSKeyboardManager.h
//  GeoSearch
//
//  Created by Nikolay Kagala on 29/01/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GSKeyboardManager : NSObject

- (instancetype) initWithMainView: (UIView*) view NS_DESIGNATED_INITIALIZER;

- (instancetype) init NS_UNAVAILABLE;

- (void) startListeningKeyboardNotifications;

- (void) stopListeningKeyboardNotifications;

@end
