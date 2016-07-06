//
//  SQAlbum.m
//  PhotoTest
//
//  Created by Sequenia on 23/06/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import "SQAlbum.h"
#import "SQPhotoCache.h"

@implementation SQAlbum

- (void) setAssetCollection:(PHAssetCollection *)assetCollection{
    _assetCollection = assetCollection;
    
    PHFetchOptions *onlyImagesOptions = [PHFetchOptions new];
    onlyImagesOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType = %i", PHAssetMediaTypeImage];
    onlyImagesOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:_assetCollection options:onlyImagesOptions];
    
    _photosCount = assetsFetchResult.count;
}

- (void) getAlbumCoverWithCompletion:(void (^)(UIImage *previewImage))completion{
    PHFetchOptions *onlyImagesOptions = [PHFetchOptions new];
    onlyImagesOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType = %i", PHAssetMediaTypeImage];
    onlyImagesOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:_assetCollection options:onlyImagesOptions];
    
    if(assetsFetchResult.count > 0){
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.synchronous = YES;
        options.resizeMode = PHImageRequestOptionsResizeModeFast;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
        options.networkAccessAllowed = YES;
        CGSize size = CGSizeMake(180, 180);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[SQPhotoCache sharedCache] requestImageForAsset:[assetsFetchResult objectAtIndex:0] withTargetSize:size options:options completion:^(UIImage * image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(image);
                });
            }];
        });
    }
}

@end
