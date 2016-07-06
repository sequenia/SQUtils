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
@property (nonatomic) NSInteger maxImagesCount;
@property (nonatomic, weak) UIViewController *sourceController;

- (void) presentInViewController:(UIViewController *)controller
              withCompletionAction:(void(^)(SQPhotoPickerSheet *picker, NSArray<SQPhoto *> *returnedImages))completion;

@end
