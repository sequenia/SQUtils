//
//  SQNewsListViewController.h
//  FitService
//
//  Created by Sequenia on 06/06/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SQNewsSelectDelegate.h"

@interface SQNewsListViewController : UITableViewController

@property (nonatomic, weak) id<NewsSelectDelegate> newsDelegate;
@property (nonatomic, strong) NSMutableArray *newsList;
@property (nonatomic) BOOL endReached;
@property (nonatomic) BOOL isAllItems;

- (void) registerCellWithIdentifier:(NSString *)identifier nibName:(NSString *)nibName;
- (void) loadNews;
- (void) loadNextPage;
- (void) resetNewsList;

@end
