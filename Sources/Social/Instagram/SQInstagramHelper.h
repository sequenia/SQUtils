//
//  SQInstagramHelper.h
//  VseMayki
//
//  Created by Sequenia on 30/05/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import "SQSocnetHelper.h"

@protocol SQInstagramHelperDelegate;

@interface SQInstagramHelper : SQSocnetHelper

+ (SQInstagramHelper *)helper;

@property (nonatomic, weak) id<SQInstagramHelperDelegate> delegate;

- (void) authorizeInstagramWithScope:(NSArray *)scope;

- (NSString *) getInstagramAccessToken;

@end

@protocol SQInstagramHelperDelegate <NSObject>

@optional

- (void)socnetHelper:(SQSocnetHelper *)helper onInstagramLoginCompleteWithErrors:(NSError *)error;

@end
