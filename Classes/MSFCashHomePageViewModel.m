//
// MSFCashHomePageViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFCashHomePageViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <Mantle/EXTScope.h>

#import "MSFClient+MSFCheckAllowApply.h"
#import "MSFClient+MSFProductType.h"
#import "MSFClient+MSFCirculateCash.h"
#import "MSFClient+MSFBankCardList.h"

#import "MSFUser.h"
#import "MSFCirculateCashModel.h"
#import "AppDelegate.h"

#import "MSFCirculateCashViewModel.h"
#import "MSFFormsViewModel.h"
#import "MSFAuthorizeViewModel.h"
#import "MSFBankCardListModel.h"
#import "MSFDrawCashViewModel.h"

#import "MSFDrawCashTableViewController.h"
#import "MSFSetTradePasswordTableViewController.h"
#import "MSFRepaymentViewModel.h"

@interface MSFCashHomePageViewModel ()

@property (nonatomic, strong) MSFCirculateCashViewModel *circulateViewModel;

@end

@implementation MSFCashHomePageViewModel

- (instancetype)initWithFormViewModel:(MSFFormsViewModel *)formViewModel services:(id <MSFViewModelServices>)services {
	self = [super init];
	if (!self) {
		return nil;
	}
	_formViewModel = formViewModel;
	_services = services;
	_circulateViewModel = [[MSFCirculateCashViewModel alloc] initWithServices:services];
	
	RAC(self, usedLmt) = RACObserve(self, circulateViewModel.infoModel.usedLimit);
	RAC(self, usableLmt) = RACObserve(self, circulateViewModel.infoModel.usableLimit);
	@weakify(self)
	_executeAllowMSCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self executeAllow];
	}];
	_executeAllowMLCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self executeAllow];
	}];
	_executeWithdrawCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self withdrawSignal];
	}];
	_executeRepayCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return [self repaySignal];
	}];
	
	return self;
}

#pragma mark - Private

- (void)refreshCirculate {
	[self.circulateViewModel.executeRefrshCashHomeCommand execute:nil];
}

- (RACSignal *)executeAllow {
	return [self.services.httpClient fetchCheckAllowApply];
}

- (RACSignal *)fetchProductType {
	return [RACSignal combineLatest:@[[self.services.httpClient fetchProductType], [self.services.httpClient fetchCirculateCash:@"2"]] reduce:^id(NSArray *product, MSFCirculateCashModel *loan){
		if (loan.totalLimit.doubleValue > 0 && ![loan.contractStatus isEqualToString:@"B"]) {
			return @2;
		} else {
			if ([product containsObject:@"4102"]) {
				return @1;
			} else {
				return @0;
			}
		}
	}];
}

- (RACSignal *)withdrawSignal {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		if ([self hasTransactionalCode]) {
			[[[self.services.httpClient fetchBankCardList].collect replayLazily] subscribeNext:^(id x) {
				[SVProgressHUD dismiss];
				NSArray *dataArray = x;
				if (dataArray.count == 0) {
					[[[UIAlertView alloc] initWithTitle:@"提示" message:@"请先添加银行卡" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] show];
				} else {
					[dataArray enumerateObjectsUsingBlock:^(MSFBankCardListModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
						if (obj.master) {
							MSFDrawCashViewModel *viewModel = [[MSFDrawCashViewModel alloc] initWithModel:obj AndCirculateViewmodel:self.circulateViewModel AndServices:self.services AndType:0];
							viewModel.drawCash = self.circulateViewModel.usableLimit;
							[self.services pushViewModel:viewModel];
							*stop = YES;
						}
					}];
				}
			} completed:^{
				[subscriber sendCompleted];
			}];
		} else {
			[subscriber sendCompleted];
		}
		return [RACDisposable disposableWithBlock:^{}];
	}];
}

- (RACSignal *)repaySignal {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		if ([self hasTransactionalCode]) {
			[[[self.services.httpClient fetchBankCardList].collect replayLazily] subscribeNext:^(id x) {
				[SVProgressHUD dismiss];
				NSArray *dataArray = x;
				if (dataArray.count == 0) {
					[[[UIAlertView alloc] initWithTitle:@"提示" message:@"请先添加银行卡" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] show];
				} else {
					MSFRepaymentViewModel *viewModel = [[MSFRepaymentViewModel alloc] initWithViewModel:self.circulateViewModel services:self.services];
					[self.services pushViewModel:viewModel];
				}
			} completed:^{
				[subscriber sendCompleted];
			}];
		} else {
			[subscriber sendCompleted];
		}
		return [RACDisposable disposableWithBlock:^{}];
	}];
}

- (BOOL)hasTransactionalCode {
	MSFUser *user = self.services.httpClient.user;
	if (!user.hasTransactionalCode) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先设置交易密码" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
		[alert show];
		[alert.rac_buttonClickedSignal subscribeNext:^(NSNumber *index) {
			if (index.intValue == 1) {
				AppDelegate *delegate = [UIApplication sharedApplication].delegate;
				[self.services pushViewModel:delegate.authorizeVewModel];
			}
		}];
		return NO;
	}
	return YES;
}

@end
