//
//  NKPhotoPickerBehavior.h
//  GeoSearch
//
//  Created by Nick on 12/04/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import "NKBehavior.h"

typedef void(^ImagePickerCompletion)(UIImage* image);

@interface NKPhotoPickerBehavior : NKBehavior

@property (strong, nonatomic) IBOutlet UIImageView* imageView;

- (IBAction) pickPhoto:(id)sender;

- (void) getImageWithController: (UIViewController*) viewController
                     completion: (ImagePickerCompletion) completion;
@end
