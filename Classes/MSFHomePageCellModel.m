//
//  MSFHomePageCellModel.m
//  Finance
//
//  Created by 赵勇 on 10/29/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFHomePageCellModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFCirculateCashModel.h"
#import "NSDictionary+MSFKeyValue.h"
#import "NSDateFormatter+MSFFormattingAdditions.h"
#import "MSFClient+MSFCirculateCash.h"
#import "MSFClient+RepaymentSchedules.h"
#import "MSFClient+ApplyList.h"

@interface MSFHomePageCellModel ()

@property (nonatomic, strong) MSFCirculateCashModel *model;

@end

@implementation MSFHomePageCellModel

- (instancetype)initWithModel:(MSFCirculateCashModel *)model
										 services:(id<MSFViewModelServices>)services {
	self = [super init];
	if (!self) {
		return nil;
	}
	
	_services = services;
	_model = model;
	
	[RACObserve(self.model, produceType) subscribeNext:^(id x) {
		if ([x isEqualToString:@"MS"]) {
			self.productType = MSFProductTypeMS;
		} else if ([x isEqualToString:@"XH"]) {
			self.productType = MSFProductTypeXH;
		} else if ([x isEqualToString:@"ML"]) {
			self.productType = MSFProductTypeML;
		}
	}];
	
	/*
	 马上金融
	 */
	RAC(self, money) = RACObserve(self.model, money);
	RAC(self, loanTerm) = RACObserve(self.model, period);
	RAC(self, title) = [RACObserve(self.model, type) map:^id(NSString *type) {
		if ([self.model.contractStatus isEqualToString:@"E"]) {
			return @"合同状态";
		}
		if ([type isEqualToString:@"APPLY"]) {
			return @"贷款申请状态";
		} else {
			return @"合同还款状态";
		}
	}];

	@weakify(self)
	[[RACSignal combineLatest:@[RACObserve(self, model.applyStatus), RACObserve(self, model.contractStatus)] reduce:^id(NSString *a, NSString *b){
		if ((a.length > 0 && b.length > 0) || (a.length == 0 && b.length == 0)) {
			return @"F";
		}
		return a.length > 0 ? a : b;
	}] subscribeNext:^(NSString *x) {
		@strongify(self)
		self.statusString = [NSDictionary statusStringForKey:x];
		if ([@[@"D", @"C"] containsObject:x]) {
			self.jumpDes = MSFHomePageDesRepayList;
		} else if ([x isEqualToString:@"I"]) {
			self.jumpDes = MSFHomePageDesContract;
		} else if ([x isEqualToString:@"L"]) {
			self.jumpDes = MSFHomePageDesUploadData;
		} else {
			self.jumpDes = MSFHomePageDesApplyList;
		}
		if ([@[@"G", @"H", @"I", @"J", @"K"] containsObject:x]) {
			self.dateDisplay = MSFHomePageDateDisplayTypeApply;
		} else if ([x isEqualToString:@"D"]) {
			self.dateDisplay = MSFHomePageDateDisplayTypeRepay;
		} else if ([x isEqualToString:@"C"]) {
			self.dateDisplay = MSFHomePageDateDisplayTypeOverDue;
		} else if ([x isEqualToString:@"E"]) {
			self.dateDisplay = MSFHomePageDateDisplayTypeProcessing;
		} else {
			self.dateDisplay = MSFHomePageDateDisplayTypeNone;
		}
	}];
	
	RAC(self, applyTime) = [RACObserve(self.model, applyDate) map:^id(id value) {
		NSDateFormatter *df = [[NSDateFormatter alloc] init];
		[df setDateFormat:@"yyyyMMddHHmmss"];
		NSDate *date = [df dateFromString:value];
		if (date) {
			return [NSDateFormatter msf_stringFromDate:date];
		}
		return nil;
	}];
	RAC(self, applyDate) = RACObserve(self.model, applyDate);
	RAC(self, currentPeriodDate) = RACObserve(self.model, currentPeriodDate);
	
	/*
	 随借随还
	 */
	RAC(self, totalLimit) = RACObserve(self.model, totalLimit);
	RAC(self, usedLimit) = RACObserve(self.model, usedLimit);
	RAC(self, usableLimit) = RACObserve(self.model, usableLimit);
	RAC(self, contractExpireDate) = RACObserve(self.model, contractExpireDate);
	RAC(self, latestDueMoney) = [RACObserve(self.model, latestDueMoney) map:^id(NSString *value) {
		return [NSString stringWithFormat:@"￥%@", value.length > 0 ? value : @"0"];
	}];
	RAC(self, latestDueDate) = RACObserve(self.model, latestDueDate);
	RAC(self, totalOverdueMoney) = RACObserve(self.model, totalOverdueMoney);
	RAC(self, contractNo) = RACObserve(self.model, contractNo);
	RAC(self, overdueMoney) = [RACObserve(self.model, overdueMoney) map:^id(NSString *value) {
		return [NSString stringWithFormat:@"￥%@", value.length > 0 ? value : @"0"];
	}];
	
	[self.didBecomeActiveSignal subscribeNext:^(id x) {
		@strongify(self)
		[[self.services.httpClient fetchCirculateCash] subscribeNext:^(MSFCirculateCashModel *model) {
			self.model = model;
		} error:^(NSError *error) {
			NSLog(@"%@", error.localizedDescription);
		}];
	}];
	
	return self;
}

- (RACSignal *)fetchApplyListSignal:(int)type {
	if (type == 0) {
		return [self.services.httpClient fetchMSApplyList];
	} else if (type == 1) {
		return [self.services.httpClient fetchSpicyApplyList];
	}
	return nil;
}

- (RACSignal *)fetchRepaymentSchedulesSignal {
	return [self.services.httpClient fetchRepaymentSchedules];
}

- (void)pushDetailViewController {
	[self.services pushViewModel:self];
}

@end
