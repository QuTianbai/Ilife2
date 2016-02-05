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
@property (nonatomic, strong, readwrite) NSString *identifer;

@end

@implementation MSFCouponsViewModel

- (instancetype)initWithServices:(id <MSFViewModelServices>)services {
  self = [super init];
  if (!self) {
    return nil;
  }
	_services = services;
	_viewModels = @[];
	_identifer = @"";
	
	@weakify(self)
	RAC(self, viewModels) = [self.didBecomeActiveSignal flattenMap:^RACStream *(id value) {
		@strongify(self)
		return [[self fetchSingal]
			flattenMap:^RACStream *(NSArray *viewModels) {
				return [[[viewModels.rac_sequence
					filter:^BOOL(MSFCouponViewModel *viewModel) {
						return [viewModel.status isEqualToString:self.identifer];
					}]
					signal]
					collect];
			}];
	}];
	
	_executeFetchCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		self.identifer = input;
		return [RACSignal return:[self.viewModels.rac_sequence filter:^BOOL(MSFCouponViewModel *viewModel) {
			return [viewModel.status isEqualToString:self.identifer];
		}].array];
	}];
	
	_executeAdditionCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return [self.services.httpClient addCouponWithCode:input];
	}];
	
  return self;
}

- (RACSignal *)fetchStatus:(NSString *)status {
	return [[[[self.services.httpClient
		fetchCouponsWithStatus:status]
		catch:^RACSignal *(NSError *error) {
			return [RACSignal empty];
		}]
		map:^id(id value) {
			return [[MSFCouponViewModel alloc] initWithModel:value];
		}]
		collect];
}

- (RACSignal *)fetchSingal {
	return [[RACSignal combineLatest:@[
		[[self fetchStatus:@"B"] ignore:nil],
		[[self fetchStatus:@"C"] ignore:nil],
		[[self fetchStatus:@"D"] ignore:nil]
	]] flattenMap:^RACStream *(RACTuple *value) {
		RACTupleUnpack(NSArray *b, NSArray *c, NSArray *d) = value;
		b = [[b arrayByAddingObjectsFromArray:c] arrayByAddingObjectsFromArray:d];
		return [RACSignal return:b];
	}];
}

@end
