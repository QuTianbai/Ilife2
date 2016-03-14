//
//  MSFCreditViewModel.m
//  Finance
//
//  Created by Wyc on 16/3/7.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFCreditViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFClient+Photos.h"

#import "MSFPhoto.h"
#import "MSFClient+Photos.h"
#import "MSFMyRepaysViewModel.h"
#import "MSFApplyList.h"
#import "MSFApplyCashViewModel.h"
#import "MSFLoanType.h"
#import "MSFClient+ApplyList.h"
#import "MSFUser.h"
#import "MSFAuthorizeViewModel.h"
#import "MSFAddBankCardViewModel.h"
#import "MSFApplyListViewModel.h"
#import "MSFInventoryViewModel.h"
#import "MSFClient+BankCardList.h"
#import "MSFBankCardListModel.h"

static NSString *const kApplicationCreditIdentifier = @"1101";
static NSString *const kApplicationCreditType = @"1";

@interface MSFCreditViewModel ()

@property (nonatomic, strong, readwrite) NSString *action;
@property (nonatomic, strong, readwrite) NSString *title;
@property (nonatomic, strong, readwrite) NSString *subtitle;

@property (nonatomic, strong, readwrite) NSString *applyAmouts;
@property (nonatomic, strong, readwrite) NSString *monthRepayAmounts;
@property (nonatomic, strong, readwrite) NSString *loanMonthes;
@property (nonatomic, strong, readwrite) NSString *applyTerms;

@property (nonatomic, strong, readwrite) NSArray *photos;

@property (nonatomic, assign, readwrite) MSFApplicationStatus status;


@property (nonatomic, strong, readwrite) MSFPhoto *photo;
@property (nonatomic, strong, readwrite) NSString *groudTitle;

@property (nonatomic, strong) MSFApplyList *application;

@end

@implementation MSFCreditViewModel

- (instancetype)initWithServices:(id<MSFViewModelServices>)services {
	self = [super init];
	if (!self) {
			return nil;
	}
	@weakify(self)
	_services = services;
	_monthRepayAmounts = @"0";
	_applyTerms = @"0";
	_applyAmouts = @"0";
	_viewModel = [[MSFApplyCashViewModel alloc] initWithLoanType:[[MSFLoanType alloc] initWithTypeID:kApplicationCreditIdentifier] services:self.services];
	
	RAC(self, viewModel.active) = RACObserve(self, active);
	
	RAC(self, applyAmouts) = [RACObserve(self, viewModel.appLmt) map:^id(id value) {
		return [value isKindOfClass:NSNumber.class] ? [value stringValue] : value;
	}];
	RAC(self, applyTerms) = [RACObserve(self, viewModel.loanTerm) map:^id(id value) {
		return [value isKindOfClass:NSNumber.class] ? [value stringValue] : value;
	}];
	RAC(self, monthRepayAmounts) = [RACObserve(self, viewModel.loanFixedAmt) map:^id(id value) {
		return [value isKindOfClass:NSNumber.class] ? [value stringValue] : value;
	}];
	
	[[self.didBecomeActiveSignal flattenMap:^RACStream *(id value) {
		@strongify(self)
		[self.fetchPhotos subscribeNext:^(id x) {
			self.photos = x;
		}];
		return [self.fetchCreditStatus doNext:^(RACTuple *statusAndApplication) {
			RACTupleUnpack(NSNumber *status, MSFApplyList *application) = statusAndApplication;
			self.status = status.integerValue;
			self.application = application;
		}];
	}] replayLast];
	
	// Report
	RAC(self, reportNumber) = RACObserve(self, application.appNo);
	RAC(self, reportReason) = [RACObserve(self, application.loanPurpose) flattenMap:^RACStream *(id value) {
		return [[self.services msf_selectValuesWithContent:@"moneyUse" keycode:value] map:^id(id value) {
			return [NSString stringWithFormat:@"贷款用途：%@", value];
		}];
	}];
	RAC(self, reportAmounts) = [RACObserve(self, application.appLmt) map:^id(id value) {
		return [NSString stringWithFormat:@"%.2f", [value floatValue]];
	}];
	RAC(self, reportTerms) =
		[RACSignal combineLatest:@[
			RACObserve(self, application.loanTerm),
			RACObserve(self, application.loanFixedAmt)
		]
		reduce:^id (NSString *term, NSString *amt){
			return [NSString stringWithFormat:@"(月供 ¥%@ X %@期)", amt, term];
		}];
	RAC(self, reportMessage) = RACObserve(self, application.failInfo);
	
	_executeBillCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return [self billsSignal];
	}];
	_status = MSFApplicationActivated;
	
	[RACObserve(self, status) subscribeNext:^(NSNumber *status) {
		@strongify(self)
		switch (status.integerValue) {
			case MSFApplicationNone: {
				self.title = @"";
				self.subtitle = @"";
				self.action = @"";
			} break;
			case MSFApplicationInReview: {
				self.title = @"审核中";
				self.subtitle = @"申请已提交";
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
				self.subtitle = @"请稍等...";
				self.action = @"查看详情";
			} break;
			case MSFApplicationReleased: {
				self.title = @"恭喜您！";
				self.subtitle = @"已放款";
				self.action = @"查看详情";
			} break;
			case MSFApplicationActivated: {
				self.title = @"";
				self.subtitle = @"";
				self.action = @"";
			} break;
			default:
				break;
		}
	}];
	
	_excuteActionCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return [self actionSingal];
	}];
	
	return self;
	
}

#pragma mark - Private

- (RACSignal *)fetchPhotos {
	return [[self.services.httpClient fetchAdv:@"C"] collect];
}

- (RACSignal *)billsSignal {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		MSFMyRepaysViewModel *viewModel = [[MSFMyRepaysViewModel alloc] initWithservices:self.services];
		[self.services pushViewModel:viewModel];
		[subscriber sendCompleted];
		return nil;
	}];
}

- (RACSignal *)fetchCreditStatus {
	return [[[self.services.httpClient fetchRecentApplicaiton:kApplicationCreditType]
		catch:^RACSignal *(NSError *error) {
			return [RACSignal empty];
		}]
		map:^id(MSFApplyList *application) {
			MSFApplicationStatus status = MSFApplicationNone;
			if ([application isKindOfClass:NSNull.class] || application.appNo.length == 0) {
				if ([application isKindOfClass:NSNull.class]) {
					application = nil;
				}
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

- (RACSignal *)actionSingal {
	if (![self.services.httpClient.user isAuthenticated]) {
		return self.authenticateSignal;
	}
	
	if (self.status == MSFApplicationNone || self.status == MSFApplicationRejected) {
		return [[self.services.httpClient fetchBankCardList]
			flattenMap:^RACStream *(MSFBankCardListModel *bankcard) {
				if (bankcard.bankCardNo.length > 0) {
					return self.applicationSignal;
				} else {
					return self.bindBankcardSignal;
				}
			}];
	}
	
	if (self.status == MSFApplicationInReview || self.status == MSFApplicationRelease) {
		MSFApplyListViewModel *viewModel = [[MSFApplyListViewModel alloc] initWithProductType:kApplicationCreditType services:self.services];
		[self.services pushViewModel:viewModel];
	} else if (self.status == MSFApplicationResubmit) {
		MSFInventoryViewModel *viewModel = [[MSFInventoryViewModel alloc] initWithApplicaitonNo:self.application.appNo productID:kApplicationCreditIdentifier services:self.services];
		[self.services pushViewModel:viewModel];
	} else if (self.status == MSFApplicationConfirmation) {
		[[NSNotificationCenter defaultCenter] postNotificationName:@"HOMEPAGECONFIRMCONTRACT" object:kApplicationCreditType];
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

- (RACSignal *)bindBankcardSignal {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		MSFAddBankCardViewModel *viewModel = [[MSFAddBankCardViewModel alloc] initWithServices:self.services andIsFirstBankCard:YES];
		[self.services pushViewModel:viewModel];
		[subscriber sendCompleted];
		return nil;
	}];
}

- (RACSignal *)applicationSignal {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		[self.services pushViewModel:self.viewModel];
		[subscriber sendCompleted];
		return nil;
	}];
}

@end
