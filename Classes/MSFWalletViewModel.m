//
// MSFWalletViewModel.m
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFWalletViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "MSFClient+Photos.h"
#import "MSFClient+ApplyList.h"
#import "MSFClient+Wallet.h"
#import "MSFClient+BankCardList.h"

#import "MSFPhoto.h"
#import "MSFApplyList.h"
#import "MSFWallet.h"
#import "MSFBankCardListModel.h"
#import "MSFLoanType.h"
#import "MSFCirculateCashModel.h"

#import "MSFAuthorizeViewModel.h"
#import "MSFFormsViewModel.h"
#import "MSFSocialInsuranceCashViewModel.h"
#import "MSFAddBankCardViewModel.h"
#import "MSFApplyListViewModel.h"
#import "MSFInventoryViewModel.h"
#import "MSFDrawingsViewModel.h"
#import "MSFRepaymentViewModel.h"
#import "MSFOrderListViewModel.h"
#import "MSFUser.h"

static NSString *const kWalletIdentifier = @"4102";

@interface MSFWalletViewModel ()

@property (nonatomic, strong, readwrite) NSString *title;
@property (nonatomic, strong, readwrite) NSString *subtitle;

@property (nonatomic, strong, readwrite) NSString *repayAmounts;
@property (nonatomic, strong, readwrite) NSString *repayDates;

@property (nonatomic, strong, readwrite) NSArray *photos;

@property (nonatomic, strong, readwrite) NSString *totalAmounts;
@property (nonatomic, strong, readwrite) NSString *validAmounts;
@property (nonatomic, strong, readwrite) NSString *usedAmounts;
@property (nonatomic, strong, readwrite) NSString *loanRates;
@property (nonatomic, strong, readwrite) NSString *repayDate;

@property (nonatomic, weak) id <MSFViewModelServices> services;
@property (nonatomic, assign, readwrite) MSFWalletStatus status;
@property (nonatomic, strong, readwrite) NSString *action;
@property (nonatomic, strong) MSFWallet *model;
@property (nonatomic, strong) MSFApplyList *application;
@property (nonatomic, strong, readwrite) MSFPhoto *photo;
@property (nonatomic, strong, readwrite) NSString *groundTitle;

@end

@implementation MSFWalletViewModel

- (instancetype)initWithServices:(id <MSFViewModelServices>)services {
  self = [super init];
  if (!self) {
    return nil;
  }
	
	_services = services;
	@weakify(self)
	[[self.didBecomeActiveSignal flattenMap:^RACStream *(id value) {
		@strongify(self)
		[self.fetchPhotos subscribeNext:^(id x) {
			self.photos = x;
		}];
		[self.fetchShow subscribeNext:^(id x) {
			self.groundTitle = x;
		}];
		return [self.fetchWalletStatus doNext:^(id x) {
			[self.fetchWalletStatus subscribeNext:^(RACTuple *statusAndApplication) {
				RACTupleUnpack(NSNumber *status, MSFApplyList *application) = statusAndApplication;
				self.status = status.integerValue;
				self.application = application;
			}];
		}];
	}] replayLast];
	
	[RACObserve(self, status) subscribeNext:^(NSNumber *status) {
		@strongify(self)
		self.totalAmounts = @"0";
		self.validAmounts = @"0";
		self.usedAmounts = @"0";
		self.loanRates = @"00.00%";
		self.repayDate = @"";
		switch (status.integerValue) {
			case MSFWalletNone: {
				self.title = @"可借现金额度";
				self.subtitle = @"未激活";
				self.action = @"立即激活";
			} break;
			case MSFWalletInReview: {
				self.title = @"申请审核中";
				self.subtitle = @"请稍候...";
				self.action = @"查看详情";
			} break;
			case MSFWalletConfirmation: {
				self.title = @"待确认合同";
				self.subtitle = @"请确认";
				self.action = @"立即确认";
			} break;
			case MSFWalletResubmit: {
				self.title = @"资料不符";
				self.subtitle = @"请重传";
				self.action = @"重传资料";
			} break;
			case MSFWalletRejected: {
				self.title = @"资料不符";
				self.subtitle = @" ";
				self.action = @"再次申请";
			} break;
			case MSFWalletRelease: {
				self.title = @"放款中";
				self.subtitle = @" ";
				self.action = @"查看详情";
			} break;
			case MSFWalletActivated: {
				self.title = @"";
				self.subtitle = @"";
				self.action = @"";
				[[self.services.httpClient fetcchWallet] subscribeNext:^(MSFWallet *model) {
					self.model = model;
					self.totalAmounts = [NSString stringWithFormat:@"%.2f", model.totalLimit];
					self.validAmounts = [NSString stringWithFormat:@"%.2f", model.usableLimit];
					self.usedAmounts = [NSString stringWithFormat:@"%.2f", model.usedLimit];
					self.loanRates = [NSString stringWithFormat:@"%.2f", model.feeRate];
					self.repayDate = model.latestDueDate;
				}];
			} break;
			default:
				break;
		}
	}];
	
	_excuteActionCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return self.actionSignal;
	}];
	_executeDrawCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return self.drawSignal;
	}];
	_executeRepayCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return self.repaySignal;
	}];
	_executeBillsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return self.billsSignal;
	}];
	
  return self;
}

#pragma mark - Private

- (RACSignal *)fetchWalletStatus {
	return [[[self.services.httpClient fetchRecentApplicaiton:@"4"]
		catch:^RACSignal *(NSError *error) {
			return [RACSignal return:NSNull.null];
		}] map:^id(MSFApplyList *application) {
			MSFWalletStatus status = MSFWalletNone;
			if ([application isKindOfClass:NSNull.class] || application.appNo.length == 0) {
				status  = MSFWalletNone;
			} else if ([application.status isEqualToString:@"G"]) {
				status = MSFWalletInReview;
			} else if ([application.status isEqualToString:@"I"]) {
				status = MSFWalletConfirmation;
			} else if ([application.status isEqualToString:@"L"]) {
				status = MSFWalletResubmit;
			} else if ([application.status isEqualToString:@"E"]) {
				status = MSFWalletRelease;
			} else if ([application.status isEqualToString:@"H"] || [application.status isEqualToString:@"K"]) {
				status = MSFWalletRejected;
			} else {
				status = MSFWalletActivated;
			}
			return RACTuplePack(@(status), application);
		}];
}

- (RACSignal *)fetchPhotos {
	return [[self.services.httpClient fetchAdv:@"A"] collect];
}

- (RACSignal *)fetchShow {
	return [self.services.httpClient fetchShow:@"A"];
}

- (RACSignal *)applicationSignal {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		MSFLoanType *loanType = [[MSFLoanType alloc] initWithTypeID:kWalletIdentifier];
		MSFSocialInsuranceCashViewModel *viewModel = [[MSFSocialInsuranceCashViewModel alloc] initWithServices:self.services];
		[self.services pushViewModel:viewModel];
		[subscriber sendCompleted];
		return nil;
	}];
}

- (RACSignal *)authenticateSignal {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		MSFAuthorizeViewModel *viewModel = [[MSFAuthorizeViewModel alloc] initWithServices:self.services];
		[self.services presentViewModel:viewModel];
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

#pragma mark - Custom Accessors

- (RACSignal *)actionSignal {
	if (![self.services.httpClient.user isAuthenticated]) {
		return self.authenticateSignal;
	}
	
	if (self.status == MSFWalletNone || self.status == MSFWalletRejected) {
		return [[self.services.httpClient fetchBankCardList]
			flattenMap:^RACStream *(MSFBankCardListModel *bankcard) {
				if (bankcard.bankCardNo.length > 0) {
					return self.applicationSignal;
				} else {
					return self.bindBankcardSignal;
				}
			}];
	}
	
	if (self.status == MSFWalletInReview || self.status == MSFWalletRelease) {
		MSFApplyListViewModel *viewModel = [[MSFApplyListViewModel alloc] initWithProductType:nil services:self.services];
		[self.services pushViewModel:viewModel];
	} else if (self.status == MSFWalletResubmit) {
		MSFInventoryViewModel *viewModel = [[MSFInventoryViewModel alloc] initWithApplicaitonNo:self.application.appNo productID:kWalletIdentifier services:self.services];
		[self.services pushViewModel:viewModel];
	} else if (self.status == MSFWalletConfirmation) {
		[[NSNotificationCenter defaultCenter] postNotificationName:@"HOMEPAGECONFIRMCONTRACT" object:nil];
	}
	return RACSignal.empty;
}

- (RACSignal *)drawSignal {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		MSFCirculateCashModel *model = [[MSFCirculateCashModel alloc] initWithDictionary:self.model.dictionaryValue error:nil];
		MSFDrawingsViewModel *viewModel = [[MSFDrawingsViewModel alloc] initWithViewModel:model services:self.services];
		[self.services pushViewModel:viewModel];
		[subscriber sendCompleted];
		return nil;
	}];
}

- (RACSignal *)repaySignal {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		MSFCirculateCashModel *model = [[MSFCirculateCashModel alloc] initWithDictionary:self.model.dictionaryValue error:nil];
		MSFRepaymentViewModel *viewModel = [[MSFRepaymentViewModel alloc] initWithViewModel:model services:self.services];
		[self.services pushViewModel:viewModel];
		[subscriber sendCompleted];
		return nil;
	}];
}

- (RACSignal *)billsSignal {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		MSFOrderListViewModel *viewModel = [[MSFOrderListViewModel alloc] initWithServices:self.services];
		[self.services pushViewModel:viewModel];
		[subscriber sendCompleted];
		return nil;
	}];
}

@end
