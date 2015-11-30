//
// RACSignal+MSFContactsAdditions.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "RACSignal+MSFContactsAdditions.h"
#import <AddressBook/AddressBook.h>
#import <Contacts/Contacts.h>
#import "UIDevice+Versions.h"

@implementation RACSignal (MSFContactsAdditions)

+ (RACSignal *)msf_contactsCountSignal {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
			CNContactStore *store = [[CNContactStore alloc] init];
			CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
			if (status == CNAuthorizationStatusAuthorized) {
				NSMutableArray *contacts = [NSMutableArray array];
				NSError *fetchError;
				CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:@[
					CNContactIdentifierKey,
					[CNContactFormatter descriptorForRequiredKeysForStyle:CNContactFormatterStyleFullName]
				]];

				BOOL success = [store enumerateContactsWithFetchRequest:request error:&fetchError usingBlock:^(CNContact *contact, BOOL *stop) {
					[contacts addObject:contact];
				}];
				if (!success) {
					[subscriber sendError:fetchError];
				} else {
					[subscriber sendNext:@(contacts.count)];
					[subscriber sendCompleted];
				}
			}
			[store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError *error) {
				if (!granted) {
					[subscriber sendError:[NSError errorWithDomain:@"" code:0 userInfo:nil]];
				} else {
					NSMutableArray *contacts = [NSMutableArray array];
					NSError *fetchError;
					CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:@[
						CNContactIdentifierKey,
						[CNContactFormatter descriptorForRequiredKeysForStyle:CNContactFormatterStyleFullName]
					]];

					BOOL success = [store enumerateContactsWithFetchRequest:request error:&fetchError usingBlock:^(CNContact *contact, BOOL *stop) {
						[contacts addObject:contact];
					}];
					if (!success) {
						[subscriber sendError:fetchError];
					} else {
						[subscriber sendNext:@(contacts.count)];
						[subscriber sendCompleted];
					}
				}
			}];
		} else {
			ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
			ABAuthorizationStatus authorization = ABAddressBookGetAuthorizationStatus();
			//获得授权
			if (authorization == kABAuthorizationStatusAuthorized) {
				CFIndex numPeople = ABAddressBookGetPersonCount(addressBook);
				[subscriber sendNext:@(numPeople)];
				[subscriber sendCompleted];
			} else {
				ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
					if (!granted) {
						[subscriber sendError:[NSError errorWithDomain:@"" code:0 userInfo:nil]];
					} else {
						// 通讯录中人数
						CFIndex numPeople = ABAddressBookGetPersonCount(addressBook);
						[subscriber sendNext:@(numPeople)];
						[subscriber sendCompleted];
					}
				});
			}
		}
		return [RACDisposable disposableWithBlock:^{
		}];
	}];

}

@end
