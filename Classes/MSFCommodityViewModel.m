//
//  MSFCommodityViewModel.m
//  Finance
//
//  Created by xbm on 16/3/7.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFCommodityViewModel.h"
#import "MSFPhoto.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFClient+Photos.h"
#import "MSFClient+ApplyList.h"
#import "MSFApplyList.h"
#import "MSFAuthorizeViewModel.h"
#import "MSFUser.h"
#import "MSFBankCardListModel.h"
#import "MSFClient+BankCardList.h"
#import "MSFMyOderListsViewModel.h"
#import "MSFInventoryViewModel.h"
#import "MSFLoanType.h"
#import "MSFFormsViewModel.h"
#import "MSFAddBankCardViewModel.h"
#import "MSFMyRepaysViewModel.h"

static NSString *const kWalletIdentifier = @"3101";

@interface MSFCommodityViewModel ()

@property (nonatomic, strong, readwrite) NSArray *photos;
@property (nonatomic, assign, readwrite) MSFCommodityStatus status;
@property (nonatomic, strong) MSFApplyList *application;
@property (nonatomic, copy, readwrite) NSString *hasList;
@property (nonatomic, copy, readwrite) NSString *statusString;
@property (nonatomic, copy, readwrite) NSString *buttonTitle;

@end

@implementation MSFCommodityViewModel
- (instancetype)initWithServices:(id<MSFViewModelServices>)services {
	self = [super init];
	if (!self) {
		return nil;
	}
	_services = services;
	@weakify(self)
	[self.didBecomeActiveSignal subscribeNext:^(id x) {
		@strongify(self)
		[self.fetchPhotos subscribeNext:^(id x) {
			self.photos = x;
		}];
		[self.fetchWalletStatus subscribeNext:^(RACTuple *statusAndApplication) {
			RACTupleUnpack(NSNumber *status, MSFApplyList *application) = statusAndApplication;
			self.status = status.integerValue;
			self.application = application;
		}];
	}];
	_excuteActionCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return self.actionSignal;
	}];
	_executeBillsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return self.billsSignal;
	}];
	
	_executeBarCodeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [[self.services msf_barcodeScanSignal] doNext:^(id x) {
			[self.services pushViewModel:self];
//			MSFCartViewController *vc = [[MSFCartViewController alloc] initWithApplicationNo:x services:self.viewModel.services];
//			[self.navigationController pushViewController:vc animated:YES];
		}];
	}];
	
	[RACObserve(self, status) subscribeNext:^(NSNumber *status) {
		@strongify(self)
		switch (status.integerValue) {
				case MSFCommodityNone:
				self.hasList = @"最近没有订单";
				self.statusString = @"";
				self.buttonTitle = @"";
				break;
			case MSFCommodityInReview:
				self.hasList = @"最近一笔进度";
				self.statusString = @"申请审核中";
				self.buttonTitle = @"查看订单";
				break;
			case MSFCommodityConfirmation:
				self.hasList = @"最近一笔进度";
				self.statusString = @"审核通过";
				self.buttonTitle = @"待确认合同";
				break;
			case MSFCommodityResubmit:
				self.hasList = @"最近一笔进度";
				self.statusString = @"审核未通过";
				self.buttonTitle = @"资料重传";
				break;
			case MSFCommodityRelease:
				self.hasList = @"最近一笔进度";
				self.statusString = @"放款中";
				self.buttonTitle = @"";
				break;
			case MSFCommodityRejected:
				self.hasList = @"最近一笔进度";
				self.statusString = @"审核失败";
				self.buttonTitle = @"";
				break;
			case MSFCommodityPay:
				self.hasList = @"最近一笔进度";
				self.statusString = @"合同已确认";
				self.buttonTitle = @"去支付";
				break;
			default:
			break;
		}
	}];
	return self;
}

- (RACSignal *)fetchPhotos {
	return [[self.services.httpClient fetchAdv:@"B"] collect];
}

- (RACSignal *)fetchWalletStatus {
	return [[[self.services.httpClient fetchRecentApplicaiton:@"3"]
					 catch:^RACSignal *(NSError *error) {
						 return [RACSignal return:NSNull.null];
					 }] map:^id(MSFApplyList *application) {
						 MSFCommodityStatus status = MSFCommodityNone;
						 if ([application isKindOfClass:NSNull.class] || application.appNo.length == 0) {
							 status  = MSFCommodityNone;
						 } else if ([application.status isEqualToString:@"G"]) {
							 status = MSFCommodityInReview;
						 } else if ([application.status isEqualToString:@"I"]) {
							 status = MSFCommodityConfirmation;
						 } else if ([application.status isEqualToString:@"L"]) {
							 status = MSFCommodityResubmit;
						 } else if ([application.status isEqualToString:@"E"]) {
							 status = MSFCommodityRelease;
						 } else if ([application.status isEqualToString:@"H"] || [application.status isEqualToString:@"K"]) {
							 status = MSFCommodityRejected;
						 } else if ([application.status isEqualToString:@"J"]) {
							 status = MSFCommodityPay;
							 
						 }
						 
						 return RACTuplePack(@(status), application);
					 }];
}

- (RACSignal *)actionSignal {
	if (![self.services.httpClient.user isAuthenticated]) {
		return self.authenticateSignal;
	}
	
	if (self.status == MSFCommodityNone || self.status == MSFCommodityRejected) {
		return [[self.services.httpClient fetchBankCardList]
						flattenMap:^RACStream *(MSFBankCardListModel *bankcard) {
							if (bankcard.bankCardNo.length > 0) {
								return self.applicationSignal;
							} else {
								return self.bindBankcardSignal;
							}
						}];
	}
	
	if (self.status == MSFCommodityInReview) {
		//查看订单
		MSFMyOderListsViewModel *viewModel = [[MSFMyOderListsViewModel alloc] initWithservices:self.services];
		[self.services pushViewModel:viewModel];
	} else if (self.status == MSFCommodityConfirmation) {
		//确认合同
		[[NSNotificationCenter defaultCenter] postNotificationName:@"HOMEPAGECONFIRMCONTRACT" object:nil];
		
	} else if (self.status == MSFCommodityResubmit) {
		//资料重传
		MSFInventoryViewModel *viewModel = [[MSFInventoryViewModel alloc] initWithApplicaitonNo:self.application.appNo productID:kWalletIdentifier services:self.services];
		[self.services pushViewModel:viewModel];
	}
	return RACSignal.empty;
}

- (RACSignal *)authenticateSignal {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		MSFAuthorizeViewModel *viewModel = [[MSFAuthorizeViewModel alloc] initWithServices:self.services];
		[self.services presentViewModel:viewModel];
		[subscriber sendCompleted];
		return nil;
	}];
}

- (RACSignal *)applicationSignal {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		MSFLoanType *loanType = [[MSFLoanType alloc] initWithTypeID:kWalletIdentifier];
		MSFFormsViewModel *formsViewModel = [[MSFFormsViewModel alloc] initWithServices:self.services];
//		MSFSocialInsuranceCashViewModel *viewModel = [[MSFSocialInsuranceCashViewModel alloc] initWithFormsViewModel:formsViewModel loanType:loanType services:self.services];
//		viewModel.applicationNo = @"";
//		[self.services pushViewModel:viewModel];
		[subscriber sendCompleted];
		return nil;
	}];
}

- (RACSignal *)bindBankcardSignal {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		MSFFormsViewModel *formsViewModel = [[MSFFormsViewModel alloc] initWithServices:self.services];
		MSFAddBankCardViewModel *viewModel = [[MSFAddBankCardViewModel alloc] initWithFormsViewModel:formsViewModel andIsFirstBankCard:YES];
		[self.services pushViewModel:viewModel];
		[subscriber sendCompleted];
		return nil;
	}];
}

- (RACSignal *)billsSignal {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		MSFMyRepaysViewModel *viewModel = [[MSFMyRepaysViewModel alloc] initWithservices:self.services];
		[self.services pushViewModel:viewModel];
		[subscriber sendCompleted];
		return nil;
	}];
}

@end
