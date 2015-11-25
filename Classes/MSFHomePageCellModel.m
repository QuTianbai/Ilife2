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
#import "MSFClient+MSFCirculateCash.h"
#import "MSFClient+RepaymentSchedules.h"
#import "MSFClient+ApplyList.h"
#import "MSFApplyListViewModel.h"
#import "MSFRepaymentViewModel.h"
#import "MSFInventoryViewModel.h"

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
	//NSString *productType = model.produceType;
	
	RAC(self, productType) = RACObserve(self, model.productType);
	
	/*
	 马上金融
	 */
	RAC(self, money) = RACObserve(self, model.money);
	RAC(self, loanTerm) = RACObserve(self, model.period);
	RAC(self, title) = [RACObserve(self, model.type) map:^id(NSString *type) {
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
		if ([self.model.productType isEqualToString:@"4102"]) {
			self.dateDisplay = MSFHomePageDateDisplayTypeNone;
		} else if ([@[@"G", @"H", @"J", @"K"] containsObject:x]) {
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
	
	RAC(self, applyTime) = RACObserve(self, model.applyDate);
	RAC(self, applyDate) = RACObserve(self, model.applyDate);
	RAC(self, currentPeriodDate) = RACObserve(self, model.currentPeriodDate);
	
	/*
	 随借随还
	 */
	RAC(self, totalLimit) = RACObserve(self, model.totalLimit);
	RAC(self, usedLimit) = RACObserve(self, model.usedLimit);
	RAC(self, usableLimit) = RACObserve(self, model.usableLimit);
	RAC(self, contractExpireDate) = RACObserve(self, model.contractExpireDate);
	RAC(self, latestDueMoney) = [RACObserve(self, model.latestDueMoney) map:^id(NSString *value) {
		return [NSString stringWithFormat:@"￥%@", value.length > 0 ? value : @"0"];
	}];
	RAC(self, latestDueDate) = RACObserve(self, model.latestDueDate);
	RAC(self, totalOverdueMoney) = RACObserve(self, model.totalOverdueMoney);
	RAC(self, contractNo) = RACObserve(self, model.contractNo);
	RAC(self, overdueMoney) = [RACObserve(self, model.overdueMoney) map:^id(NSString *value) {
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

- (void)pushDetailViewController {
	id viewModel = nil;
	switch (self.jumpDes) {
		case MSFHomePageDesApplyList:
			viewModel = [[MSFApplyListViewModel alloc] initWithServices:self.services];
			break;
		case MSFHomePageDesRepayList:
			viewModel = [[MSFRepaymentViewModel alloc] initWithServices:self.services];
			break;
		case MSFHomePageDesContract: {
			//!!!: 这里存在问题，资料重传的状态我测试获取到的是 `MSFHomePageDesUploadData` @objczl
			viewModel = [[MSFInventoryViewModel alloc] initWithApplicaitonNo:self.model.applyNo productID:self.model.productType services:self.services];
			break;
		}
		case MSFHomePageDesUploadData: {
			viewModel = [[MSFInventoryViewModel alloc] initWithApplicaitonNo:self.model.applyNo productID:self.model.productType services:self.services];
			break;
		}
		default:break;
	}
	[self.services pushViewModel:viewModel];
}

@end
