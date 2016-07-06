//
//  GaleryPhoto.h
//  PhotoTest
//
//  Created by Sequenia on 22/06/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import <UIKIt/UIKit.h>

@class PHAsset;

@interface SQPhoto : NSObject

@property PHAsset *asset;
@property BOOL isSelected;

@property UIImage *originalImage;


- (void) getPhotoPreviewWithCompletion:(void(^)(UIImage *previewImage))completion;
- (void) getPhotoPreviewSize:(CGSize)size withCompletion:(void(^)(UIImage *previewImage))completion;
- (void) getPhotoPreviewSyncronous:(BOOL)sincronous size:(CGSize)size withCompletion:(void(^)(UIImage *previewImage))completion;

- (void) getPhotoOriginalAsync:(void(^)(UIImage *originalPhoto))completion;
- (UIImage *) getPhotoOriginalSync;

@end
