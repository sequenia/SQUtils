//
//  BuyButton.m
//  VseMayki
//
//  Created by Sequenia on 15/12/15.
//  Copyright © 2015 Sequenia. All rights reserved.
//

#import "SeqButton.h"


@implementation SeqButton

- (id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self initDefaultValues];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self initDefaultValues];        
    }
    return self;
}

- (void) initDefaultValues{
    _borderColor = [UIColor clearColor];
    _borderWidth = 0.f;
    _cornerRadius = 0.f;
    _allowHighlightBorder = NO;
}

- (void)awakeFromNib{
    self.layer.cornerRadius = self.cornerRadius;
    self.layer.borderWidth = self.borderWidth;
    self.layer.borderColor = self.borderColor.CGColor;
}

- (void) setBorderColor:(UIColor *)borderColor{
    _borderColor = borderColor;
    self.layer.borderColor = borderColor.CGColor;
}

- (void) setCornerRadius:(CGFloat)cornerRadius{
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
}

- (void)setBorderWidth:(CGFloat)borderWidth{
    _borderWidth = borderWidth;
    self.layer.borderWidth = borderWidth;
}

-(void) setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    if(self.allowHighlightBorder){
        if(highlighted){
            self.layer.borderColor = [[_borderColor colorWithAlphaComponent:0.4] CGColor];
        }
        else{
            self.layer.borderColor = [_borderColor CGColor];
        }
    }
}
@end
