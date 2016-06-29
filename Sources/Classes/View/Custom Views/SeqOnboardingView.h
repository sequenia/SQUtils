#import <UIKit/UIKit.h>

@protocol SeqOnboardingViewDelegate;

static NSString * const kShapeElements      = @"kShapeElements";
static NSString * const kElementRect        = @"kElementRect";
static NSString * const kElementShape       = @"kElementShape";
static NSString * const kCircleShape        = @"kCircleShape";
static NSString * const kRectShape          = @"kRectShape";
static NSString * const kRoundedRectShape   = @"kRoundedRectShape";

static NSString * const kCaptions      = @"kCaptions";
static NSString * const kCaptionText   = @"kCaptionText";
static NSString * const kCaptionCenter = @"kCaptionCenter";

@interface SeqOnboardingView : UIView

@property (nonatomic, weak) id<SeqOnboardingViewDelegate> delegate;

@property (nonatomic, strong) NSArray *coachMarks;

@property (nonatomic) CGFloat animationDuration;
@property (nonatomic) CGFloat maxLabelWidth;
@property (nonatomic) CGFloat labelsSpacing;
@property (nonatomic) CGFloat lineWidth;
@property (nonatomic) CGFloat bordersDelta;

@property (nonatomic, strong) UIColor *maskColor;
@property (nonatomic, strong) UIColor *elementBorderColor;
@property (nonatomic, strong) UIColor *regularFontColor;
@property (nonatomic, strong) UIColor *endFontColor;

@property (nonatomic, strong) UIFont *captionFont;
@property (nonatomic, strong) UIFont *lastCaptionFont;

@property (nonatomic) BOOL skipAllEnable;
@property (nonatomic, strong) UIFont *skipLabelFont;
@property (nonatomic, strong) UIColor *skipLabelColor;


- (id)initWithFrame:(CGRect)frame coachMarks:(NSArray *)marks;
- (void)start;

@end

@protocol SeqOnboardingViewDelegate <NSObject>

@optional
- (void)onboardingView:(SeqOnboardingView*)onboardingView willNavigateToIndex:(NSUInteger)index;
- (void)onboardingView:(SeqOnboardingView*)onboardingView didNavigateToIndex:(NSUInteger)index;
- (void)onboardingViewWillCleanup:(SeqOnboardingView*)onboardingView;
- (void)onboardingViewDidCleanup:(SeqOnboardingView*)onboardingView;

@end