//
//  SQPhotoSheetCollection.m
//  PhotoTest
//
//  Created by Sequenia on 21/06/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import "SQPhotoSheetCollection.h"
#import "SQSheetLayout.h"
#import "SQPhotoPreviewCollection.h"

#import "SQPhoto.h"

#import <Photos/Photos.h>
#import <PhotosUI/PhotosUI.h>

#import "LocalizeHeader.h"

@interface SQPhotoSheetCollection () <UICollectionViewDataSource, UICollectionViewDelegate, SQPhotoPreviewCollectionDelegate> {
    NSArray *actions;
    CGFloat previewCellHeight;
    
    SQPhotoPreviewCollection *previewCollection;
    
    UIImageView *checkmarkView;
    NSMutableArray *allPhotos;
    
    NSInteger selectedCount;
}

@end

static NSString * const previewReuseIdentifier = @"SQPreviewCell";
static NSString * const actionReuseIdentifier = @"SQActionCell";

static CGFloat const smallHeight = 158;
static CGFloat const bigHeight = 268;

@implementation SQPhotoSheetCollection

- (id)initWithFrame:(CGRect)frame{
    SQSheetLayout *layout = [[SQSheetLayout alloc] init];
    layout.previewCellHeight = smallHeight;
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if(self){
        [self initialize];
    }
    return self;
}

- (void) initialize{
    self.backgroundColor = [UIColor clearColor];
    selectedCount = 0;
    self.dataSource = self;
    self.delegate = self;
    self.bounces = NO;
    self.alwaysBounceVertical = NO;
    self.alwaysBounceHorizontal = NO;
    previewCellHeight = smallHeight;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    
    previewCollection = [[SQPhotoPreviewCollection alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), smallHeight)];
    previewCollection.previewDelegate = self;
    
    actions = @[kMyPhotosAction, kPickPhotoAction, kICloudAction];
    allPhotos = [NSMutableArray array];
    
    
    PHFetchOptions *onlyImagesOptions = [PHFetchOptions new];
    onlyImagesOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType = %i", PHAssetMediaTypeImage];
    onlyImagesOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    
    PHFetchResult *fetch = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                                    subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    
    for(PHAssetCollection *assetCollection in fetch){
        PHFetchResult *photosOnCollection = [PHAsset fetchAssetsInAssetCollection:assetCollection options:onlyImagesOptions];
        for(PHAsset *asset in photosOnCollection){
            SQPhoto *photo = [[SQPhoto alloc] init];
            photo.isSelected = NO;
            photo.asset = asset;
            [allPhotos addObject:photo];
        }
    }
    [previewCollection setAllPhotos:allPhotos];
    
    [self registerNib:[UINib nibWithNibName:previewReuseIdentifier bundle:[NSBundle bundleForClass:[self class]]] forCellWithReuseIdentifier:previewReuseIdentifier];
    [self registerNib:[UINib nibWithNibName:actionReuseIdentifier bundle:[NSBundle bundleForClass:[self class]]] forCellWithReuseIdentifier:actionReuseIdentifier];
}

- (void) setMaxImagesCount:(NSInteger)maxImagesCount{
    _maxImagesCount = maxImagesCount;
    previewCollection.maxImagesCount = maxImagesCount;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(section == 1)
        return 1;
    return actions.count + 1;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0 && indexPath.row == 0)
        return CGSizeMake(CGRectGetWidth(self.frame), previewCellHeight);
    return CGSizeMake(CGRectGetWidth(self.frame), 55);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if(section == 1)
        return UIEdgeInsetsMake(10, 0, 10, 0);
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0 && indexPath.section == 0)
        return NO;
    return YES;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell;
    if(indexPath.section == 0 && indexPath.row == 0){
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:previewReuseIdentifier forIndexPath:indexPath];
        cell.backgroundColor = [UIColor colorWithWhite:246/255.f alpha:0.9f];
        
        checkmarkView = (UIImageView *)[cell viewWithTag:200];
        
        for(UIView *view in cell.subviews){
            if([view isKindOfClass:[SQPhotoPreviewCollection class]]){
                [view removeFromSuperview];
                break;
            }
        }
        if(previewCollection.superview)
            [previewCollection removeFromSuperview];
        
        [cell.contentView addSubview:previewCollection];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        dict[@"previewCollection"] = previewCollection;
        
        NSString *format = @"|-0-[previewCollection]-0-|";
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:dict];
        [cell.contentView addConstraints:constraints];
        
        format = @"V:|-0-[previewCollection]-0-|";
        constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:dict];
        [cell.contentView addConstraints:constraints];
        [cell.contentView sendSubviewToBack:previewCollection];
        
    }
    else{
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:actionReuseIdentifier forIndexPath:indexPath];
        UILabel *label = (UILabel *)[cell viewWithTag:100];
        NSString *action;
        if(indexPath.section == 1){
            cell.backgroundColor = [UIColor colorWithWhite:246/255.f alpha:1.f];
            action = kCancelAction;
        }
        else{
            cell.backgroundColor = [UIColor colorWithWhite:246/255.f alpha:0.9f];
            action = [actions objectAtIndex:indexPath.row - 1];
        }
        if([action isEqualToString:kSendAction]){
            label.text = [NSString stringWithFormat:@"%@ %ld %@", LOCALIZE(action), (long)selectedCount, LOCALIZE(@"photo")];
        }
        else{
            label.text = LOCALIZE(action);
        }
    }
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = cell.bounds;
    if(indexPath.section == 1){
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds
                                                       byRoundingCorners:UIRectCornerAllCorners
                                                             cornerRadii:CGSizeMake(10.0, 10.0)];
        maskLayer.path = maskPath.CGPath;
        
    }
    else{
        if(indexPath.row == 0){
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds
                                                           byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight
                                                                 cornerRadii:CGSizeMake(10.0, 10.0)];
            maskLayer.path = maskPath.CGPath;
        }
        else if(indexPath.row == actions.count){
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds
                                                           byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight
                                                                 cornerRadii:CGSizeMake(10.0, 10.0)];
            maskLayer.path = maskPath.CGPath;
        }
        else{
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRect:cell.bounds];
            maskLayer.path = maskPath.CGPath;
        }
    }
    cell.layer.mask = maskLayer;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 1 && indexPath.row == 0){
        [self.sheetDelegate sheet:self didClickAction:kCancelAction];
    }
    else{
        if(indexPath.section == 0 && indexPath.row == 0){
            
        }
        else{
            NSString *action = [actions objectAtIndex:indexPath.row - 1];
            if([action isEqualToString:kSendAction]){
                [self.sheetDelegate sheet:self didReturnImages:[allPhotos filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isSelected = YES"]]];
            }
            else{
                [self.sheetDelegate sheet:self didClickAction:action];
            }
            
        }
    }
}

- (void)previewCollection:(SQPhotoPreviewCollection*)collection setCheckmarkVisible:(BOOL)visible{
    checkmarkView.hidden = !visible;
}

- (void)previewCollection:(SQPhotoPreviewCollection *)collection didChangeSelectedCount:(NSInteger)newSelectedCount clickedIndex:(NSInteger)index{
    
    CGFloat newHeight = 0;
    selectedCount = newSelectedCount;
    if(selectedCount == 1 && _maxImagesCount == 1){
        [self.sheetDelegate sheet:self didReturnImages:[allPhotos filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isSelected = YES"]]];
        return;
    }
    
    if(newSelectedCount > 0 && previewCellHeight != bigHeight){
        previewCellHeight = bigHeight;
        actions = @[kSendAction, kPickPhotoAction];
        newHeight = previewCellHeight + 185;
        
        ((SQSheetLayout *)self.collectionViewLayout).previewCellHeight = previewCellHeight;
        
        [self.sheetDelegate sheet:self willChangeHeight:newHeight];
        
        [self reloadSections:[NSIndexSet indexSetWithIndex:0]];
        [collection scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    }
    
    else if(newSelectedCount == 0 && previewCellHeight != smallHeight){
        previewCellHeight = smallHeight;
        actions = @[kMyPhotosAction, kPickPhotoAction, kICloudAction];
        newHeight = previewCellHeight + 240;
        
        ((SQSheetLayout *)self.collectionViewLayout).previewCellHeight = previewCellHeight;
        
        [self.sheetDelegate sheet:self willChangeHeight:newHeight];
        
        [self reloadSections:[NSIndexSet indexSetWithIndex:0]];
        [collection scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    else{
        if(previewCellHeight == bigHeight){
            [UIView performWithoutAnimation:^{
                [self reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:1 inSection:0]]];
            }];
        }
    }
    
}


@end
