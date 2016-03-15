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
#import "MSFSocialInsuranceCashViewModel.h"
#import "MSFAddBankCardViewModel.h"
#import "MSFApplyListViewModel.h"
#import "MSFInventoryViewModel.h"
#import "MSFDrawingsViewModel.h"
#import "MSFRepaymentViewModel.h"
#import "MSFOrderListViewModel.h"
#import "MSFMyRepaysViewModel.h"
#import "MSFUser.h"
#import "MSFClient+CheckAllowApply.h"
#import "MSFCheckAllowApply.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "MSFPersonalViewModel.h"

static NSString *const kApplicationWalletIdentifier = @"4102";
static NSString *const kApplicationWalletType = @"4";

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
@property (nonatomic, assign, readwrite) MSFApplicationStatus status;
@property (nonatomic, strong, readwrite) NSString *action;
@property (nonatomic, strong) MSFWallet *model;
@property (nonatomic, strong) MSFApplyList *application;
@property (nonatomic, strong, readwrite) MSFPhoto *photo;
@property (nonatomic, strong, readwrite) NSString *groundTitle;
@property (nonatomic, strong, readwrite) NSString *groundContent;

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
			self.groundContent = x;
		}];
		return [self.fetchWalletStatus doNext:^(RACTuple *statusAndApplication) {
			RACTupleUnpack(NSNumber *status, MSFApplyList *application) = statusAndApplication;
			self.status = status.integerValue;
			self.application = application;
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
			case MSFApplicationNone: {
				self.title = @"可借现金额度";
				self.subtitle = @"未激活";
				self.action = @"立即激活";
			} break;
			case MSFApplicationInReview: {
				self.title = @"申请审核中";
				self.subtitle = @"请稍候...";
				self.action = @"查看详情";
			} break;
			case MSFApplicationConfirmation: {
				self.title = @"待确认合同";
				self.subtitle = @"请确认";
				self.action = @"立即确认";
			} break;
			case MSFApplicationResubmit: {
				self.title = @"资料不符";
				self.subtitle = @"请重传";
				self.action = @"重传资料";
			} break;
			case MSFApplicationRejected: {
				self.title = @"资料不符";
				self.subtitle = @" ";
				self.action = @"再次申请";
			} break;
			case MSFApplicationRelease: {
				self.title = @"放款中";
				self.subtitle = @" ";
				self.action = @"查看详情";
			} break;
			case MSFApplicationActivated: {
				self.title = @"";
				self.subtitle = @"";
				self.action = @"";
				[[self.services.httpClient fetcchWallet] subscribeNext:^(MSFWallet *model) {
					self.model = model;
					self.totalAmounts = model.totalLimit;
					self.validAmounts = model.usableLimit;
					self.usedAmounts = model.usedLimit;
					self.loanRates = [NSString stringWithFormat:@"%f", model.feeRate];
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
		}]
		map:^id(MSFApplyList *application) {
			MSFApplicationStatus status = MSFApplicationNone;
			if ([application isKindOfClass:NSNull.class] || application.appNo.length == 0) {
				status  = MSFApplicationNone;
			} else if ([application.status isEqualToString:@"G"]) {
				status = MSFApplicationInReview;
			} else if ([application.status isEqualToString:@"I"]) {
				status = MSFApplicationConfirmation;
			} else if ([application.status isEqualToString:@"L"]) {
				status = MSFApplicationResubmit;
			} else if ([application.status isEqualToString:@"E"]) {
				status = MSFApplicationRelease;
			} else if ([application.status isEqualToString:@"H"] || [application.status isEqualToString:@"K"]) {
				status = MSFApplicationRejected;
			} else {
				status = MSFApplicationActivated;
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
		MSFAddBankCardViewModel *viewModel = [[MSFAddBankCardViewModel alloc] initWithServices:self.services andIsFirstBankCard:YES];
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
	
	if (self.status == MSFApplicationNone || self.status == MSFApplicationRejected) {
		
		[SVProgressHUD showWithStatus:@"请稍后..."];
		@weakify(self)
		return [[[self.services.httpClient fetchCheckAllowApply]
			 flattenMap:^id(MSFCheckAllowApply *model) {
				 @strongify(self)
				 if (model.processing == 1) {
					 [SVProgressHUD dismiss];
					return self.applicationSignal;
				 } else {
					 [SVProgressHUD dismiss];
					 [[[UIAlertView alloc] initWithTitle:@"提示" message:@"您目前还有一笔贷款正在进行中，暂不能申请贷款。" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil] show];
					 return nil;
				 }
			 }]
			doError:^(NSError *error) {
				[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
			}];
	}
	
	if (self.status == MSFApplicationInReview || self.status == MSFApplicationRelease) {
		MSFApplyListViewModel *viewModel = [[MSFApplyListViewModel alloc] initWithProductType:kApplicationWalletType services:self.services];
		[self.services pushViewModel:viewModel];
	} else if (self.status == MSFApplicationResubmit) {
		MSFInventoryViewModel *viewModel = [[MSFInventoryViewModel alloc] initWithApplicaitonNo:self.application.appNo productID:kApplicationWalletIdentifier services:self.services];
		[self.services pushViewModel:viewModel];
	} else if (self.status == MSFApplicationConfirmation) {
		[[NSNotificationCenter defaultCenter] postNotificationName:@"HOMEPAGECONFIRMCONTRACT" object:kApplicationWalletIdentifier];
	}
	return RACSignal.empty;
}

- (RACSignal *)drawSignal {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		MSFCirculateCashModel *model = [[MSFCirculateCashModel alloc] init];
		[model mergeValuesForKeysFromModel:self.model];
		MSFDrawingsViewModel *viewModel = [[MSFDrawingsViewModel alloc] initWithViewModel:model services:self.services];
		[self.services pushViewModel:viewModel];
		[subscriber sendCompleted];
		return nil;
	}];
}

- (RACSignal *)repaySignal {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		MSFCirculateCashModel *model = [[MSFCirculateCashModel alloc] init];
		[model mergeValuesForKeysFromModel:self.model];
		MSFRepaymentViewModel *viewModel = [[MSFRepaymentViewModel alloc] initWithViewModel:model services:self.services];
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
