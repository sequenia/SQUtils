//
//  GaleryPhoto.m
//  PhotoTest
//
//  Created by Sequenia on 22/06/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import "SQPhoto.h"
#import <SQUtils/SQCategories.h>
#import "SQPhotoCache.h"

@implementation SQPhoto

- (void) getPhotoPreviewWithCompletion:(void (^)(UIImage *))completion {
    CGSize size = CGSizeMake(280 * _asset.pixelWidth / _asset.pixelHeight, 280);
    [self getPhotoPreviewSyncronous:NO size:size withCompletion:completion];
}

- (void) getPhotoPreviewSize:(CGSize)size withCompletion:(void (^)(UIImage *))completion{
    [self getPhotoPreviewSyncronous:NO size:size withCompletion:completion];
}

- (void) getPhotoPreviewSyncronous:(BOOL)sincronous size:(CGSize)size withCompletion:(void(^)(UIImage *previewImage))completion{
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = sincronous;
    options.resizeMode = PHImageRequestOptionsResizeModeNone;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    options.networkAccessAllowed = YES;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[SQPhotoCache sharedCache] requestImageForAsset:_asset withTargetSize:size options:options completion:^(UIImage * image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(image);
            });
        }];
    });
}

- (void) getPhotoOriginalAsync:(void(^)(UIImage *originalPhoto))completion{
    if(_originalImage){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *scaledImage = [_originalImage sq_scaleProportionalToMaxSide:_maxPhotoSide];
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(scaledImage);
            });
        });
        
    }
    else{
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.synchronous = YES;
        options.deliveryMode =  PHImageRequestOptionsDeliveryModeHighQualityFormat;
        options.resizeMode = PHImageRequestOptionsResizeModeExact;
        options.networkAccessAllowed = YES;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[SQPhotoCache sharedCache] requestImageForAsset:_asset withTargetSize:CGSizeMake(_asset.pixelWidth, _asset.pixelHeight) options:options completion:^(UIImage *image) {
                UIImage *scaledImage = [image sq_scaleProportionalToMaxSide:_maxPhotoSide];
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(scaledImage);
                });
            }];
        });
    }
}

- (UIImage *) getPhotoOriginalSync{
    if(_originalImage){
        return [_originalImage sq_scaleProportionalToMaxSide:_maxPhotoSide];
    }
    else{
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.synchronous = YES;
        options.deliveryMode =  PHImageRequestOptionsDeliveryModeHighQualityFormat;
        options.resizeMode = PHImageRequestOptionsResizeModeExact;
        options.networkAccessAllowed = YES;
        __block UIImage *imageBlock = nil;
        [[SQPhotoCache sharedCache] requestImageForAsset:_asset withTargetSize:CGSizeMake(_asset.pixelWidth, _asset.pixelHeight) options:options completion:^(UIImage *image) {
            image = [image sq_scaleProportionalToMaxSide:_maxPhotoSide];
            UIImage *scaledImage = [image sq_scaleProportionalToMaxSide:_maxPhotoSide];
            imageBlock = scaledImage;
        }];
        return imageBlock;
    }
}

- (NSString *)getPhotoURLString{
    __block NSString *imagePath = nil;
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = YES;
    options.deliveryMode =  PHImageRequestOptionsDeliveryModeOpportunistic;
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    options.networkAccessAllowed = YES;
    [[PHImageManager defaultManager] requestImageForAsset:_asset targetSize:CGSizeMake(_asset.pixelWidth, _asset.pixelHeight) contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage *result, NSDictionary *info) {
        imagePath = [info objectForKey:@"PHImageFileURLKey"];
    }];
    return imagePath;
}


@end
