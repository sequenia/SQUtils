//
//  InstagramLoginViewController.h
//  VseMayki
//
//  Created by Sequenia on 25/01/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InstagramLoginViewController : UIViewController <UIWebViewDelegate>{
    
    __weak IBOutlet UIWebView *pageWebView;
}

-(id)initWithURL:(NSURL *)url;

@end
