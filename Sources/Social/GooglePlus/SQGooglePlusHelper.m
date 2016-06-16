//
//  SQGooglePlusHelper.m
//  VseMayki
//
//  Created by Sequenia on 30/05/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import "SQGooglePlusHelper.h"

@interface SQGooglePlusHelper () <GIDSignInDelegate, GIDSignInUIDelegate>{
    
}
@end

@implementation SQGooglePlusHelper

+(SQGooglePlusHelper *)helper
{
    static SQGooglePlusHelper *_sharedInstance = nil;
    static dispatch_once_t onceSecurePredicate;
    dispatch_once(&onceSecurePredicate,^
                  {
                      _sharedInstance = [[self alloc] init];
                  });
    return _sharedInstance;
}

- (void) authorizeGooglePlusWithScope:(NSArray *)scope{
    
    [GIDSignIn sharedInstance].clientID = self.appId;
    [GIDSignIn sharedInstance].delegate = self;
    [GIDSignIn sharedInstance].uiDelegate = self;
//    [GIDSignIn sharedInstance].allowsSignInWithBrowser = NO;
    [GIDSignIn sharedInstance].shouldFetchBasicProfile = YES;
    
    [GIDSignIn sharedInstance].scopes = scope;
    if([[GIDSignIn sharedInstance] hasAuthInKeychain]){
        [[GIDSignIn sharedInstance] signInSilently];
    }
    else{
        [[GIDSignIn sharedInstance] signOut];
        [[GIDSignIn sharedInstance] signIn];
    }
}

-(void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error{
    if([self.delegate respondsToSelector:@selector(socnetHelper:onGooglePlusLoginCompleteWithErrors:)]){
        [self.delegate socnetHelper:self onGooglePlusLoginCompleteWithErrors:error];
    }
}

- (void) signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController{
    if(self.targetController){
        [self.targetController presentViewController:viewController animated:YES completion:nil];
    }
}

- (void) signIn:(GIDSignIn *)signIn dismissViewController:(UIViewController *)viewController{
    if(self.targetController){
        [self.targetController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    if([self.urlScheme isEqualToString:url.scheme]){
        return [[GIDSignIn sharedInstance] handleURL:url
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
        return [[GIDSignIn sharedInstance] handleURL:url sourceApplication:sourceApplication
                                          annotation:annotation];
    }
    return NO;
}



@end
