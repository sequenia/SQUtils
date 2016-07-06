//
//  SQPhotoGridControllerController.h
//  PhotoTest
//
//  Created by Sequenia on 23/06/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SQPhoto;
@class SQAlbumListViewController;
@class SQAlbum;

@protocol SQPhotoGridSelectionDelegate;

@interface SQPhotoGridViewController : UICollectionViewController

@property (nonatomic, weak) id<SQPhotoGridSelectionDelegate> gridDelegate;
@property (nonatomic, weak) SQAlbumListViewController *parent;
@property (nonatomic, weak) SQAlbum *album;
@property (nonatomic) NSInteger maxImagesCount;
@property (nonatomic) NSInteger currentSelectedCount;
@end

@protocol SQPhotoGridSelectionDelegate <NSObject>

@optional
- (NSInteger)photoGrid:(SQPhotoGridViewController*)collection didSelectPhoto:(SQPhoto *)photo;
- (void)photoGridDidFinishPick:(SQPhotoGridViewController*)collection;
@end