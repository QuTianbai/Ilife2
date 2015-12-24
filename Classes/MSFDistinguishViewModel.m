//
// MSFDistinguishViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFDistinguishViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFInventoryViewModel.h"

@interface MSFDistinguishViewModel ()

@property (nonatomic, strong, readwrite) id <MSFApplicationViewModel> applicationViewModel;
@property (nonatomic, strong, readwrite) id <MSFViewModelServices> services;

@end

@implementation MSFDistinguishViewModel

#pragma mark - NSObject

- (instancetype)initWithApplicationViewModel:(id <MSFApplicationViewModel>)applicationViewModel {
  self = [super init];
  if (!self) {
    return nil;
  }
	_applicationViewModel = applicationViewModel;
	_services = applicationViewModel.services;
	_executeInventoryCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return self.executeInventorySignal;
	}];
	
  return self;
}

#pragma mark - Private

- (RACSignal *)executeInventorySignal {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		MSFInventoryViewModel *viewModel = [[MSFInventoryViewModel alloc] initWithApplicationViewModel:self.applicationViewModel];
		[self.services pushViewModel:viewModel];
		[subscriber sendCompleted];
		return [RACDisposable disposableWithBlock:^{
			
		}];
	}];
}

@end
