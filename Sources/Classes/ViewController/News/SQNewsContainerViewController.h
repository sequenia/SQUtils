//
//  SQNewsContainerViewController.h
//  FitService
//
//  Created by Sequenia on 06/06/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SQNewsSelectDelegate.h"

@interface SQNewsContainerViewController : UIViewController <NewsSelectDelegate>

@property (strong, nonatomic) UISegmentedControl *dateSegmentControl;
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) UIImageView *underLine;
@property (strong, nonatomic) NSMutableArray *newsPages;

- (void) initPagesWithTitles:(NSArray *)titles;
- (void) initPages;
- (void) showNewsDetail:(id)news;

@end
