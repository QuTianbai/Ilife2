//
// MSFPeoplePickerNavigationController+RACSignalSupport.m
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFPeoplePickerNavigationController+RACSignalSupport.h"
#import "RACDelegateProxy.h"
#import "RACSignal+Operations.h"
#import "NSObject+RACDeallocating.h"
#import "NSObject+RACDescription.h"
#import <objc/runtime.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation MSFPeoplePickerNavigationController (RACSignalSupport)

static void RACUseDelegateProxy(MSFPeoplePickerNavigationController *self) {
	if (self.msf_peoplePickerDelegate == self.rac_delegateProxy) return;
    
	self.rac_delegateProxy.rac_proxiedDelegate = self.msf_peoplePickerDelegate;
	self.msf_peoplePickerDelegate = (id)self.rac_delegateProxy;
}

- (RACDelegateProxy *)rac_delegateProxy {
	RACDelegateProxy *proxy = objc_getAssociatedObject(self, _cmd);
	if (proxy == nil) {
		proxy = [[RACDelegateProxy alloc] initWithProtocol:@protocol(MSFPeoplePickerNavigationControllerdelegate)];
		objc_setAssociatedObject(self, _cmd, proxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
    
	return proxy;
}

- (RACSignal *)rac_contactSelectedSignal {
	RACSignal *pickerCancelledSignal = [[self.rac_delegateProxy
		signalForSelector:@selector(peoplePickerNavigationControllerDidCancel:)]
		merge:self.rac_willDeallocSignal];
		
	RACSignal *imagePickerSignal = [[[[self.rac_delegateProxy
		signalForSelector:@selector(peoplePickerNavigationController:didSelectPerson:)]
		reduceEach:^(MSFPeoplePickerNavigationController *pickerController, NSDictionary *value) {
			return RACTuplePack(value[@"name"], value[@"phone"]);
		}]
		takeUntil:pickerCancelledSignal]
		setNameWithFormat:@"%@ -rac_contactSelectedSignal", [self rac_description]];
    
	RACUseDelegateProxy(self);
    
	return imagePickerSignal;
}

@end
