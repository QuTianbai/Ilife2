//
//  MSFWalletRepayViewModel.m
//  Finance
//
//  Created by Wyc on 16/3/17.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFWalletRepayPlansViewModel.h"
#import "MSFClient+RepaymentSchedules.h"
#import "MSFMyRepayViewModel.h"
#import "MSFRepaymentSchedules.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFRepayPlanViewModle.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface MSFWalletRepayPlansViewModel()

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) MSFMyRepayViewModel *viewModel;

@end

@implementation MSFWalletRepayPlansViewModel

- (instancetype)initWithServices:(id<MSFViewModelServices>)servers viewModel:(id)viewModel {

	
    
	_services = servers;
	_viewModel = viewModel;
	@weakify(self)
	RAC(self, dataArray) = [self.didBecomeActiveSignal flattenMap:^RACStream *(id value) {
		@strongify(self)
		[SVProgressHUD showWithStatus:@"正在加载..." maskType:SVProgressHUDMaskTypeClear];
		return [[self fetchSingal]
						flattenMap:^RACStream *(NSArray *viewModels) {
							[SVProgressHUD dismiss];
							return [[[viewModels.rac_sequence
												filter:^BOOL(MSFRepayPlanViewModle *viewModel) {
													return YES;
												}]
											 signal]
											collect];
						}];
	}];
	[RACObserve(self, dataArray) subscribeNext:^(id x) {
		[_executeFetchCommand execute:nil];
	}];
	_executeFetchCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *input) {
		@strongify(self)
		return [RACSignal return:[self.dataArray.rac_sequence filter:^BOOL(MSFRepayPlanViewModle *viewModel) {
			NSLog(@"%@", viewModel);
				return YES;
			}].array];
	}];
	
	return self;
}

- (RACSignal *)fetchSingal {
	return [[RACSignal combineLatest:@[
																		 [[self fetchStatus] ignore:nil]
																		 ]] flattenMap:^RACStream *(RACTuple *value) {
		RACTupleUnpack(NSArray *b, NSArray *c, NSArray *d, NSArray *e) = value;
		b = [[[b arrayByAddingObjectsFromArray:c] arrayByAddingObjectsFromArray:d] arrayByAddingObjectsFromArray:e];
		return [RACSignal return:b];
	}];
}

- (RACSignal *)fetchStatus {
	return [[[[self.services.httpClient
						 fetchCircleRepaymentSchedulesContractNo:self.viewModel.contractNo]
						catch:^RACSignal *(NSError *error) {
							[SVProgressHUD dismiss];
							return [RACSignal empty];
						}]
					 map:^id(id value) {
						 return [[MSFRepayPlanViewModle alloc] initWithModel:value withCurrentLoanTerm:self.viewModel.loanCurrTerm];
					 }]
					collect];
}

@end
