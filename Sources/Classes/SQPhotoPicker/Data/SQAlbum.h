//
//  SQAlbum.h
//  PhotoTest
//
//  Created by Sequenia on 23/06/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import <Photos/Photos.h>
#import <PhotosUI/PhotosUI.h>

@interface SQAlbum : NSObject

@property (nonatomic, readonly) NSInteger photosCount;
@property (nonatomic, strong) PHAssetCollection *assetCollection;
@property (nonatomic) PHAssetCollectionSubtype albumType;

- (void) getAlbumCoverWithCompletion:(void(^)(UIImage *previewImage))completion;

@end
