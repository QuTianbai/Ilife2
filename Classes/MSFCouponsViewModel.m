//
// MSFCouponsViewModel.m
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFCouponsViewModel.h"
#import "MSFCouponViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFClient+Coupons.h"

@interface MSFCouponsViewModel ()

@property (nonatomic, strong, readwrite) NSArray *viewModels;

@end

@implementation MSFCouponsViewModel

- (instancetype)initWithServices:(id <MSFViewModelServices>)services {
  self = [super init];
  if (!self) {
    return nil;
  }
	_services = services;
	
	@weakify(self)
	_executeFetchCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [[[[self.services.httpClient
			fetchCouponsWithStatus:input]
			catch:^RACSignal *(NSError *error) {
				return RACSignal.empty;
			}]
			map:^id(id value) {
				return [[MSFCouponViewModel alloc] initWithModel:value];
			}]
			collect];
	}];
	
	_executeAdditionCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return [self.services.httpClient addCouponWithCode:input];
	}];
	
	RAC(self, viewModels) = [self.executeFetchCommand.executionSignals flattenMap:^RACStream *(id value) {
		return value;
	}];
	
  return self;
}

@end
