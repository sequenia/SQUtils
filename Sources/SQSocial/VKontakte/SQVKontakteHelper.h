//
//  SQVKontakteHelper.h
//  VseMayki
//
//  Created by Sequenia on 30/05/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import "SQSocnetHelper.h"
#import <VK-ios-sdk/VKSdk.h> //Pod version = 1.3.12

@protocol SQVKontakteHelperDelegate;

@interface SQVKontakteHelper : SQSocnetHelper

+ (SQVKontakteHelper *)helper;

@property (nonatomic, weak) id<SQVKontakteHelperDelegate> delegate;

- (void) authorizeVKWithScope:(NSArray *)scope;

- (void) getVKAccountDataWithParams:(NSDictionary *)params
                         completion:(void (^)(NSDictionary *result, NSError *error))completion;

@end

@protocol SQVKontakteHelperDelegate <NSObject>

@optional

- (void)socnetHelper:(SQSocnetHelper *)helper onVKLoginCompleteWithErrors:(NSError *)error;

@end
