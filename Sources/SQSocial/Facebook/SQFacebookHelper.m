//
//  SQFacebookHelper.m
//  VseMayki
//
//  Created by Sequenia on 30/05/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import "SQFacebookHelper.h"

@implementation SQFacebookHelper

+(SQFacebookHelper *)helper
{
    static SQFacebookHelper *_sharedInstance = nil;
    static dispatch_once_t onceSecurePredicate;
    dispatch_once(&onceSecurePredicate,^
                  {
                      _sharedInstance = [[self alloc] init];
                  });
    return _sharedInstance;
}

- (void)facebookApp:(UIApplication *)app didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    [[FBSDKApplicationDelegate sharedInstance] application:app
                             didFinishLaunchingWithOptions:launchOptions];
}

- (void)activateFacebookApp{
    [FBSDKAppEvents activateApp];
}

- (void) authorizeFacebookWithScope:(NSArray *)scope{
    if([[FBSDKAccessToken currentAccessToken] tokenString]){
        if([self.delegate respondsToSelector:@selector(socnetHelper:onFacebookLoginCompleteWithErrors:)]){
            [self.delegate socnetHelper:self onFacebookLoginCompleteWithErrors:nil];
        }
    }
    else{
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        if(![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb://"]]){
            if([[[UIDevice currentDevice] systemVersion] floatValue] >= 9)
                login.loginBehavior = FBSDKLoginBehaviorBrowser;
            else
                login.loginBehavior = FBSDKLoginBehaviorWeb;
        }
        [login logOut];
        [login logInWithReadPermissions:scope fromViewController:self.targetController handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            if([self.delegate respondsToSelector:@selector(socnetHelper:onFacebookLoginCompleteWithErrors:)] && !result.isCancelled){
                [self.delegate socnetHelper:self onFacebookLoginCompleteWithErrors:error];
            }
        }];
    }
}

- (void) getFacebookAccountDataWithParams:(NSDictionary *)params
                               completion:(void (^)(NSDictionary *, NSError *))completion{
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:params] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        completion(result, error);
    }];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    if([self.urlScheme isEqualToString:url.scheme]){
        return [[FBSDKApplicationDelegate sharedInstance] application:app
                                                              openURL:url
                                                    sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                           annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
    }
    return NO;
    
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    if([self.urlScheme isEqualToString:url.scheme]){
        return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                              openURL:url
                                                    sourceApplication:sourceApplication
                                                           annotation:annotation];
    }
    return NO;
}


@end
