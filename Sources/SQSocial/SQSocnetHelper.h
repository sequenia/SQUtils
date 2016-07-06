//
//  SQSocnetHelper.h
//  VseMayki
//
//  Created by Sequenia on 27/05/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SQSocnetHelper : NSObject

@property (nonatomic, weak) UIViewController *targetController;

@property (nonatomic, strong) NSString *appId;
@property (nonatomic, strong) NSString *urlScheme;

//iOS 9 and higher
- (BOOL) application:(UIApplication *)app
             openURL:(NSURL *)url
             options:(NSDictionary<NSString *,id> *)options;

//iOS 8 and lower
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation;

@end

