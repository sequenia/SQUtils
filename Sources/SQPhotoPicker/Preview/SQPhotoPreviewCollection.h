//
//  SQPhotoPreviewCollection.h
//  PhotoTest
//
//  Created by Sequenia on 22/06/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SQPhotoPreviewCollectionDelegate;

@interface SQPhotoPreviewCollection : UICollectionView

@property (nonatomic, weak) id<SQPhotoPreviewCollectionDelegate> previewDelegate;
@property (nonatomic, weak) NSArray *allPhotos;
@property (nonatomic) NSInteger maxImagesCount;
@property (nonatomic, strong) UIImage *checkmarkIcon;
@property (nonatomic, strong) UIImage *emptyCheckmarkIcon;


@end

@protocol SQPhotoPreviewCollectionDelegate <NSObject>

@optional
- (void)previewCollection:(SQPhotoPreviewCollection*)collection setCheckmarkVisible:(BOOL)visible;
- (void)previewCollection:(SQPhotoPreviewCollection *)collection didChangeSelectedCount:(NSInteger)newSelectedCount clickedIndex:(NSInteger)index;
@end
