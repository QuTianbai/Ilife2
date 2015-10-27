//
// MSFLoanViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFLoanViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFCirculateCashModel.h"
#import "MSFClient+ApplyList.h"
#import "MSFClient+RepaymentSchedules.h"
#import "NSDateFormatter+MSFFormattingAdditions.h"
#import "NSDictionary+MSFKeyValue.h"

@interface MSFLoanViewModel ()

@property (nonatomic, strong) MSFCirculateCashModel *model;

@end

@implementation MSFLoanViewModel

#pragma mark - Lifecycle

- (instancetype)initWithModel:(MSFCirculateCashModel *)model services:(id<MSFViewModelServices>)services {
	self = [super init];
	if (!self) {
		return nil;
	}
	_services = services;
	_model = model;
	
	RAC(self, type) = RACObserve(model, type);
	RAC(self, money) = RACObserve(model, money);
	RAC(self, loanTerm) = RACObserve(model, period);
	RAC(self, title) = [RACObserve(model, type) map:^id(NSString *type) {
		if ([model.contractStatus isEqualToString:@"E"]) {
			return @"合同状态";
		}
		if ([type isEqualToString:@"APPLY"]) {
			return @"贷款申请状态";
		} else {
			return @"合同还款状态";
		}
	}];
	
	RAC(self, status) = [RACSignal combineLatest:@[RACObserve(model, applyStatus), RACObserve(model, contractStatus)] reduce:^id(NSString *a, NSString *b){
		if ((a.length > 0 && b.length > 0) || (a.length == 0 && b.length == 0)) {
			return @"F";
		}
		return a.length > 0 ? a : b;
	}];
	RAC(self, statusString) = [RACObserve(self, status) map:^id(id value) {
		return [NSDictionary statusStringForKey:value];
	}];
	
	/*** 申请状态 ***/
	RAC(self, applyTime) = [RACObserve(model, applyDate) map:^id(id value) {
		if (![value isKindOfClass:NSString.class] || [value length] == 0) {
			return nil;
		}
		NSDateFormatter *df = [[NSDateFormatter alloc] init];
		[df setDateFormat:@"yyyyMMddHHmmss"];
		NSDate *date = [df dateFromString:value];
		return [NSDateFormatter msf_stringFromDate:date];
	}];
	//RAC(self, applyNo) = RACObserve(model, contractNo);
	
	/*** 还款状态 ***/
	RAC(self, applyDate) = RACObserve(model, applyDate);
	RAC(self, currentPeriodDate) = RACObserve(model, currentPeriodDate);
	
	return self;
}

- (RACSignal *)fetchApplyListSignal {
	return [self.services.httpClient fetchApplyList];
}

- (RACSignal *)fetchRepaymentSchedulesSignal {
	return [self.services.httpClient fetchRepaymentSchedules];
}

- (void)pushDetailViewController {
	[self.services pushViewModel:self];
}

@end
