//
//  SQInstagramHelper.m
//  VseMayki
//
//  Created by Sequenia on 30/05/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import "SQInstagramHelper.h"
#import "InstagramLoginViewController.h"

@import SafariServices;

@interface SQInstagramHelper () <SFSafariViewControllerDelegate>{
    
}
@end

static NSString * const kSqUtilsInstagramAccessTokenKey = @"kSqUtilsInstagramAccessTokenKey";

@implementation SQInstagramHelper

+(SQInstagramHelper *)helper
{
    static SQInstagramHelper *_sharedInstance = nil;
    static dispatch_once_t onceSecurePredicate;
    dispatch_once(&onceSecurePredicate,^
                  {
                      _sharedInstance = [[self alloc] init];
                  });
    return _sharedInstance;
}


- (NSString *) getInstagramAccessToken{
    if(![[NSUserDefaults standardUserDefaults] objectForKey:kSqUtilsInstagramAccessTokenKey]){
        return nil;
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:kSqUtilsInstagramAccessTokenKey];
}

- (void) authorizeInstagramWithScope:(NSArray *)scope{
    if([self getInstagramAccessToken] && [self.delegate respondsToSelector:@selector(socnetHelper:onInstagramLoginCompleteWithErrors:)]){
        [self.delegate socnetHelper:self onInstagramLoginCompleteWithErrors:nil];
        return;
    }
    NSString *stringURL = [NSString stringWithFormat:@"https://api.instagram.com/oauth/authorize/?client_id=%@&redirect_uri=%@://&response_type=token&scope=%@", self.appId, self.urlScheme, [self constructStringFromArray:scope withSpliter:@","]];
    
    NSURL *authURL = [NSURL URLWithString:stringURL];
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 9){
        SFSafariViewController *safariController = [[SFSafariViewController alloc] initWithURL:authURL];
        safariController.delegate = self;
        [self.targetController presentViewController:safariController animated:YES completion:nil];
    }
    else{
        InstagramLoginViewController *controller= [[InstagramLoginViewController alloc] initWithURL:authURL];
        UINavigationController *instController = [[UINavigationController alloc] initWithRootViewController:controller];
        [self.targetController presentViewController:instController animated:YES completion:nil];
    }
    
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    if([self.urlScheme isEqualToString:url.scheme]){
        return [self parseInstagramUrl:[url absoluteString]];
    }
    return NO;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    if([self.urlScheme isEqualToString:url.scheme]){
        return [self parseInstagramUrl:[url absoluteString]];
    }
    return NO;
}

- (BOOL) parseInstagramUrl:(NSString *)urlString{
    NSString *delimiter = @"access_token=";
    NSArray *components = [urlString componentsSeparatedByString:delimiter];
    if (components.count > 1) {
        NSString *accessToken = [components lastObject];
        [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:kSqUtilsInstagramAccessTokenKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.targetController dismissViewControllerAnimated:YES completion:nil];
        if([self.delegate respondsToSelector:@selector(socnetHelper:onInstagramLoginCompleteWithErrors:)]){
            [self.delegate socnetHelper:self onInstagramLoginCompleteWithErrors:nil];
        }
        return YES;
    }
    return NO;
}

-(void)safariViewController:(SFSafariViewController *)controller didCompleteInitialLoad:(BOOL)didLoadSuccessfully{
    
}

-(void)safariViewControllerDidFinish:(SFSafariViewController *)controller{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (NSString *) constructStringFromArray:(NSArray *)array withSpliter:(NSString *)splitter{
    NSMutableString *string = [[NSMutableString alloc] init];
    for(int i = 0; i < [array count]; i++){
        [string appendString:[array objectAtIndex:i]];
        if(i < [array count] - 1)
            [string appendString:splitter];
    }
    return string;
}


@end
