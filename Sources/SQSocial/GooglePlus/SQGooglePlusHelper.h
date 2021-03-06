//
//  SQGooglePlusHelper.h
//  VseMayki
//
//  Created by Sequenia on 30/05/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import "SQSocnetHelper.h"
#import <GoogleSignIn/GoogleSignIn.h> 

@protocol SQGooglePlusHelperDelegate;

@interface SQGooglePlusHelper : SQSocnetHelper

+ (SQGooglePlusHelper *)helper;

@property (nonatomic, weak) id<SQGooglePlusHelperDelegate> delegate;

- (void) authorizeGooglePlusWithScope:(NSArray *)scope;

@end

@protocol SQGooglePlusHelperDelegate <NSObject>

@optional

- (void)socnetHelper:(SQSocnetHelper *)helper onGooglePlusLoginCompleteWithErrors:(NSError *)error;

@end
