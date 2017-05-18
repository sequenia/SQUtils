//
//  SQPhotoCache.m
//  PhotoTest
//
//  Created by Sequenia on 23/06/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import "SQPhotoCache.h"

@implementation SQPhotoCache {
    PHCachingImageManager *imageManager;
    NSCache *photoCache;
}

+(SQPhotoCache *)sharedCache
{
    static SQPhotoCache *_sharedInstance = nil;
    static dispatch_once_t onceSecurePredicate;
    dispatch_once(&onceSecurePredicate,^
                  {
                      _sharedInstance = [[self alloc] init];
                  });
    return _sharedInstance;
}

-(id) init{
    self = [super init];
    if(self){
        imageManager = [[PHCachingImageManager alloc] init];
        imageManager.allowsCachingHighQualityImages = YES;
        
        photoCache = [[NSCache alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_didReceiveMemoryWarning)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:nil];
    }
    return self;
}

- (void)_didReceiveMemoryWarning {
    [photoCache removeAllObjects];
}

- (void) requestImageForAsset:(PHAsset *)asset
               withTargetSize:(CGSize)size
                      options:(PHImageRequestOptions *)options
                   completion:(void (^)(UIImage *))completion {
    if(asset.pixelWidth == size.width && asset.pixelHeight == size.height){
        [imageManager requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage *result, NSDictionary *info) {
            if(result){
                [photoCache setObject:result forKey:asset.localIdentifier];
            }
            completion(result);
        }];
    }
    else{
        if(asset) {
            if([photoCache objectForKey:asset.localIdentifier]){
                completion([photoCache objectForKey:asset.localIdentifier]);
            }
            else{
                [imageManager startCachingImagesForAssets:@[asset] targetSize:size contentMode:PHImageContentModeAspectFill options:options];
                [imageManager requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage *result, NSDictionary *info) {
                    if(result){
                        [photoCache setObject:result forKey:asset.localIdentifier];
                    }
                    completion(result);
                }];
            }
        }
        else {
            completion(nil);
        }
    }
}

@end
