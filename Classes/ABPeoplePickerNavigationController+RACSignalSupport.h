//
// ABPeoplePickerNavigationController+RACSignalSupport.h
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import <AddressBookUI/AddressBookUI.h>

@class RACDelegateProxy;
@class RACSignal;

@interface ABPeoplePickerNavigationController (RACSignalSupport)

@property (nonatomic, strong, readonly) RACDelegateProxy *rac_delegateProxy;
- (RACSignal *)rac_contactSelectedSignal;

@end
