//
//  SQNewsListViewController.m
//  FitService
//
//  Created by Sequenia on 06/06/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import "SQNewsListViewController.h"


@interface SQNewsListViewController (){
    double velocity;
    NSMutableArray *reuseIdentifiers;
}

@end

@implementation SQNewsListViewController

static double prevCallTime = 0;
static double prevCallOffset = 0;

- (void) viewDidLoad{
    [super viewDidLoad];
    reuseIdentifiers = [NSMutableArray array];
    _newsList = [NSMutableArray array];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void) registerCellWithIdentifier:(NSString *)identifier nibName:(NSString *)nibName{
    [self.tableView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:identifier];
    [reuseIdentifiers addObject:identifier];
}

- (void) loadNews{
    
}

- (void) loadNextPage{
    _endReached = YES;
    [self loadNews];
}

- (void) resetNewsList{
    _isAllItems = YES;
    _endReached = YES;
    [_newsList removeAllObjects];
    [self.tableView reloadData];
    [self loadNews];
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    double curCallTime = CACurrentMediaTime();
    double timeDelta = curCallTime - prevCallTime;
    double curCallOffset = self.tableView.contentOffset.y;
    double offsetDelta = curCallOffset - prevCallOffset;
    BOOL isScrollToBottom;
    if(prevCallOffset < curCallOffset)
        isScrollToBottom = YES;
    else
        isScrollToBottom = NO;
    
    velocity = fabs(offsetDelta / timeDelta);
    prevCallTime = curCallTime;
    prevCallOffset = curCallOffset;
    
    if(_newsList.count > 0){
        CGFloat cellHeight = [self tableView:self.tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        if (CGRectIntersectsRect(scrollView.bounds, CGRectMake(0, self.tableView.contentSize.height - cellHeight * 2.5, CGRectGetWidth(self.view.frame), cellHeight * 2.5)) && !_isAllItems && [_newsList count] != 0 && isScrollToBottom && !_endReached) {
            [self loadNextPage];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_newsList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifiers.firstObject forIndexPath:indexPath];
    return cell;
}

@end
