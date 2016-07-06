//
//  NKPagingBehavior.h
//  GeoSearch
//
//  Created by Nikolay Kagala on 28/03/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import "NKBehavior.h"

@interface NKPagingBehavior : NKBehavior

@property (weak, nonatomic) IBOutlet UIPageControl* pageControl;

@property (weak, nonatomic) IBOutlet UIButton* skipButton;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray<UIView *>* pages;

@end
