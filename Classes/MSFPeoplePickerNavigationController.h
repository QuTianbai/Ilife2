//
// MSFPeoplePickerNavigationController.h
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import <AddressBookUI/AddressBookUI.h>

@class MSFPeoplePickerNavigationController;

@protocol MSFPeoplePickerNavigationControllerdelegate <NSObject>

- (void)peoplePickerNavigationControllerDidCancel:(MSFPeoplePickerNavigationController *)peoplePicker;
- (void)peoplePickerNavigationController:(MSFPeoplePickerNavigationController *)peoplePicker didSelectPerson:(id)person;

@end

@interface MSFPeoplePickerNavigationController : ABPeoplePickerNavigationController

@property (nonatomic, weak) id <MSFPeoplePickerNavigationControllerdelegate> msf_peoplePickerDelegate;

@end
