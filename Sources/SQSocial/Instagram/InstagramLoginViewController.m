//
//  InstagramLoginViewController.m
//  VseMayki
//
//  Created by Sequenia on 25/01/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import "InstagramLoginViewController.h"

@interface InstagramLoginViewController (){
    NSURL *loginURL;
    UIActivityIndicatorView *loaderIndicator;
}

@end

@implementation InstagramLoginViewController


-(id)initWithURL:(NSURL *)url{
    self = [super initWithNibName:@"InstagramLoginViewController" bundle:nil];
    if(self){
        loginURL = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onClose)];
    self.navigationItem.leftBarButtonItem = item;
    self.navigationItem.title = @"Вход";
    
    loaderIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [loaderIndicator setColor:[UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0]];
    [loaderIndicator setHidesWhenStopped:YES];
    loaderIndicator.transform = CGAffineTransformMakeScale(0.8, 0.8);
    loaderIndicator.center = CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds) / 2.f, CGRectGetHeight([UIScreen mainScreen].bounds) / 2.f);
    [self.view addSubview:loaderIndicator];
    
    [pageWebView loadRequest:[NSURLRequest requestWithURL:loginURL]];
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [pageWebView stopLoading];
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    [loaderIndicator startAnimating];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [loaderIndicator stopAnimating];
}

-(void)onClose{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
