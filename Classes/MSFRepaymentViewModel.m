//
//  MSFRepaymentViewModel.m
//  Finance
//
//  Created by 赵勇 on 8/14/15.
//  Copyright (c) 2015 MSFINANCE. All rights reserved.
//

#import "MSFRepaymentViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFRepayMent.h"
#import "NSDateFormatter+MSFFormattingAdditions.h"

@interface MSFRepaymentViewModel ()

@property (nonatomic, strong) MSFRepayMent *repayment;

@end

@implementation MSFRepaymentViewModel

- (instancetype)initWithModel:(MSFRepayMent *)model {
	self = [super init];
	if (!self) {
		return nil;
	}
	
	RAC(self, repaymentStatus) = RACObserve(model, repaymentStatus);
	
	RAC(self, status) = [RACObserve(model, contractStatus) map:^id(id status) {
		NSDictionary *statusValues = @{
																	 @(0): @"无效",
																	 @(1): @"审核中",
																	 @(2): @"审核通过",
																	 @(3): @"审核未通过",
																	 @(4): @"还款中",
																	 @(5): @"已取消",
																	 @(6): @"已完结",
																	 @(7): @"已逾期",
																	 @(8): @"预审核通过",
																	 @(9): @"待放款"
																	 };
		
		return statusValues[status];
	}];

	_title = @"合同还款状态";
	
	RAC(self, expireDate) = RACObserve(model, expireDate);

	RAC(self, repaidAmount) = [RACObserve(model, allAmount) map:^id(id value) {
		return [NSString stringWithFormat:@"%@", value];
	}];

	return self;
	
}

@end