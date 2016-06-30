#import <QuartzCore/QuartzCore.h>
#import "SeqOnboardingView.h"

static const CGFloat kAnimationDuration = 0.3f;
static const CGFloat kMaxLblWidth = 230.0f;
static const CGFloat kLblSpacing = 35.0f;
static const CGFloat kLineWidth = 0;
static const CGFloat kBordersDelta = 0;

@implementation SeqOnboardingView {
    CAShapeLayer *mask;
    CAShapeLayer *decorationLayer;
    NSUInteger markIndex;
    
    NSMutableArray *captions;
    UIView *closeView;
    
}

#pragma mark - Methods

- (id)initWithFrame:(CGRect)frame coachMarks:(NSArray *)marks {
    self = [super initWithFrame:frame];
    if (self) {
        // Save the coach marks
        self.coachMarks = marks;
        
        // Setup
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Setup
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Setup
        [self setup];
    }
    return self;
}

- (void)setup {
    // Default
    self.alpha = 0.0f;
    self.animationDuration = kAnimationDuration;
    self.maxLabelWidth = kMaxLblWidth;
    self.labelsSpacing = kLblSpacing;
    self.lineWidth = kLineWidth;
    self.bordersDelta = kBordersDelta;
    
    self.regularFontColor = [UIColor whiteColor];
    self.maskColor = [UIColor colorWithHue:0.0f saturation:0.0f brightness:0.0f alpha:0.8f];
    self.endFontColor = [UIColor whiteColor];
    self.elementBorderColor = [UIColor clearColor];
    
    self.captionFont = [UIFont systemFontOfSize:19.f];
    self.lastCaptionFont = [UIFont systemFontOfSize:19.f];
    
    self.skipAllEnable = YES;
    self.skipLabelFont = [UIFont systemFontOfSize:15.f];
    self.skipLabelColor = [UIColor whiteColor];
    
    // Shape layer mask
    mask = [CAShapeLayer layer];
    [mask setFillRule:kCAFillRuleEvenOdd];
    [mask setFillColor:[self.maskColor CGColor]];
    [self.layer addSublayer:mask];
    
    decorationLayer = [CAShapeLayer layer];
    [decorationLayer setFillColor:[UIColor clearColor].CGColor];
    [decorationLayer setStrokeColor:self.elementBorderColor.CGColor];
    decorationLayer.borderWidth = self.lineWidth;
    [self.layer addSublayer:decorationLayer];
    
    captions = [NSMutableArray array];
    
    // Capture touches
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userDidTap:)];
    [self addGestureRecognizer:tapGestureRecognizer];
}

#pragma mark - Mask color

- (void)setMaskColor:(UIColor *)maskColor {
    _maskColor = maskColor;
    [mask setFillColor:[maskColor CGColor]];
}

- (void) setElementBorderColor:(UIColor *)elementBorderColor{
    _elementBorderColor = elementBorderColor;
    [decorationLayer setStrokeColor:elementBorderColor.CGColor];
}

- (void) setLineWidth:(CGFloat)lineWidth{
    _lineWidth = lineWidth;
    decorationLayer.borderWidth = lineWidth;
}



#pragma mark - Touch handler

- (void)userDidTap:(UITapGestureRecognizer *)recognizer {
    // Go to the next coach mark
    [self goToCoachMarkIndexed:(markIndex+1)];
}

#pragma mark - Navigation

- (void)start {
    // Fade in self
    [UIView animateWithDuration:self.animationDuration
                     animations:^{
                         self.alpha = 1.0f;
                     }
                     completion:^(BOOL finished) {
                         [self goToCoachMarkIndexed:0];
                     }];
}

- (void)skipCoach {
    [self goToCoachMarkIndexed:self.coachMarks.count];
}

- (void)goToCoachMarkIndexed:(NSUInteger)index {
    // Out of bounds
    if (index >= self.coachMarks.count) {
        [self cleanup];
        return;
    }
    
    // Current index
    markIndex = index;
    
    // Delegate (coachMarksView:willNavigateTo:atIndex:)
    if ([self.delegate respondsToSelector:@selector(onboardingView:willNavigateToIndex:)]) {
        [self.delegate onboardingView:self willNavigateToIndex:markIndex];
    }
    
    NSDictionary *markDef = [self.coachMarks objectAtIndex:index];
    if(closeView && closeView.superview){
        [closeView removeFromSuperview];
    }
    
    for(UILabel *oldCaption in captions){
        [UIView animateWithDuration:_animationDuration animations:^{
            oldCaption.alpha = 0.f;
        } completion:^(BOOL finished) {
            [oldCaption removeFromSuperview];
        }];
    }
    [captions removeAllObjects];
    
    
    
    if(markIndex == 0){
        UIBezierPath *newPath = [UIBezierPath bezierPathWithRect:self.bounds];
        UIBezierPath *newDecorationPath = [UIBezierPath bezierPath];
        
        if([markDef objectForKey:kShapeElements]){
            for(NSDictionary *element in [markDef objectForKey:kShapeElements]){
                NSString *shape = [element objectForKey:kElementShape];
                if(!shape){
                    shape = kRoundedRectShape;
                }
                
                CGRect rect = [[element objectForKey:kElementRect] CGRectValue];
                NSArray *pathes = [self createMasksShape:shape withRect:rect withZeroSize:YES];
                [newPath appendPath:[pathes objectAtIndex:0]];
                [newDecorationPath appendPath:[pathes objectAtIndex:1]];
            }
        }
        [self changeLayer:mask withPath:newPath animated:NO];
        [self changeLayer:decorationLayer withPath:newDecorationPath animated:NO];
    }
    
    UIBezierPath *newPath = [UIBezierPath bezierPathWithRect:self.bounds];
    UIBezierPath *newDecorationPath = [UIBezierPath bezierPath];
    
    if(self.coachMarks.count > 1 && self.skipAllEnable){
        
        if(!closeView){
            CGFloat textWidth = MAX(70, [self widthForStringDrawing:@"Закрыть" font:self.skipLabelFont height:32]);
            closeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, textWidth + 52, 58)];
            closeView.userInteractionEnabled = YES;
            closeView.alpha = 0.f;
            [closeView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(skipAllTips:)]];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 26, 32, 32)];
            imageView.image = [UIImage imageNamed:@"ic_close_tips" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
            [closeView addSubview:imageView];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(52, 26, textWidth, 32)];
            label.textColor = self.skipLabelColor;
            label.font = self.skipLabelFont;
            label.numberOfLines = 0;
            label.textAlignment = NSTextAlignmentLeft;
            label.text = @"Закрыть";
            [closeView addSubview:label];
        }
        [self addSubview:closeView];
        [UIView animateWithDuration:_animationDuration animations:^{
            closeView.alpha = 1.f;
        } completion:^(BOOL finished) {
            
        }];
    }
    
    if([markDef objectForKey:kShapeElements]){
        for(NSDictionary *element in [markDef objectForKey:kShapeElements]){
            NSString *shape = [element objectForKey:kElementShape];
            if(!shape){
                shape = kRoundedRectShape;
            }
            
            CGRect rect = [[element objectForKey:kElementRect] CGRectValue];
            NSArray *pathes = [self createMasksShape:shape withRect:rect withZeroSize:NO];
            [newPath appendPath:[pathes objectAtIndex:0]];
            [newDecorationPath appendPath:[pathes objectAtIndex:1]];
            
            if([element objectForKey:kCaptionText]){
                UILabel *label = [self createCaptionLabelWithText:[element objectForKey:kCaptionText]];
                [self setPositionForLabel:label withMarkRect:rect];
                [self addSubview:label];
                [captions addObject:label];
            }
        }
    }
    
    if([markDef objectForKey:kCaptions]){
        for(NSDictionary *element in [markDef objectForKey:kCaptions]){
            UILabel *label = [self createCaptionLabelWithText:[element objectForKey:kCaptionText]];
            [self setPositionForLabel:label withCenter:[[element objectForKey:kCaptionCenter] CGPointValue]];
            [self addSubview:label];
            [captions addObject:label];
        }
    }
    
    NSString *lastLabelText;
    if(markIndex == self.coachMarks.count - 1){
        lastLabelText = @"Ок!";
    }
    else{
        lastLabelText = @"Далее";
    }
    
    UILabel *lastAddedLabel = [captions lastObject];
    
    UILabel *lastLabel = [self createCaptionLabelWithText:lastLabelText];
    lastLabel.textColor = self.endFontColor;
    lastLabel.font = self.lastCaptionFont;
    CGRect lastLabelRect = lastLabel.frame;
    lastLabelRect.origin.x = CGRectGetMinX(lastAddedLabel.frame);
    lastLabelRect.origin.y = CGRectGetMaxY(lastAddedLabel.frame) + (self.labelsSpacing / 2.f);
    [self addSubview:lastLabel];
    [captions addObject:lastLabel];
    
    CGRect lastFrame = lastAddedLabel.frame;
    lastFrame.origin.y -= CGRectGetHeight(lastLabel.frame);
    lastAddedLabel.frame = lastFrame;
    
    lastLabelRect.origin.y -= CGRectGetHeight(lastLabel.frame);
    lastLabel.frame = lastLabelRect;
    [self changeLayer:mask withPath:newPath animated:YES];
    [self changeLayer:decorationLayer withPath:newDecorationPath animated:YES];
    
    for(UILabel *caption in captions){
        [UIView animateWithDuration:_animationDuration animations:^{
            caption.alpha = 1.f;
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void) skipAllTips:(UIGestureRecognizer *)sender{
    closeView.alpha = 0.2f;
    [UIView animateWithDuration:0.3
                     animations:^{  closeView.alpha = 1;
                     }];
    [self goToCoachMarkIndexed:self.coachMarks.count];
}

- (NSArray *) createMasksShape:(NSString *)shape withRect:(CGRect)rect withZeroSize:(BOOL)needZeroSize{
    NSMutableArray *array = [NSMutableArray array];
    UIBezierPath *cutoutPath;
    
    if(needZeroSize){
        CGPoint center = CGPointMake(floorf(rect.origin.x + (rect.size.width / 2.0f)), floorf(rect.origin.y + (rect.size.height / 2.0f)));
        rect = (CGRect){center, CGSizeZero};
    }
    
    if ([shape isEqualToString:kCircleShape]){
        cutoutPath = [UIBezierPath bezierPathWithOvalInRect:rect];
    }
    else if ([shape isEqualToString:kRectShape])
        cutoutPath = [UIBezierPath bezierPathWithRect:rect];
    else
        cutoutPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:CGRectGetHeight(rect) / 2.f];
    [array addObject:cutoutPath];
    
    UIBezierPath *decorPath = [UIBezierPath bezierPathWithCGPath:cutoutPath.CGPath];
    decorPath.lineWidth = self.lineWidth;
    if(!needZeroSize){
        CGFloat xScale = (CGRectGetWidth(cutoutPath.bounds) + _bordersDelta) / CGRectGetWidth(cutoutPath.bounds);
        CGFloat yScale = (CGRectGetHeight(cutoutPath.bounds) + _bordersDelta) / CGRectGetHeight(cutoutPath.bounds);
        
        CGRect scaledRect = CGRectApplyAffineTransform(decorPath.bounds, CGAffineTransformMakeScale(xScale, yScale));
        [decorPath applyTransform:CGAffineTransformConcat(CGAffineTransformMakeScale(xScale, yScale), CGAffineTransformMakeTranslation(CGRectGetMidX(cutoutPath.bounds) - CGRectGetMidX(scaledRect), CGRectGetMidY(cutoutPath.bounds) - CGRectGetMidY(scaledRect)))];
    }
    
    [array addObject:decorPath];
    return array;
}

- (void) changeLayer:(CAShapeLayer *)layer withPath:(UIBezierPath *)path animated:(BOOL)animated{
    if(animated){
        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"path"];
        anim.delegate = self;
        anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        anim.duration = self.animationDuration;
        anim.removedOnCompletion = NO;
        anim.fillMode = kCAFillModeForwards;
        anim.fromValue = (__bridge id)(layer.path);
        anim.toValue = (__bridge id)(path.CGPath);
        [layer addAnimation:anim forKey:@"path"];
    }
    layer.path = path.CGPath;
}


- (UILabel *)createCaptionLabelWithText:(NSString *)string {
    UILabel *lblCaption = [[UILabel alloc] initWithFrame:CGRectZero];
    lblCaption.backgroundColor = [UIColor clearColor];
    lblCaption.textColor = self.regularFontColor;
    lblCaption.font = self.captionFont;
    lblCaption.lineBreakMode = NSLineBreakByWordWrapping;
    lblCaption.numberOfLines = 0;
    lblCaption.textAlignment = NSTextAlignmentCenter;
    lblCaption.alpha = 0.0f;
    lblCaption.text = string;
    CGFloat height = [self heightForStringDrawing:string font:lblCaption.font width:self.maxLabelWidth];
    lblCaption.frame = (CGRect){{0.0f, 0.0f}, {_maxLabelWidth, height}};
    
    return lblCaption;
}

- (void) setPositionForLabel:(UILabel *)label withCenter:(CGPoint)center{
    label.center = center;
}

- (void) setPositionForLabel:(UILabel *)label withMarkRect:(CGRect)markRect{
    CGFloat y = markRect.origin.y + markRect.size.height + _labelsSpacing;
    CGFloat bottomY = y + label.frame.size.height + _labelsSpacing;
    if (bottomY > self.bounds.size.height) {
        y = markRect.origin.y - _labelsSpacing - label.frame.size.height;
    }
    CGFloat x = MIN(CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetWidth(label.frame) - _labelsSpacing, CGRectGetMidX(markRect) - (CGRectGetWidth(label.frame) / 2));
    if(x < 0){
        x = _labelsSpacing;
    }
    
    // Animate the caption label
    label.frame = (CGRect){{x, y}, label.frame.size};
}

#pragma mark - Cleanup

- (void)cleanup {
    // Delegate (coachMarksViewWillCleanup:)
    if ([self.delegate respondsToSelector:@selector(onboardingViewWillCleanup:)]) {
        [self.delegate onboardingViewWillCleanup:self];
    }
    
    // Fade out self
    [UIView animateWithDuration:self.animationDuration
                     animations:^{
                         self.alpha = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         // Remove self
                         [self removeFromSuperview];
                         
                         // Delegate (coachMarksViewDidCleanup:)
                         if ([self.delegate respondsToSelector:@selector(onboardingViewDidCleanup:)]) {
                             [self.delegate onboardingViewDidCleanup:self];
                         }
                     }];
}

#pragma mark - Animation delegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    // Delegate (coachMarksView:didNavigateTo:atIndex:)
    if ([self.delegate respondsToSelector:@selector(onboardingView:didNavigateToIndex:)]) {
        [self.delegate onboardingView:self didNavigateToIndex:markIndex];
    }
}

- (float) heightForStringDrawing:(NSString *)myString font:(UIFont *)myFont width:(float) myWidth{
    if(myString == nil || myFont == nil)
        return 0;
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithString:myString];
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:CGSizeMake(myWidth, FLT_MAX)];
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    [layoutManager addTextContainer:textContainer];
    [textStorage addLayoutManager:layoutManager];
    [textStorage addAttribute:NSFontAttributeName value:myFont
                        range:NSMakeRange(0, [textStorage length])];
    [textContainer setLineFragmentPadding:0.0];
    (void) [layoutManager glyphRangeForTextContainer:textContainer];
    
    return [layoutManager usedRectForTextContainer:textContainer].size.height;
}

- (float) widthForStringDrawing:(NSString *)myString font:(UIFont *)myFont height:(float) myHeight{
    if(myString == nil || myFont == nil)
        return 0;
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithString:myString];
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:CGSizeMake(FLT_MAX, myHeight)];
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    [layoutManager addTextContainer:textContainer];
    [textStorage addLayoutManager:layoutManager];
    [textStorage addAttribute:NSFontAttributeName value:myFont
                        range:NSMakeRange(0, [textStorage length])];
    [textContainer setLineFragmentPadding:0.0];
    (void) [layoutManager glyphRangeForTextContainer:textContainer];
    
    return [layoutManager usedRectForTextContainer:textContainer].size.height;
}

@end
