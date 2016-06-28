//
//  SQPhotoGridControllerController.m
//  PhotoTest
//
//  Created by Sequenia on 23/06/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import "SQPhotoGridViewController.h"
#import "LocalizeHeader.h"

#import "SQPhoto.h"
#import "SQAlbum.h"

#import <Photos/Photos.h>
#import <PhotosUI/PhotosUI.h>
#import "SQAlbumListViewController.h"

@interface SQPhotoGridViewController () {
    NSMutableArray *photos;
    CGFloat picSide;
    UIActivityIndicatorView *loaderIndicator;
    
    UIButton *doneButton;
}

@end

@implementation SQPhotoGridViewController

static NSString * const reuseIdentifier = @"SQPhotoPreviewCell";

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.collectionView registerNib:[UINib nibWithNibName:reuseIdentifier bundle:[NSBundle bundleForClass:[self class]]] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    loaderIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [loaderIndicator setColor:[UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0]];
    [loaderIndicator setHidesWhenStopped:YES];
    loaderIndicator.transform = CGAffineTransformMakeScale(0.8, 0.8);
    loaderIndicator.center = CGPointMake(self.collectionView.center.x, self.collectionView.center.y - 64);
    [self.collectionView addSubview:loaderIndicator];
    
    photos = [NSMutableArray array];
    
    picSide = ([UIScreen mainScreen].bounds.size.width / 4) - 0.8;

    
    doneButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 130, 30)];
    doneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self updateDoneButtonTitle];
    [doneButton setTitleColor:self.navigationController.toolbar.tintColor forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(finishPick) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -5;
    
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:LOCALIZE(@"cancel_pick") style:UIBarButtonItemStylePlain target:self action:@selector(dismissGrid)];
    
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *completePick = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    
    
    [self setToolbarItems:@[cancel, flex, completePick, negativeSpacer] animated:YES];
    
    [self.navigationItem setTitle:_album.assetCollection.localizedTitle];
    
    [loaderIndicator startAnimating];
    [self getPhotos];
}

- (void) dismissGrid{
    [_parent.listDelegate listControllerDidCancel:_parent];
}

- (void) finishPick{
    [self.gridDelegate photoGridDidFinishPick:self];
}

-(void) getPhotos{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        PHFetchOptions *onlyImagesOptions = [PHFetchOptions new];
        onlyImagesOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType = %i", PHAssetMediaTypeImage];
        onlyImagesOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
        PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:self.album.assetCollection options:onlyImagesOptions];
        for(int i = 0; i < result.count; i++){
            PHAsset *asset = result[i];
            SQPhoto *photo = [[SQPhoto alloc] init];
            photo.isSelected = NO;
            photo.asset = asset;
            [photos addObject:photo];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [loaderIndicator stopAnimating];
            [self.collectionView reloadData];
        });
    });
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return photos.count;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.4;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(picSide, picSide);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell =  [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    SQPhoto *photo = [photos objectAtIndex:indexPath.row];
    
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:100];
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    imageView.image = [UIImage new];
    [photo getPhotoPreviewSyncronous:YES size:CGSizeMake(picSide, picSide) withCompletion:^(UIImage *previewImage) {
        imageView.image = previewImage;
    }];
    
    UIImageView *checkmark = (UIImageView *)[cell viewWithTag:200];
    if(_maxImagesCount == 1){
        checkmark.hidden = YES;
    }
    else{
        checkmark.hidden = NO;
    }

    if(photo.isSelected){
        checkmark.image = [UIImage imageNamed:@"checkmark"];
    }
    else{
        checkmark.image = [UIImage imageNamed:@"empty_checkmark"];
    }
    
    return cell;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SQPhoto *photo = [photos objectAtIndex:indexPath.row];
    if(photo.isSelected){
        photo.isSelected = NO;
        _currentSelectedCount = [self.gridDelegate photoGrid:self didSelectPhoto:photo];
        [UIView performWithoutAnimation:^{
            [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
        }];
    }
    else{
        if(_currentSelectedCount < _maxImagesCount){
            photo.isSelected = YES;
            _currentSelectedCount = [self.gridDelegate photoGrid:self didSelectPhoto:photo];
            if(_maxImagesCount == 1){
                [self finishPick];
                return;
            }
            else{
                [UIView performWithoutAnimation:^{
                    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
                }];
            }
        }
        else{
            [[[UIAlertView alloc] initWithTitle:LOCALIZE(@"limit_reached") message:[NSString stringWithFormat:@"%@ %ld %@", LOCALIZE(@"limit_desc"), (long)_maxImagesCount, LOCALIZE(@"photo")] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        }
    }
    [self updateDoneButtonTitle];
}

- (void) updateDoneButtonTitle{
    NSString *string = @"";
    if(_currentSelectedCount != 0){
        string = [NSString stringWithFormat:@"(%ld) ", (long)_currentSelectedCount];
    }
    string = [string stringByAppendingString:LOCALIZE(@"send_photos")];
    [doneButton setTitle:string forState:UIControlStateNormal];
}

@end
