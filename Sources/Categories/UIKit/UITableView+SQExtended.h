//
//  UITableView+SQExtended.h
//  GeoSearch
//
//  Created by Nick on 01/03/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (SQExtended)

- (void)sq_beginUpdatesBlock: (void(^)()) updateBlock
              withCompletion: (void(^)()) completion;

- (void)sq_setHeaderView: (UIView*) view animated: (BOOL) animated;

- (void)sq_setFooterView: (UIView*) view animated: (BOOL) animated;

- (void)sq_reloadSection:(NSInteger)section withRowAnimation:(UITableViewRowAnimation)rowAnimation;

@end
