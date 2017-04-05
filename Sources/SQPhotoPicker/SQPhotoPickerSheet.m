//
//  SQPhotoPickerSheet.m
//  PhotoTest
//
//  Created by Sequenia on 21/06/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import "SQPhotoPickerSheet.h"
#import "SQPhotoSheetCollection.h"

#import <Photos/Photos.h>
#import <PhotosUI/PhotosUI.h>

#import "LocalizeHeader.h"
#import "SQAlbumListViewController.h"
#import "SQPresentationController.h"

@interface SQPhotoPickerSheet () <SQSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, SQPhotoListDelegate, UIViewControllerTransitioningDelegate>{
    
    SQPhotoSheetCollection *photoSheet;
    UIView *backgroundView;
    NSLayoutConstraint *sheetHeightConstaint;
    
}

@end

@implementation SQPhotoPickerSheet

- (id)init{
    self = [super init];
    if(self){
        _maxImagesCount = NSIntegerMax;
        
        _navigationBarBackgroundColor = [UIColor whiteColor];
        _navigationBarTintColor = [UIColor blueColor];
        _navigationBarTitleFont = [UIFont systemFontOfSize:16.f];
        
        _toolbarTintColor = [UIColor blueColor];
        
        _checkmarkIcon = [UIImage imageNamed:@"checkmark" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
        _emptyCheckmarkIcon = [UIImage imageNamed:@"empty_checkmark" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
        
        _sheetTextColor = [UIColor blueColor];
        _sheetTextFont = [UIFont systemFontOfSize:14.f];
        _toolbarButtonFont = [UIFont systemFontOfSize:14.f];
        
        _maxPhotoSide = 2000.f;
        
        if ([self respondsToSelector:@selector(setTransitioningDelegate:)]) {
            self.modalPresentationStyle = UIModalPresentationCustom;
            self.transitioningDelegate = self;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds))];
    backgroundView.backgroundColor = [UIColor clearColor];
    [backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissPicker)]];
    backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:backgroundView];
    
    photoSheet = [[SQPhotoSheetCollection alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds) - 20, 398)];
    photoSheet.maxImagesCount = _maxImagesCount;
    photoSheet.sheetDelegate = self;
    photoSheet.checkmarkIcon = self.checkmarkIcon;
    photoSheet.emptyCheckmarkIcon = self.emptyCheckmarkIcon;
    
    photoSheet.sheetTextColor = self.sheetTextColor;
    photoSheet.sheetTextFont = self.sheetTextFont;
    photoSheet.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:photoSheet];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict[@"backgroundView"] = backgroundView;
    dict[@"photoSheet"] = photoSheet;
    
    NSString *format = @"|-0-[backgroundView]-0-|";
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:dict];
    [self.view addConstraints:constraints];
    
    format = @"V:|-0-[backgroundView]-0-|";
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:dict];
    [self.view addConstraints:constraints];
    
    format = @"V:[photoSheet(height)]-0-|";
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:@{@"height":@398.0} views:dict];
    for(NSLayoutConstraint *constraint in constraints){
        if(constraint.firstAttribute == NSLayoutAttributeHeight){
            sheetHeightConstaint = constraint;
            break;
        }
    }
    [self.view addConstraints:constraints];
    
    format = @"|-10-[photoSheet]-10-|";
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:dict];
    [self.view addConstraints:constraints];
}

- (void) presentInViewController:(UIViewController *)controller withCompletionAction:(void (^)(SQPhotoPickerSheet *, NSArray<SQPhoto *> *))completion{
    self.sourceController = controller;
    self.completionAction = completion;
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        [self performSelectorOnMainThread:@selector(onCompleteAuth) withObject:controller waitUntilDone:YES];
    }];
}

- (void) onCompleteAuth{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    switch (status) {
        case PHAuthorizationStatusAuthorized:
            [_sourceController presentViewController:self animated:YES completion:nil];
            break;
        case PHAuthorizationStatusRestricted:
            [[[UIAlertView alloc] initWithTitle:LOCALIZE(@"access_denied") message:LOCALIZE(@"unlock_photos_access") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            break;
        case PHAuthorizationStatusDenied:
            [[[UIAlertView alloc] initWithTitle:LOCALIZE(@"access_denied") message:LOCALIZE(@"unlock_photos_access") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            break;
        default:
            [[[UIAlertView alloc] initWithTitle:LOCALIZE(@"access_denied") message:LOCALIZE(@"unlock_photos_access") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            break;
    }
}

- (void) dismissPicker{
    [self dismissViewControllerAnimated:YES completion:nil];
    if(self.dismissAction) {
        self.dismissAction(self);
    }
}

- (void) sheet:(SQPhotoSheetCollection *)sheet didReturnImages:(NSArray *)images{
    [self dismissPicker];
    for(SQPhoto *photo in images) {
        photo.maxPhotoSide = _maxPhotoSide;
    }
    _completionAction(self, images);
}

- (void) sheet:(SQPhotoSheetCollection *)sheet willChangeHeight:(CGFloat)newHeight{
    sheetHeightConstaint.constant = newHeight;
    [UIView animateWithDuration:0.4 animations:^{
        [self.view layoutSubviews];
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void) sheet:(SQPhotoSheetCollection *)sheet didClickAction:(NSString *)action{
    if (self.pickerSheetClicked)
        self.pickerSheetClicked(action);
    if([action isEqualToString:kCancelAction]){
        [self dismissPicker];
    }
    if([action isEqualToString:kPickPhotoAction]){
        if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            [[[UIAlertView alloc] initWithTitle:LOCALIZE(@"cannt_take_photo") message:LOCALIZE(@"camera_not_found") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            return;
        }
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [imagePicker setShowsCameraControls:YES];
        imagePicker.delegate = self;
        [imagePicker setAllowsEditing:NO];
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    if([action isEqualToString:kMyPhotosAction]){
        [self presentAlbumControllerWithAlbumType:PHAssetCollectionSubtypeSmartAlbumUserLibrary];
    }
    
    if([action isEqualToString:kICloudAction]){
        [self presentAlbumControllerWithAlbumType:PHAssetCollectionSubtypeAlbumCloudShared];
    }
}

- (void) presentAlbumControllerWithAlbumType:(NSInteger)type{
    SQAlbumListViewController *listController = [[SQAlbumListViewController alloc] initWithStyle:UITableViewStylePlain];
    listController.listDelegate = self;
    listController.maxImagesCount = _maxImagesCount;
    listController.targetAlbumType = type;
    listController.toolbarTintColor = self.toolbarTintColor;
    listController.checkmarkIcon = self.checkmarkIcon;
    listController.toolbarButtonFont = self.toolbarButtonFont;
    listController.emptyCheckmarkIcon = self.emptyCheckmarkIcon;
    
    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:listController];
    controller.navigationBar.tintColor = self.navigationBarTintColor;
    controller.navigationBar.barTintColor = self.navigationBarBackgroundColor;
    controller.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : self.navigationBarTintColor, NSFontAttributeName : self.navigationBarTitleFont};
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *newImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIViewController *vc = self.presentingViewController;
    [vc dismissViewControllerAnimated:YES completion:nil];
    SQPhoto *photo = [[SQPhoto alloc] init];
    photo.isSelected = YES;
    photo.originalImage = newImage;
    photo.maxPhotoSide = _maxPhotoSide;
    _completionAction(self, @[photo]);
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void) listControllerDidCancel:(SQAlbumListViewController *)controller{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void) listController:(SQAlbumListViewController *)collection didFinishPickImages:(NSArray<SQPhoto *> *)photos{
    UIViewController *vc = self.presentingViewController;
    [vc dismissViewControllerAnimated:YES completion:nil];
    for(SQPhoto *photo in photos) {
        photo.maxPhotoSide = _maxPhotoSide;
    }
    _completionAction(self, photos);
}

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    return [[SQPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
}


@end
