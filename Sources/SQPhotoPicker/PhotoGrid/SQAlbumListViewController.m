//
//  SQAlbumListViewController.m
//  PhotoTest
//
//  Created by Sequenia on 23/06/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import "SQAlbumListViewController.h"

#import "LocalizeHeader.h"

#import "SQPhoto.h"
#import "SQAlbum.h"

#import <Photos/Photos.h>
#import <PhotosUI/PhotosUI.h>

#import "SQPhotoGridViewController.h"

@interface SQAlbumListViewController () <SQPhotoGridSelectionDelegate> {
    NSMutableArray *allAlbums;
    NSArray *visibleAlbums;
    NSMutableArray *selectedPhotos;
    
    UIActivityIndicatorView *loaderIndicator;
    
    UIButton *doneButton;
    UIButton *cancelButton;
}

@end

static NSString * const reuseIdentifier = @"SQAlbumCell";

@implementation SQAlbumListViewController

- (id) initWithStyle:(UITableViewStyle)style{
    self = [super initWithStyle:style];
    if(self){
        _targetAlbumType = -1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = LOCALIZE(@"albums");
    self.navigationController.navigationBar.translucent = NO;
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.tableView registerNib:[UINib nibWithNibName:reuseIdentifier bundle:[NSBundle bundleForClass:[self class]]] forCellReuseIdentifier:reuseIdentifier];
    
    loaderIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [loaderIndicator setColor:[UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0]];
    [loaderIndicator setHidesWhenStopped:YES];
    loaderIndicator.transform = CGAffineTransformMakeScale(0.8, 0.8);
    [self.tableView addSubview:loaderIndicator];

    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    [self.navigationController.toolbar setTintColor:self.toolbarTintColor];
    
    doneButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 130, 30)];
    doneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [doneButton setTitle:LOCALIZE(@"send_photos") forState:UIControlStateNormal];
    [doneButton setTitleColor:self.navigationController.toolbar.tintColor forState:UIControlStateNormal];
    [doneButton.titleLabel setFont:self.toolbarButtonFont];
    [doneButton addTarget:self action:@selector(finishPick) forControlEvents:UIControlEventTouchUpInside];
    
    cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 130, 30)];
    cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [cancelButton setTitle:LOCALIZE(@"cancel_pick") forState:UIControlStateNormal];
    [cancelButton setTitleColor:self.navigationController.toolbar.tintColor forState:UIControlStateNormal];
    [cancelButton.titleLabel setFont:self.toolbarButtonFont];
    [cancelButton addTarget:self action:@selector(dismissGrid) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -5;
    
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *completePick = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    
    self.navigationController.toolbarHidden = NO;
    
    if(_maxImagesCount == 1){
        [self setToolbarItems:@[cancel, flex] animated:YES];
    }
    else{
        [self setToolbarItems:@[cancel, flex, completePick, negativeSpacer] animated:YES];
    }
    
    
    allAlbums = [NSMutableArray array];
    selectedPhotos = [NSMutableArray array];
    
    [self loadAllPhotoAlbums];
}

- (void) dismissGrid{
    [self.listDelegate listControllerDidCancel:self];
}

- (void) finishPick{
    [self.listDelegate listController:self didFinishPickImages:selectedPhotos];
}

- (void) loadAllPhotoAlbums{
    [allAlbums removeAllObjects];
    [self.tableView reloadData];
    [loaderIndicator startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getPhotos];
        dispatch_async(dispatch_get_main_queue(), ^{
            [loaderIndicator stopAnimating];
            visibleAlbums = [allAlbums filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"photosCount > 0"]];
            [self.tableView reloadData];
            SQAlbum *album = [allAlbums filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"albumType = %d", _targetAlbumType]].firstObject;
            if(album){
                [self onSelectAlbum:album animated:NO];
            }
            else{
                if(_targetAlbumType != -1)
                    [[[UIAlertView alloc] initWithTitle:LOCALIZE(@"album_not_found") message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
        });
    });
}


- (void) getPhotos{
    NSMutableArray *totalFetches = [NSMutableArray array];
    
    //Формируем последовательность альбомов как в галерее телефона
    
    //Camera roll
    [totalFetches addObject:[PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                                     subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil]];
    //Favorites
    [totalFetches addObject:[PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                                     subtype:PHAssetCollectionSubtypeSmartAlbumFavorites options:nil]];
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 9){
        //Selfies
        [totalFetches addObject:[PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                                         subtype:PHAssetCollectionSubtypeSmartAlbumSelfPortraits options:nil]];
        //Screenshots
        [totalFetches addObject:[PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                                         subtype:PHAssetCollectionSubtypeSmartAlbumScreenshots options:nil]];
    }
    
    //Generic (?)
    [totalFetches addObject:[PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                                     subtype:PHAssetCollectionSubtypeSmartAlbumGeneric options:nil]];
    
    
    NSArray *regSubtypes = @[
                             @(PHAssetCollectionSubtypeAlbumRegular),
                             @(PHAssetCollectionSubtypeAlbumSyncedEvent),
                             @(PHAssetCollectionSubtypeAlbumSyncedFaces),
                             @(PHAssetCollectionSubtypeAlbumSyncedAlbum),
                             @(PHAssetCollectionSubtypeAlbumImported),
                             @(PHAssetCollectionSubtypeAlbumMyPhotoStream),
                             @(PHAssetCollectionSubtypeAlbumCloudShared)
                             ];
    
    for(NSNumber *subtype in regSubtypes){
        [totalFetches addObject:[PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum
                                                                         subtype:[subtype integerValue] options:nil]];
    }
    
    for (int i = 0; i < totalFetches.count; i ++) {
        
        PHFetchResult *fetchResult = totalFetches[i];
        
        for (int x = 0; x < fetchResult.count; x ++) {
            @try {
                PHAssetCollection *collection = fetchResult[x];
                
                SQAlbum *album = [[SQAlbum alloc] init];
                album.assetCollection = collection;
                album.albumType = collection.assetCollectionSubtype;
                [allAlbums addObject:album];
            }
            @catch (NSException *exception) {
                NSLog(@"On processing album error = %@", exception);
            }
        }
    }
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return visibleAlbums.count;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return 180;
    return 110;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    SQAlbum *album = [visibleAlbums objectAtIndex:indexPath.row];
    
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:100];
    UIActivityIndicatorView *activityInidcator = (UIActivityIndicatorView *)[cell viewWithTag:400];
    imageView.clipsToBounds = YES;
    
    [activityInidcator startAnimating];
    imageView.image = [UIImage new];
    [album getAlbumCoverWithCompletion:^(UIImage *previewImage) {
        imageView.image = previewImage;
        [activityInidcator stopAnimating];
    }];
    
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:200];
    titleLabel.text = album.assetCollection.localizedTitle;
    
    UILabel *countLabel = (UILabel *)[cell viewWithTag:300];
    countLabel.text = [NSString stringWithFormat:@"%ld", (long)album.photosCount];
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self onSelectAlbum:[visibleAlbums objectAtIndex:indexPath.row] animated:YES];
}

- (void)onSelectAlbum:(SQAlbum *)album animated:(BOOL)animated{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    SQPhotoGridViewController *grid = [[SQPhotoGridViewController alloc] initWithCollectionViewLayout:flowLayout];
    grid.album = album;
    grid.parent = self;
    grid.maxImagesCount = _maxImagesCount;
    grid.gridDelegate = self;
    grid.currentSelectedCount = selectedPhotos.count;
    grid.toolbarTintColor = self.toolbarTintColor;
    grid.toolbarButtonFont = self.toolbarButtonFont;
    grid.checkmarkIcon = self.checkmarkIcon;
    grid.emptyCheckmarkIcon = self.emptyCheckmarkIcon;
    [self.navigationController pushViewController:grid animated:animated];
}

- (void) photoGridDidFinishPick:(SQPhotoGridViewController *)collection{
    [self finishPick];
}

- (NSInteger) photoGrid:(SQPhotoGridViewController *)collection didSelectPhoto:(SQPhoto *)photo{
    if([selectedPhotos containsObject:photo]){
        [selectedPhotos removeObject:photo];
    }
    else{
        [selectedPhotos addObject:photo];
    }
    NSString *string = @"";
    if(selectedPhotos.count != 0){
        string = [NSString stringWithFormat:@"(%ld) ", (long)selectedPhotos.count];
    }
    string = [string stringByAppendingString:LOCALIZE(@"send_photos")];
    [doneButton setTitle:string forState:UIControlStateNormal];
    return selectedPhotos.count;
}

@end
