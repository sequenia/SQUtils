//
//  SQPageControl.m
//  Pods
//
//  Created by sequenia on 05/08/16.
//
//

#import "SQPageControl.h"

@implementation SQPageControl

- (void) setCurrentPage:(NSInteger)currentPage{
    [super setCurrentPage:currentPage];
    [self updateDots];
}

- (void) updateDots{
    for (int i = 0; i < [self.subviews count]; i++)
    {
        UIView* dotView = [self.subviews objectAtIndex:i];
        UIImageView* dot = nil;
        
        for (UIView* subview in dotView.subviews)
        {
            if ([subview isKindOfClass:[UIImageView class]])
            {
                dot = (UIImageView*)subview;
                break;
            }
        }
        
        if (dot == nil)
        {
            dot = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, dotView.frame.size.width, dotView.frame.size.height)];
            [dotView addSubview:dot];
        }
        
        if (i == self.currentPage)
        {
            if(self.activeImage)
                dot.image = self.activeImage;
        }
        else
        {
            if (self.inactiveImage)
                dot.image = self.inactiveImage;
        }
    }
}

@end
