//
//  ViewController.m
//  SampleProject
//
//  Created by sequenia on 06/07/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import "ViewController.h"
#import <SQPhotoPickerSheet.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)showPicker:(id)sender {
    SQPhotoPickerSheet *picker = [[SQPhotoPickerSheet alloc] init];
    picker.navigationBarTintColor = [UIColor whiteColor];
    picker.navigationBarBackgroundColor = [UIColor redColor];
    picker.sheetTextFont = [UIFont boldSystemFontOfSize:15.f];
    picker.sheetTextColor = [UIColor redColor];
    picker.toolbarTintColor = [UIColor blackColor];
    picker.checkmarkIcon = [UIImage imageNamed:@"ic_checkmark"];
    picker.toolbarButtonFont = [UIFont italicSystemFontOfSize:14.f];
    picker.maxImagesCount = 5;
    [picker setDismissAction:^(SQPhotoPickerSheet *sheet) {
        NSLog(@"OLOLO");
    }];
    [picker presentInViewController:self withCompletionAction:^(SQPhotoPickerSheet *picker, NSArray *returnedImages) {
        for(SQPhoto *photo in returnedImages){
            NSString *url = [photo getPhotoURLString];
            NSLog(@"%@", url);
            [photo getPhotoOriginalAsync:^(UIImage *originalPhoto) {
                NSLog(@"%@", originalPhoto);
            }];
            
        }
    }];
}
@end
