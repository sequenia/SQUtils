//
//  SQPhotoPreviewCollection.m
//  PhotoTest
//
//  Created by Sequenia on 22/06/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import "SQPhotoPreviewCollection.h"
#import "SQPhotoPreviewLayout.h"

#import "SQPhoto.h"
#import <Photos/Photos.h>
#import <PhotosUI/PhotosUI.h>

#import "LocalizeHeader.h"

@interface SQPhotoPreviewCollection () <UICollectionViewDataSource, UICollectionViewDelegate> {
    BOOL hasSelection;
    NSInteger selectedCount;
}

@end

static NSString * const reuseIdentifier = @"SQPhotoPreviewCell";

@implementation SQPhotoPreviewCollection

- (id)initWithFrame:(CGRect)frame{
    SQPhotoPreviewLayout *layout = [[SQPhotoPreviewLayout alloc] init];
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if(self){
        [self initialize];
    }
    return self;
}

- (void) initialize{
    self.backgroundColor = [UIColor clearColor];
    self.dataSource = self;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.delegate = self;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    
    selectedCount = 0;
    hasSelection = NO;
    
    [self registerNib:[UINib nibWithNibName:reuseIdentifier bundle:[NSBundle bundleForClass:[self class]]] forCellWithReuseIdentifier:reuseIdentifier];
}

- (void) setAllPhotos:(NSArray *)allPhotos{
    _allPhotos = allPhotos;
    selectedCount = [_allPhotos filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isSelected = YES"]].count;
    if(selectedCount > 0)
        hasSelection = YES;
    else{
        hasSelection = NO;
    }
    [self reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _allPhotos.count;
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height =  CGRectGetHeight(self.frame) - 12;
    SQPhoto *photo = [_allPhotos objectAtIndex:indexPath.row];
    return CGSizeMake(height * photo.asset.pixelWidth / photo.asset.pixelHeight, height);
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell =  [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    SQPhoto *photo = [_allPhotos objectAtIndex:indexPath.row];
    
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:100];
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.image = [UIImage new];
    [photo getPhotoPreviewWithCompletion:^(UIImage *previewImage) {
        imageView.image = previewImage;
    }];
    
    UIImageView *checkmark = (UIImageView *)[cell viewWithTag:200];
    
    if(hasSelection && _maxImagesCount > 1){
        checkmark.hidden = NO;
    }
    else{
        checkmark.hidden = YES;
    }
    
    if(photo.isSelected){
        checkmark.image = [UIImage imageNamed:@"checkmark" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
    }
    else{
        checkmark.image = [UIImage imageNamed:@"empty_checkmark" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
    }
    
    return cell;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SQPhoto *photo = [_allPhotos objectAtIndex:indexPath.row];
    
    
    if(photo.isSelected){
        selectedCount--;
        photo.isSelected = NO;
    }
    else{
        if(selectedCount == _maxImagesCount){
            [[[UIAlertView alloc] initWithTitle:LOCALIZE(@"limit_reached") message:[NSString stringWithFormat:@"%@ %ld %@", LOCALIZE(@"limit_desc"), (long)_maxImagesCount, LOCALIZE(@"photo")] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        }
        else{
            selectedCount++;
            photo.isSelected = YES;
        }
        
    }
    
    BOOL prevSelectionState = hasSelection;
    
    if(selectedCount == 0){
        hasSelection = NO;
    }
    else{
        hasSelection = YES;
    }
    
    [self updateCheckmarks];
    if(prevSelectionState != hasSelection){
        [self reloadData];
    }
    else{
        [self reloadItemsAtIndexPaths:@[indexPath]];
    }
    
    [self.previewDelegate previewCollection:self didChangeSelectedCount:selectedCount clickedIndex:indexPath.row];
    
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView{
    [self updateCheckmarks];
}

- (void) updateCheckmarks{
    NSArray *sortedPathes = [[self indexPathsForVisibleItems] sortedArrayUsingDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"row" ascending:YES]]];
    
    NSIndexPath *lastVisibleIndexPath = [NSIndexPath indexPathForItem:[sortedPathes.lastObject row] inSection:0];
    
    NSIndexPath *prevVisibleIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    if(sortedPathes.count > 1){
        prevVisibleIndexPath = [NSIndexPath indexPathForItem:[[sortedPathes objectAtIndex:sortedPathes.count - 2] row] inSection:0];
    }
    
    UICollectionViewCell *lastCell = [self cellForItemAtIndexPath:lastVisibleIndexPath];
    
    UIView *lastCheckmark = [lastCell viewWithTag:200];
    CGRect lastMarkRect = [lastCell convertRect:lastCheckmark.frame toView:self];
    
    
    UICollectionViewCell *prevCell = [self cellForItemAtIndexPath:prevVisibleIndexPath];
    
    UIView *prevCheckmark = [prevCell viewWithTag:200];
    CGRect prevMarkRect = [prevCell convertRect:prevCheckmark.frame toView:self];
    
    CGFloat prevDelta = fabs(CGRectGetMaxX(prevMarkRect) - self.contentOffset.x - CGRectGetWidth(self.frame));
    CGFloat lastDelta = CGRectGetMinX(lastMarkRect) - self.contentOffset.x - CGRectGetWidth(self.frame);
    
    SQPhoto *photo = [_allPhotos objectAtIndex:lastVisibleIndexPath.row];
    
    BOOL visible;
    if(lastDelta <= -5 || prevDelta <= 43 || selectedCount == 0){
        visible = NO;
    }
    else{
        visible = photo.isSelected;
    }
    [self.previewDelegate previewCollection:self setCheckmarkVisible:visible];
}


@end
