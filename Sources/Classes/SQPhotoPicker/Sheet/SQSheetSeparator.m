//
//  SQSheetSeparator.m
//  PhotoTest
//
//  Created by Sequenia on 22/06/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import "SQSheetSeparator.h"

@implementation SQSheetSeparator

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.restorationIdentifier = @"SQSheetSeparator";
        self.accessibilityIdentifier = @"SQSheetSeparator";
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.05];
    }
    
    return self;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    self.frame = layoutAttributes.frame;
}

@end
