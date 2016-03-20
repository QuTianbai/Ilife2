//
// MSFPeoplePickerNavigationController.m
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFPeoplePickerNavigationController.h"

@interface MSFPeoplePickerNavigationController () <ABPeoplePickerNavigationControllerDelegate>

@end

@implementation MSFPeoplePickerNavigationController

#pragma mark - Lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	self.peoplePickerDelegate = self;
}

#pragma mark - ABPersonViewControllerDelegate

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
	if ([self.msf_peoplePickerDelegate respondsToSelector:@selector(peoplePickerNavigationControllerDidCancel:)]) {
		[self.msf_peoplePickerDelegate peoplePickerNavigationControllerDidCancel:self];
	}
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
	ABMutableMultiValueRef phoneMulti = ABRecordCopyValue(person, kABPersonPhoneProperty);
	CFIndex index = ABMultiValueGetIndexForIdentifier(phoneMulti, identifier);
	NSString *phone = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phoneMulti, index);
	NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"].invertedSet;
	phone = [[phone componentsSeparatedByCharactersInSet:charSet] componentsJoinedByString:@""];
	NSString *fullName = (__bridge NSString *)ABRecordCopyCompositeName(person);
	if ([self.msf_peoplePickerDelegate respondsToSelector:@selector(peoplePickerNavigationController:didSelectPerson:)]) {
		[self.msf_peoplePickerDelegate peoplePickerNavigationController:self didSelectPerson:@{
			@"name": fullName?:@"",
			@"phone": phone?:@"",
		}];
	}
}

@end
