//
//  NKAddressBookPickerBehavior.h
//  GeoSearch
//
//  Created by Nick on 12/04/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import "NKBehavior.h"
#import <AddressBookUI/AddressBookUI.h>
#import <AddressBook/AddressBook.h>

@protocol NKTextSettable;

typedef void(^AddressBookPickerCompletion)(NSString* name, NSString* phone, UIImage* photo);

@interface NKAddressBookPickerBehavior : NKBehavior

@property (weak, nonatomic) IBOutlet id<NKTextSettable> nameField;

@property (weak, nonatomic) IBOutlet id<NKTextSettable> phoneField;

@property (weak, nonatomic) IBOutlet UIImageView* imageView;

- (IBAction) openAddressBook:(id)sender;

- (void) getPersonInfoFromAddressBookWithRootController: (UIViewController*) viewController
                                             completion: (AddressBookPickerCompletion) completion;

@end

@protocol NKTextSettable <NSObject>

@required

- (void) setText: (NSString*) text;

@end
