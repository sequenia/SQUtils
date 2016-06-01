//
//  SQVKontakteHelper.m
//  VseMayki
//
//  Created by Sequenia on 30/05/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import "SQVKontakteHelper.h"

@interface SQVKontakteHelper () <VKSdkDelegate, VKSdkUIDelegate>{
    
}

@end

@implementation SQVKontakteHelper

+(SQVKontakteHelper *)helper
{
    static SQVKontakteHelper *_sharedInstance = nil;
    static dispatch_once_t onceSecurePredicate;
    dispatch_once(&onceSecurePredicate,^
                  {
                      _sharedInstance = [[self alloc] init];
                  });
    return _sharedInstance;
}

- (void) authorizeVKWithScope:(NSArray *)scope{
    [VKSdk initializeWithAppId:self.appId];
    [[VKSdk instance] registerDelegate:self];
    [[VKSdk instance] setUiDelegate:self];
    [VKSdk wakeUpSession:scope completeBlock:^(VKAuthorizationState state, NSError *error) {
        if(state == VKAuthorizationAuthorized){
            if([self.delegate respondsToSelector:@selector(socnetHelper:onVKLoginCompleteWithErrors:)]){
                [self.delegate socnetHelper:self onVKLoginCompleteWithErrors:nil];
            }
        }
        else{
            [VKSdk forceLogout];
            if([VKSdk vkAppMayExists]){
                [VKSdk authorize:scope withOptions:VKAuthorizationOptionsUnlimitedToken|VKAuthorizationOptionsDisableSafariController];
            }
            else{
                [VKSdk authorize:scope withOptions:VKAuthorizationOptionsUnlimitedToken];
            }
        }
    }];
}

- (void) getVKAccountDataWithParams:(NSDictionary *)params
                         completion:(void (^)(NSDictionary *, NSError *))completion{
    
    VKRequest *audioReq = [VKRequest requestWithMethod:@"users.get" parameters:params];
    [audioReq executeWithResultBlock:^(VKResponse * response) {
        completion([response.json objectAtIndex:0], nil);
    } errorBlock:^(NSError * error) {
        completion(nil, error);
    }];
    
}

-(void)vkSdkAccessAuthorizationFinishedWithResult:(VKAuthorizationResult *)result{
    if([self.delegate respondsToSelector:@selector(socnetHelper:onVKLoginCompleteWithErrors:)]){
        [self.delegate socnetHelper:self onVKLoginCompleteWithErrors:result.error];
    }
}

-(void)vkSdkUserAuthorizationFailed{
    if([self.delegate respondsToSelector:@selector(socnetHelper:onVKLoginCompleteWithErrors:)]){
        NSError *error = [NSError errorWithVkError:[VKError errorWithCode:VK_API_ERROR]];
        [self.delegate socnetHelper:self onVKLoginCompleteWithErrors:error];
    }
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    if([self.urlScheme isEqualToString:url.scheme]){
        return [VKSdk processOpenURL:url fromApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]];
    }
    return NO;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    if([self.urlScheme isEqualToString:url.scheme]){
        return [VKSdk processOpenURL:url fromApplication:sourceApplication];
    }
    return NO;
}

-(void)vkSdkShouldPresentViewController:(UIViewController *)controller{
    if(self.targetController){
        [self.targetController presentViewController:controller animated:YES completion:nil];
    }
}

-(void)vkSdkNeedCaptchaEnter:(VKError *)captchaError{
    if(self.targetController){
        VKCaptchaViewController *vc = [VKCaptchaViewController captchaControllerWithError:captchaError];
        [vc presentIn:self.targetController];
    }
}



@end
