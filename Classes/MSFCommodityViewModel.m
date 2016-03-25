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
#import "MSFAddBankCardViewModel.h"
#import "MSFMyRepaysViewModel.h"
#import "MSFSocialInsuranceCashViewModel.h"
#import "MSFCartViewModel.h"
#import "MSFCartViewController.h"
#import "MSFCart.h"
#import "MSFClient+Cart.h"
#import "MSFClient+CheckAllowApply.h"
#import "MSFCheckAllowApply.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "MSFPersonalViewModel.h"

static NSString *const kWalletIdentifier = @"3101";
static NSString *const kApplicationType = @"3";

@interface MSFCommodityViewModel ()

@property (nonatomic, strong, readwrite) NSArray *photos;
@property (nonatomic, assign, readwrite) MSFApplicationStatus status;
@property (nonatomic, strong) MSFApplyList *application;
@property (nonatomic, copy, readwrite) NSString *hasList;
@property (nonatomic, copy, readwrite) NSString *statusString;
@property (nonatomic, copy, readwrite) NSString *buttonTitle;
@property (nonatomic, strong, readwrite) NSString *groundContent;

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
		[self.fetchShow subscribeNext:^(id x) {
			self.groundContent = x;
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
		return [self.services msf_barcodeScanSignal];
	}];
	_executeCartCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return [self cartSignal];
	}];
	
	[RACObserve(self, status) subscribeNext:^(NSNumber *status) {
		@strongify(self)
		switch (status.integerValue) {
				case MSFApplicationNone:
				self.hasList = @"最近没有订单";
				self.statusString = @"";
				self.buttonTitle = @"";
				break;
			case MSFApplicationInReview:
				self.hasList = @"最近一笔进度";
				self.statusString = @"申请审核中";
				self.buttonTitle = @"查看订单";
				break;
			case MSFApplicationConfirmation:
				self.hasList = @"最近一笔进度";
				self.statusString = @"审核通过";
				self.buttonTitle = @"待确认合同";
				break;
			case MSFApplicationResubmit:
				self.hasList = @"最近一笔进度";
				self.statusString = @"审核未通过";
				self.buttonTitle = @"资料重传";
				break;
			case MSFApplicationRelease:
				self.hasList = @"最近一笔进度";
				self.statusString = @"放款中";
				self.buttonTitle = @"";
				break;
			case MSFApplicationRejected:
				self.hasList = @"最近一笔进度";
                self.statusString = self.application.failInfo?:@"审核失败";
				self.buttonTitle = @"";
				break;
			case MSFApplicationConfirmationed:
				self.hasList = @"最近一笔进度";
				self.statusString = @"合同已确认";
				self.buttonTitle = @"去支付";
				break;
            case MSFApplicationPayedFirst:
                self.hasList = @"最近一笔进度";
                self.statusString = @"已支付首付";
                self.buttonTitle = @"";
                break;
            case MSFApplicationPayed:
                self.hasList = @"最近一笔进度";
                self.statusString = @"已支付";
                self.buttonTitle = @"";
                break;
            case MSFApplicationWillPay:
                self.hasList = @"最近一笔进度";
                self.statusString = @"待支付";
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
						 } else if ([application.status isEqualToString:@"J"] ) {
							 status = MSFApplicationConfirmationed;
							 
                         } else if ([application.status isEqualToString:@"O"]) {
                             status = MSFApplicationWillPay;
                             
                         } else if ([application.status isEqualToString:@"Q"]) {
                             status = MSFApplicationPayedFirst;
                             
                         } else if ([application.status isEqualToString:@"P"]) {
                             
                            status = MSFApplicationPayed;
                             
                         }
						 
						 return RACTuplePack(@(status), application);
					 }];
}

- (RACSignal *)actionSignal {
	if (![self.services.httpClient.user isAuthenticated]) {
		return self.authenticateSignal;
	}
	
	if (self.status == MSFApplicationNone || self.status == MSFApplicationNone) {
		return [[self.services.httpClient fetchBankCardList]
						flattenMap:^RACStream *(MSFBankCardListModel *bankcard) {
							if (bankcard.bankCardNo.length > 0) {
								return self.applicationSignal;
							} else {
								return self.bindBankcardSignal;
							}
						}];
	}
	
	if (self.status == MSFApplicationInReview) {
		//查看订单
		MSFMyOderListsViewModel *viewModel = [[MSFMyOderListsViewModel alloc] initWithservices:self.services];
		[self.services pushViewModel:viewModel];
	} else if (self.status == MSFApplicationConfirmation) {
		//确认合同
		[[NSNotificationCenter defaultCenter] postNotificationName:@"HOMEPAGECONFIRMCONTRACT" object:kApplicationType];
		
	} else if (self.status == MSFApplicationResubmit) {
		//资料重传
		MSFInventoryViewModel *viewModel = [[MSFInventoryViewModel alloc] initWithApplicaitonNo:self.application.appNo productID:self.application.productCd services:self.services];
		[self.services pushViewModel:viewModel];
    } else if (self.status == MSFApplicationConfirmationed || self.status == MSFApplicationWillPay) {
        //查看订单
        MSFMyOderListsViewModel *viewModel = [[MSFMyOderListsViewModel alloc] initWithservices:self.services];
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
		MSFSocialInsuranceCashViewModel *viewModel = [[MSFSocialInsuranceCashViewModel alloc] initWithServices:self.services];
		[self.services pushViewModel:viewModel];
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

- (RACSignal *)billsSignal {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		MSFMyRepaysViewModel *viewModel = [[MSFMyRepaysViewModel alloc] initWithservices:self.services];
        [viewModel.executeFetchCommand execute:@"3"];
        viewModel.butonIndex = @"3";
		[self.services pushViewModel:viewModel];
		[subscriber sendCompleted];
		return nil;
	}];
}

- (RACSignal *)cartSignal {
	if (![self.services.httpClient.user isAuthenticated]) {
		return self.authenticateSignal;
	}
	[SVProgressHUD showWithStatus:@"请稍后..."];
	@weakify(self)
	return [[[self.services.httpClient fetchCheckAllowApply]
		 flattenMap:^id(MSFCheckAllowApply *model) {
			 @strongify(self)
			 [SVProgressHUD dismiss];
			 if (model.processing == 1) {
				 return [[[self.services msf_barcodeScanSignal]
						flattenMap:^RACStream *(NSString *value) {
							MSFCart *cart = [[MSFCart alloc] initWithDictionary:@{@keypath(MSFCart.new, cartId): value?:@""} error:nil];
							return [self.services.httpClient fetchCartInfoForCart:cart];
						}]
					 doNext:^(id x) {
						 MSFCartViewModel *viewModel = [[MSFCartViewModel alloc] initWithModel:x services:self.services];
						 [self.services pushViewModel:viewModel];
					 }];
			 } else {
				 [[[UIAlertView alloc] initWithTitle:@"提示" message:@"您目前还有一笔贷款正在进行中，暂不能申请贷款。" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil] show];
				 return nil;
			 }
		 }]
		doError:^(NSError *error) {
			[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
		}];
}

- (RACSignal *)fetchShow {
	return [self.services.httpClient fetchShow:@"A"];
}

@end
