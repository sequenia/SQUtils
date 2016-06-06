//
//  SQNewsSelectDelegate.h
//  FitService
//
//  Created by Sequenia on 06/06/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol NewsSelectDelegate <NSObject>
@required
-(void)onSelectNews:(id)news;
@end
