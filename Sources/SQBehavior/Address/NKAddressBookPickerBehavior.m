//
//  NKAddressBookPickerBehavior.m
//  GeoSearch
//
//  Created by Nick on 12/04/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import "NKAddressBookPickerBehavior.h"

@interface NKAddressBookPickerBehavior() <ABPeoplePickerNavigationControllerDelegate>

@property (copy, nonatomic) AddressBookPickerCompletion addressBookCompletion;

@property (weak, nonatomic) UIViewController* viewController;

@end

@implementation NKAddressBookPickerBehavior

#pragma mark - Public

- (IBAction) openAddressBook:(id)sender {
    ABPeoplePickerNavigationController* peoplePicker = [[ABPeoplePickerNavigationController alloc] init];
    peoplePicker.peoplePickerDelegate = self;
    [self.viewController presentViewController: peoplePicker animated: YES completion: nil];
}

- (void) getPersonInfoFromAddressBookWithRootController: (UIViewController*) viewController
                                             completion: (AddressBookPickerCompletion) completion{
    
    self.addressBookCompletion = completion;
    self.viewController = viewController;
    [self openAddressBook: nil];
}

#pragma mark - Private

- (void) completePickingWithName: (NSString*) name phone: (NSString*) phone image: (UIImage*) image {
    if (self.addressBookCompletion){
        self.addressBookCompletion(name, phone, image);
    }
    if ([self.nameField respondsToSelector: @selector(setText:)]){
        [self.nameField setText: name];
    }
    if ([self.phoneField respondsToSelector: @selector(setText:)]){
        [self.phoneField setText: phone];
    }
    [self.imageView setImage: image];
}

#pragma mark - ABPeoplePickerNavigationControllerDelegate

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker
                         didSelectPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier NS_AVAILABLE_IOS(8_0){
    
    NSString *contactName = CFBridgingRelease(ABRecordCopyCompositeName(person));
    NSString* name = [NSString stringWithFormat:@"%@", contactName ? contactName : @"No Name"];
    
    ABMultiValueRef phoneRecord = ABRecordCopyValue(person, kABPersonPhoneProperty);
    NSString* phone = nil;
    if (phoneRecord){
        CFIndex index = ABMultiValueGetIndexForIdentifier(phoneRecord, identifier);
        if(index >= 0){
            CFStringRef phoneNumber = ABMultiValueCopyValueAtIndex(phoneRecord, index);
            phone = (__bridge_transfer NSString *)phoneNumber;
        }
        CFRelease(phoneRecord);
    }
    
    CFDataRef  photo = ABPersonCopyImageData(person);
    UIImage* image = [UIImage imageWithData:(__bridge NSData*)photo];
    if (photo){
        CFRelease(photo);
    }
    [self completePickingWithName: name phone: phone image: image];
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    [peoplePicker dismissViewControllerAnimated: YES completion: nil];
}

#pragma mark - Custom Accessors 

- (UIViewController *)viewController {
    if (!_viewController){
        if ([self.owner isKindOfClass:[UIViewController class]]){
            _viewController = (UIViewController*) self.owner;
        }
    }
    return _viewController;
}


@end
