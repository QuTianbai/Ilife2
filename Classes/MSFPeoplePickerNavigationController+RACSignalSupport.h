//
// MSFPeoplePickerNavigationController+RACSignalSupport.h
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFPeoplePickerNavigationController.h"

@class RACDelegateProxy;
@class RACSignal;

@interface MSFPeoplePickerNavigationController (RACSignalSupport)

@property (nonatomic, strong, readonly) RACDelegateProxy *rac_delegateProxy;
- (RACSignal *)rac_contactSelectedSignal;

@end
