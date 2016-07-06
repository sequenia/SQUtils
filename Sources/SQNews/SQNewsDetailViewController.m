//
//  SQNewsDetailViewController.m
//  FitService
//
//  Created by Sequenia on 06/06/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import "SQNewsDetailViewController.h"

@interface SQNewsDetailViewController () {
    UIActivityIndicatorView *loaderIndicator;
}

@end

@implementation SQNewsDetailViewController

- (id)init{
    self = [super initWithNibName:@"SQNewsDetailViewController" bundle:nil];
    if(self){
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    loaderIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [loaderIndicator setColor:[UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0]];
    [loaderIndicator setHidesWhenStopped:YES];
    loaderIndicator.transform = CGAffineTransformMakeScale(0.8, 0.8);
    loaderIndicator.center = CGPointMake(CGRectGetWidth(self.view.frame) / 2.f, CGRectGetHeight(self.view.frame) / 2.f);
    
    [self.view addSubview:loaderIndicator];
    
    _topInset = 44.f;
    _newsWebView.scrollView.contentInset = UIEdgeInsetsMake(_topInset, 0, 0, 0);
    
    
    NSString *myDescriptionHTML = [NSString stringWithFormat:@"<html> \n"
                                   "<head> \n"
                                   "<style type=\"text/css\"> \n"
                                   "</head> \n"
                                   "<body></body> \n"
                                   "</html>"];
    
    [_newsWebView loadHTMLString:myDescriptionHTML baseURL:nil];
    
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if (navigationType == UIWebViewNavigationTypeLinkClicked){
        NSURL *url = request.URL;
        [[UIApplication sharedApplication] openURL:url];
        return NO;
    }
    return YES;
}

- (void) initHeader{
    
}

- (void) displayContentWithTitle:(NSString *)title body:(NSString *)body attributes:(NSDictionary *)attributes{
    NSString *fontFamily = [attributes objectForKey:kFontFamily];
    if(!fontFamily){
        fontFamily = @"HelveticaNeue";
    }
    
    double fontSize = [[attributes objectForKey:kFontSize] doubleValue];
    if(fontSize == 0){
        fontSize = 15;
    }
    
    NSString *myDescriptionHTML = [NSString stringWithFormat:@"<html> \n"
                                   "<head> \n"
                                   "<style type=\"text/css\"> \n"
                                   "body {font-family: \"%@\"; font-size: %f;}\n"
                                   "</style> \n"
                                   "</head> \n"
                                   "<body><p><b>%@</b></p>%@</body> \n"
                                   "</html>", fontFamily, fontSize, title, body];
    [_newsWebView loadHTMLString:myDescriptionHTML baseURL:nil];
}

- (void) setLoadInProgress:(BOOL)inProgress{
    if(inProgress){
        [loaderIndicator startAnimating];
    }
    else{
        [loaderIndicator stopAnimating];
    }
}

@end
