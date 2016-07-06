//
//  SQAlbumListViewController.h
//  PhotoTest
//
//  Created by Sequenia on 23/06/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SQPhoto;

@protocol SQPhotoListDelegate;

@interface SQAlbumListViewController : UITableViewController

@property (nonatomic, weak) id<SQPhotoListDelegate> listDelegate;
@property (nonatomic) NSInteger maxImagesCount;
@property (nonatomic) NSInteger targetAlbumType;

@end

@protocol SQPhotoListDelegate <NSObject>

@optional
- (void)listControllerDidCancel:(SQAlbumListViewController *)controller;
- (void)listController:(SQAlbumListViewController *)collection didFinishPickImages:(NSArray<SQPhoto *> *) photos;
@end