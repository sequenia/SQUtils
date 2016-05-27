//
//  NKPhotoPickerBehavior.m
//  GeoSearch
//
//  Created by Nick on 12/04/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import "NKPhotoPickerBehavior.h"

static NSString* kImagePickerLibraryTitle   = @"Галерея";
static NSString* kImagePickerPhotoTitle     = @"Фото";
static NSString* kImagePickerCancelTitle    = @"Отмена";

@interface NKPhotoPickerBehavior () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (copy, nonatomic) ImagePickerCompletion imagePickerCompletion;

@property (weak, nonatomic) UIViewController* viewController;

@end

@implementation NKPhotoPickerBehavior

#pragma mark - Public

- (IBAction) pickPhoto:(id)sender {
    [self showDialogToChooseSourceType];
}

- (void) getImageWithController: (UIViewController*) viewController
                     completion: (ImagePickerCompletion) completion{
    self.viewController = viewController;
    self.imagePickerCompletion = completion;
    [self showDialogToChooseSourceType];
}

#pragma mark - Private

- (void) showDialogToChooseSourceType {
    NSArray* buttons = @[kImagePickerLibraryTitle, kImagePickerPhotoTitle];
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        buttons = @[kImagePickerLibraryTitle];
    }
    
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle: nil
                                                             delegate: self
                                                    cancelButtonTitle: kImagePickerCancelTitle
                                               destructiveButtonTitle: nil
                                                    otherButtonTitles: nil];
    for (NSString* title in buttons) {
        [actionSheet addButtonWithTitle: title];
    }
    [actionSheet showInView: self.viewController.view];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString* title = [actionSheet buttonTitleAtIndex: buttonIndex];
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if ([title isEqualToString: kImagePickerLibraryTitle]){
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    } else if ([title isEqualToString: kImagePickerPhotoTitle]){
        sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        return;
    }
    if ([UIImagePickerController isSourceTypeAvailable: sourceType]){
        UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.sourceType = sourceType;
        imagePickerController.delegate = self;
        
        [self.viewController presentViewController: imagePickerController animated: YES completion: nil];
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated: YES completion: nil];
    UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (self.imagePickerCompletion){
        self.imagePickerCompletion(image);
    }
    self.imageView.image = image;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated: YES completion: nil];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleLightContent];
}

#pragma mark - Custom Accessors

- (UIViewController *) viewController {
    if (!_viewController){
        if ([self.owner isKindOfClass: [UIViewController class]]){
            _viewController = (UIViewController*) self.owner;
        }
    }
    return _viewController;
}

@end
