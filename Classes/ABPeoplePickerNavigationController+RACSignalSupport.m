//
// ABPeoplePickerNavigationController+RACSignalSupport.m
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "ABPeoplePickerNavigationController+RACSignalSupport.h"
#import "RACDelegateProxy.h"
#import "RACSignal+Operations.h"
#import "NSObject+RACDeallocating.h"
#import "NSObject+RACDescription.h"
#import <objc/runtime.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation ABPeoplePickerNavigationController (RACSignalSupport)

static void RACUseDelegateProxy(ABPeoplePickerNavigationController *self) {
	if (self.peoplePickerDelegate == self.rac_delegateProxy) return;
    
	self.rac_delegateProxy.rac_proxiedDelegate = self.peoplePickerDelegate;
	self.peoplePickerDelegate = (id)self.rac_delegateProxy;
}

- (RACDelegateProxy *)rac_delegateProxy {
	RACDelegateProxy *proxy = objc_getAssociatedObject(self, _cmd);
	if (proxy == nil) {
		proxy = [[RACDelegateProxy alloc] initWithProtocol:@protocol(ABPeoplePickerNavigationControllerDelegate)];
		objc_setAssociatedObject(self, _cmd, proxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
    
	return proxy;
}

- (RACSignal *)rac_contactSelectedSignal {
	RACSignal *pickerCancelledSignal = [[self.rac_delegateProxy
		signalForSelector:@selector(peoplePickerNavigationControllerDidCancel:)]
		merge:self.rac_willDeallocSignal];
		
	RACSignal *imagePickerSignal = [[[[self.rac_delegateProxy
		signalForSelector:@selector(peoplePickerNavigationController:didSelectPerson:property:identifier:)]
		reduceEach:^(ABPeoplePickerNavigationController *pickerController, id value, NSNumber *propertyValue, NSNumber *identifierValue) {
			id obj;
			[value getValue:&obj];
			ABRecordRef person = (__bridge ABRecordRef)obj;
			ABMultiValueIdentifier identifier = [identifierValue intValue];

			ABMutableMultiValueRef phoneMulti = ABRecordCopyValue(person, kABPersonPhoneProperty);
			CFIndex index = ABMultiValueGetIndexForIdentifier(phoneMulti, identifier);
			NSString *phone = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phoneMulti, index);
			NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"].invertedSet;
			phone = [[phone componentsSeparatedByCharactersInSet:charSet] componentsJoinedByString:@""];
			NSString *fullName = (__bridge NSString *)ABRecordCopyCompositeName(person);
			return RACTuplePack(fullName, phone);
		}]
		takeUntil:pickerCancelledSignal]
		setNameWithFormat:@"%@ -rac_contactSelectedSignal", [self rac_description]];
    
	RACUseDelegateProxy(self);
    
	return imagePickerSignal;
}

@end
