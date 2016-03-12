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

static NSString *const kApplicationCreditIdentifier = @"1101";
static NSString *const kApplicationCreditType = @"1";

@interface MSFCreditViewModel ()

@property (nonatomic, strong, readwrite) NSString *action;
@property (nonatomic, strong, readwrite) NSString *title;
@property (nonatomic, strong, readwrite) NSString *subtitle;

@property (nonatomic, strong, readwrite) NSString *applyAmouts;
@property (nonatomic, strong, readwrite) NSString *monthRepayAmounts;
@property (nonatomic, strong, readwrite) NSString *loanMonthes;

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
	
	_executeBillCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return [self billsSignal];
	}];
	_status = MSFApplicationActivated;
	
	[RACObserve(self, status) subscribeNext:^(NSNumber *status) {
		@strongify(self)
		self.monthRepayAmounts = @"0";
		self.loanMonthes = @"0";
		self.applyAmouts = @"0";
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
	return [RACSignal empty];
//TODO:
//	return [[[self.services.httpClient fetchRecentApplicaiton:@"4"]
//		catch:^RACSignal *(NSError *error) {
//			return [RACSignal return:NSNull.null];
//		}] map:^id(MSFApplyList *application) {
//			MSFApplicationStatus status = MSFApplicationNone;
//			if ([application isKindOfClass:NSNull.class] || application.appNo.length == 0) {
//				status  = MSFApplicationNone;
//			} else if ([application.status isEqualToString:@"G"]) {
//				status = MSFApplicationInReview;
//			} else if ([application.status isEqualToString:@"I"]) {
//				status = MSFApplicationConfirmation;
//			} else if ([application.status isEqualToString:@"L"]) {
//				status = MSFApplicationResubmit;
//			} else if ([application.status isEqualToString:@"E"]) {
//				status = MSFApplicationRelease;
//			} else if ([application.status isEqualToString:@"H"] || [application.status isEqualToString:@"K"]) {
//				status = MSFApplicationRejected;
//			} else {
//				status = MSFApplicationActivated;
//			}
//			return RACTuplePack(@(status), application);
//		}];
}

@end
