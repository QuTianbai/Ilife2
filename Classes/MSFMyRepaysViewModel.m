//
//  MSFMyRepaysViewModel.m
//  Finance
//
//  Created by xbm on 16/2/29.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFMyRepaysViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFClient+RepaymentSchedules.h"
#import "MSFMyRepayViewModel.h"

@interface MSFMyRepaysViewModel ()

@property (nonatomic, strong, readwrite) NSArray *viewModels;
@property (nonatomic, strong, readwrite) NSString *identifer;

@end

@implementation MSFMyRepaysViewModel

- (instancetype)initWithservices:(id<MSFViewModelServices>)services {
	self = [super init];
	if (!self) {
		return nil;
	}
	_services = services;
	_viewModels = @[];
	_identifer = @"1";
	
	@weakify(self)
	RAC(self, viewModels) = [self.didBecomeActiveSignal flattenMap:^RACStream *(id value) {
		@strongify(self)
		return [[self fetchSingal]
						flattenMap:^RACStream *(NSArray *viewModels) {
							return [[[viewModels.rac_sequence
												filter:^BOOL(MSFMyRepayViewModel *viewModel) {
													return YES;
												}]
											 signal]
											collect];
						}];
	}];
	[RACObserve(self, viewModels) subscribeNext:^(id x) {
		[_executeFetchCommand execute:@"0"];
	}];
	_executeFetchCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		self.identifer = input;
		return [RACSignal return:[self.viewModels.rac_sequence filter:^BOOL(MSFMyRepayViewModel *viewModel) {
			if ([self.identifer isEqualToString:@"0"]) {
				return YES;
			}
			return [viewModel.applyType isEqualToString:self.identifer];
		}].array];	}];

	return self;
}

- (RACSignal *)fetchStatus:(NSString *)status {
	return [[[[self.services.httpClient
						 fetchMyRepayWithType:status]
						catch:^RACSignal *(NSError *error) {
							return [RACSignal empty];
						}]
					 map:^id(id value) {
						 return [[MSFMyRepayViewModel alloc] initWithModel:value];
					 }]
					collect];
}

- (RACSignal *)fetchSingal {
	return [[RACSignal combineLatest:@[
																		 [[self fetchStatus:@"0"] ignore:nil],
																		 [[self fetchStatus:@"1"] ignore:nil],
																		 [[self fetchStatus:@"3"] ignore:nil],
																		 [[self fetchStatus:@"4"] ignore:nil]
																		 ]] flattenMap:^RACStream *(RACTuple *value) {
		RACTupleUnpack(NSArray *b, NSArray *c, NSArray *d, NSArray *e) = value;
		b = [[[b arrayByAddingObjectsFromArray:c] arrayByAddingObjectsFromArray:d] arrayByAddingObjectsFromArray:e];
		return [RACSignal return:b];
	}];
}

@end
