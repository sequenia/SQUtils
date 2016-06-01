//
//  SQFacebookHelper.h
//  VseMayki
//
//  Created by Sequenia on 30/05/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import "SQSocnetHelper.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>   //Pod version = 4.7.1
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@protocol SQFacebookHelperDelegate;

@interface SQFacebookHelper : SQSocnetHelper

+ (SQFacebookHelper *)helper;

@property (nonatomic, weak) id<SQFacebookHelperDelegate> delegate;

- (void) facebookApp:(UIApplication *)app didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
- (void) activateFacebookApp;

- (void) authorizeFacebookWithScope:(NSArray *)scope;

- (void) getFacebookAccountDataWithParams:(NSDictionary *)params
                               completion:(void (^)(NSDictionary *result, NSError *error))completion;

@end

@protocol SQFacebookHelperDelegate <NSObject>

@optional

- (void)socnetHelper:(SQFacebookHelper *)helper onFacebookLoginCompleteWithErrors:(NSError *)error;

@end
