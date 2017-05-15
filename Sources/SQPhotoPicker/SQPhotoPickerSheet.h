//
//  SQPhotoPickerSheet.h
//  PhotoTest
//
//  Created by Sequenia on 21/06/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SQPhoto.h"

@interface SQPhotoPickerSheet : UIViewController

@property (strong, nonatomic) void (^completionAction)(SQPhotoPickerSheet *picker, NSArray<SQPhoto *> *returnedImages);
@property (strong, nonatomic) void (^dismissAction)(SQPhotoPickerSheet *picker);
@property (strong, nonatomic) void (^accessDeniedAction)(SQPhotoPickerSheet *picker);
@property (strong, nonatomic) void (^pickerSheetClicked)(NSString *type);
@property (nonatomic) NSInteger maxImagesCount;
@property (nonatomic, weak) UIViewController *sourceController;

@property (nonatomic, strong) UIColor *navigationBarBackgroundColor;
@property (nonatomic, strong) UIColor *navigationBarTintColor;
@property (nonatomic, strong) UIFont *navigationBarTitleFont;

@property (nonatomic, strong) UIColor *toolbarTintColor;
@property (nonatomic, strong) UIFont *toolbarButtonFont;

@property (nonatomic, strong) UIImage *checkmarkIcon;
@property (nonatomic, strong) UIImage *emptyCheckmarkIcon;

@property (nonatomic, strong) UIColor *sheetTextColor;
@property (nonatomic, strong) UIFont *sheetTextFont;

@property (nonatomic) CGFloat maxPhotoSide;

- (void) presentInViewController:(UIViewController *)controller
              withCompletionAction:(void(^)(SQPhotoPickerSheet *picker, NSArray<SQPhoto *> *returnedImages))completion;

@end
