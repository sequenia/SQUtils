//
//  SQPhotoCache.h
//  PhotoTest
//
//  Created by Sequenia on 23/06/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import <Photos/Photos.h>
#import <PhotosUI/PhotosUI.h>

@interface SQPhotoCache : NSObject

+ (SQPhotoCache *) sharedCache;

- (void) requestImageForAsset:(PHAsset *)asset
               withTargetSize:(CGSize)size
                      options:(PHImageRequestOptions *)options
                   completion:(void (^)(UIImage *))completion;


@end
