//
//  SQNewsDetailViewController.h
//  FitService
//
//  Created by Sequenia on 06/06/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const kFontFamily = @"kFontFamily";
static NSString * const kFontSize   = @"kFontSize";

@interface SQNewsDetailViewController : UIViewController <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *newsWebView;
@property (nonatomic, strong) UIImageView *headerImage;
@property (nonatomic) double topInset;

- (void)initHeader;
- (void)displayContentWithTitle:(NSString *)title body:(NSString *)body attributes:(NSDictionary *)attributes;
- (void)setLoadInProgress:(BOOL)inProgress;

@end
