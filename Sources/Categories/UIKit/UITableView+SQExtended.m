//
//  UITableView+SQExtended.m
//  GeoSearch
//
//  Created by Nick on 01/03/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import "UITableView+SQExtended.h"

@implementation UITableView (SQExtended)

- (void)sq_beginUpdatesBlock: (void(^)()) updateBlock
              withCompletion: (void(^)()) completion {
    
    [CATransaction begin];
    
    [CATransaction setCompletionBlock:^{
        if (completion){
            completion();
        }
    }];
    
    [self beginUpdates];
    
    if (updateBlock){
        updateBlock();
    }
    
    [self endUpdates];
    
    [CATransaction commit];
    
}

- (void)sq_setHeaderView: (UIView*) view animated: (BOOL) animated {
    if (!animated){
        self.tableHeaderView = view;
    } else {
        [UIView beginAnimations:nil context: NULL];
        self.tableHeaderView = view;
        [UIView commitAnimations];
    }
}

- (void)sq_setFooterView: (UIView*) view animated: (BOOL) animated {
    if (!animated){
        self.tableFooterView = view;
    } else {
        [UIView beginAnimations:nil context: NULL];
        self.tableFooterView = view;
        [UIView commitAnimations];
    }
}

- (void)sq_reloadSection:(NSInteger)section withRowAnimation:(UITableViewRowAnimation)rowAnimation {
    NSRange range = NSMakeRange(section, 1);
    NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
    [self reloadSections:sectionToReload withRowAnimation:rowAnimation];
}

@end
