//
//  MSFMyOderListViewModel.m
//  Finance
//
//  Created by xbm on 16/3/2.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFMyOderListsViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFMyOrderListViewModel.h"
#import "MSFClient+Order.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface MSFMyOderListsViewModel ()

@property (nonatomic, strong, readwrite) NSArray *viewModels;
@property (nonatomic, copy, readwrite) NSString *identifer;

@end

@implementation MSFMyOderListsViewModel

- (instancetype)initWithservices:(id<MSFViewModelServices>)services {
	self = [super init];
	if (!self) {
		return nil;
	}
	_services = services;
	_viewModels = @[];
	_identifer = @"0";
	
	@weakify(self)
	RAC(self, viewModels) = [self.didBecomeActiveSignal flattenMap:^RACStream *(id value) {
		@strongify(self)
		[SVProgressHUD showWithStatus:@"正在加载..." maskType:SVProgressHUDMaskTypeClear];
		return [[self fetchSingal] flattenMap:^RACStream *(NSArray *viewModels) {
			[SVProgressHUD dismiss];
			return [[[viewModels.rac_sequence filter:^BOOL(MSFMyOrderListViewModel *viewModel) {
				return YES;
			}]
				signal]
					 collect];
						}];
	}];
	[RACObserve(self, viewModels) subscribeNext:^(id x) {
		@strongify(self)
		[_executeFetchCommand execute:self.identifer];
	}];
	_executeFetchCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		self.identifer = input;
		return [RACSignal return:[self.viewModels.rac_sequence filter:^BOOL(MSFMyOrderListViewModel *viewModel) {
			if ([self.identifer isEqualToString:@"0"]) {
				return YES;
			}
			return [viewModel.applyType isEqualToString:self.identifer];
		}].array];
	}];
	
	return self;
}

- (RACSignal *)fetchStatus:(NSString *)status {
	@weakify(self)
	return [[[[self.services.httpClient
						 fetchMyOrderListWithType:status]
						catch:^RACSignal *(NSError *error) {
							[SVProgressHUD dismiss];
							return [RACSignal empty];
						}]
					 map:^id(id value) {
						 @strongify(self)
						 return [[MSFMyOrderListViewModel alloc] initWithServices:self.services model:value];
					 }]
					collect];
}

- (RACSignal *)fetchSingal {
	return [[RACSignal combineLatest:@[
																		 [[self fetchStatus:@"0"] ignore:nil]
																		 ]] flattenMap:^RACStream *(RACTuple *value) {
		RACTupleUnpack(NSArray *b, NSArray *c, NSArray *d, NSArray *e) = value;
		b = [[[b arrayByAddingObjectsFromArray:c] arrayByAddingObjectsFromArray:d] arrayByAddingObjectsFromArray:e];
		return [RACSignal return:b];
	}];
}

@end
