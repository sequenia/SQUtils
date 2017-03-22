//
//  SQPhotoSheetCollection.h
//  PhotoTest
//
//  Created by Sequenia on 21/06/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const kMyPhotosAction  = @"my_photos";
static NSString * const kPickPhotoAction = @"pick_photo";
static NSString * const kICloudAction    = @"i_cloud_photos";
static NSString * const kSendAction      = @"send_photos";
static NSString * const kCancelAction    = @"cancel_pick";

@protocol SQSheetDelegate;

@interface SQPhotoSheetCollection : UICollectionView

@property (nonatomic, weak) id<SQSheetDelegate> sheetDelegate;
@property (nonatomic) NSInteger maxImagesCount;

@property (nonatomic, strong) UIImage *checkmarkIcon;
@property (nonatomic, strong) UIImage *emptyCheckmarkIcon;

@property (nonatomic, strong) UIColor *sheetTextColor;
@property (nonatomic, strong) UIFont *sheetTextFont;

@end

@protocol SQSheetDelegate <NSObject>

@optional
- (void)sheet:(SQPhotoSheetCollection*)sheet didClickAction:(NSString *)action;
- (void)sheet:(SQPhotoSheetCollection*)sheet willChangeHeight:(CGFloat)newHeight;
- (void)sheet:(SQPhotoSheetCollection*)sheet didReturnImages:(NSArray *)images;
@end
