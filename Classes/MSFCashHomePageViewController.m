//
//  MSFCashHomePageViewController.m
//  Finance
//
//  Created by xbm on 15/10/2.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFCashHomePageViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Masonry/Masonry.h>
#import "MSFApplyCashVIewModel.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "MSFCheckAllowApply.h"
#import "MSFProductViewController.h"
#import "MSFClient.h"
#import "MSFUser.h"
#import "AppDelegate.h"
#import "MSFSetTradePasswordTableViewController.h"
#import "MSFDrawCashViewModel.h"
#import "MSFDrawCashTableViewController.h"
#import "MSFSocialCaskApplyTableViewController.h"
#import "MSFSocialInsuranceCashViewModel.h"

#import "MSFApplyView.h"
#import "MSFCashHomeLoanLimit.h"
#import "MSFFormsViewModel.h"
#import "MSFUserInfomationViewController.h"
#import "MSFSocialInsuranceCashViewModel.h"

@interface MSFCashHomePageViewController ()

@property (nonatomic, strong) MSFCirculateCashViewModel *circulateViewModel;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation MSFCashHomePageViewController

- (instancetype)initWithViewModel:(MSFApplyCashVIewModel *)viewModel {
	self = [super init];
	if (!self) {
		return nil;
	}
	_viewModel = viewModel;
	_circulateViewModel = [[MSFCirculateCashViewModel alloc]
												 initWithServices:viewModel.services];
	return self;
}

/*
 * 马上贷申请全屏入口
 */
- (void)msAdView {
	[self removeAllSubviews];
	MSFApplyView *ms = [[MSFApplyView alloc] initWithStatus:MSFApplyViewTypeMSFull actionBlock:^{
		[self.viewModel.executeAllowMSCommand execute:nil];
	}];
	[self.view addSubview:ms];
	[ms mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.view).offset(64);
		make.bottom.equalTo(self.view).offset(-49);
		make.left.right.equalTo(self.view);
	}];
}

/*
 * 马上贷、社保带申请入口
 */
- (void)sbAdView {
	[self removeAllSubviews];
	MSFApplyView *ms = [[MSFApplyView alloc] initWithStatus:MSFApplyViewTypeMS actionBlock:^{
		[self.viewModel.executeAllowMSCommand execute:nil];
	}];
	[self.view addSubview:ms];
	MSFApplyView *ml = [[MSFApplyView alloc] initWithStatus:MSFApplyViewTypeML actionBlock:^{
		[self.viewModel.executeAllowMLCommand execute:nil];
	}];
	[self.view addSubview:ml];
	[ml mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.view).offset(64);
		make.left.right.equalTo(self.view);
	}];
	[ms mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(ml.mas_bottom);
		make.bottom.equalTo(self.view).offset(-49);
		make.left.right.equalTo(self.view);
		make.height.equalTo(ml);
	}];
}

/*
 * 展示额度、马上贷申请入口
 */
- (void)limitView {
	[self removeAllSubviews];
	MSFCashHomeLoanLimit *limit = [[MSFCashHomeLoanLimit alloc] init];
	limit.withdrawButton.rac_command = self.withdrawCashCommand;
	limit.repayButton.rac_command = self.repayCommand;
	[limit setAvailableCredit:nil usedCredit:nil];
	[self.view addSubview:limit];
	
	MSFApplyView *ms = [[MSFApplyView alloc] initWithStatus:MSFApplyViewTypeLimitMS actionBlock:^{
		[self.viewModel.executeAllowMSCommand execute:nil];
	}];
	[self.view addSubview:ms];
	
	[ms mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.equalTo(self.view).offset(-49);
		make.left.right.equalTo(self.view);
		make.height.equalTo(ms.mas_width).multipliedBy(0.583);
	}];
	[limit mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.view).offset(64);
		make.left.right.equalTo(self.view);
		make.bottom.equalTo(ms.mas_top);
	}];
	@weakify(self)
	[RACObserve(self, circulateViewModel.usedLimit) subscribeNext:^(id x) {
		@strongify(self)
		[limit setAvailableCredit:self.circulateViewModel.usableLimit usedCredit:self.circulateViewModel.usedLimit];
	}];
}

- (void)removeAllSubviews {
	[self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
		[obj removeFromSuperview];
	}];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	@weakify(self)
	[[self rac_signalForSelector:@selector(viewWillAppear:)] subscribeNext:^(id x) {
		[[_viewModel fetchProductType] subscribeNext:^(NSNumber *x) {
			@strongify(self)
			switch (x.integerValue) {
				case 0:
					[self msAdView];
					break;
				case 1:
					[self sbAdView];
					break;
				case 2:
					[self limitView];
					break;
			}
		}];
	}];
	[self.viewModel.executeAllowMSCommand.executionSignals subscribeNext:^(RACSignal *signal) {
		@strongify(self)
		[SVProgressHUD showWithStatus:@"正在加载..." maskType:SVProgressHUDMaskTypeClear];
		[signal subscribeNext:^(MSFCheckAllowApply *model) {
			[SVProgressHUD dismiss];
			if (model.processing == 1) {
				MSFUserInfomationViewController *userInfoVC = [[MSFUserInfomationViewController alloc] initWithViewModel:self.viewModel services:self.viewModel.services];
				userInfoVC.showNextStep = YES;
				[self.navigationController pushViewController:userInfoVC animated:YES];
			} else {
				[[[UIAlertView alloc] initWithTitle:@"提示" message:@"您目前还有一笔贷款正在进行中，暂不能申请贷款。" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil] show];
			}
		}];
	}];
	[self.viewModel.executeAllowMSCommand.errors subscribeNext:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];
	[self.viewModel.executeAllowMLCommand.executionSignals subscribeNext:^(RACSignal *signal) {
		@strongify(self)
		[SVProgressHUD showWithStatus:@"正在加载..." maskType:SVProgressHUDMaskTypeClear];
		[signal subscribeNext:^(MSFCheckAllowApply *model) {
			[SVProgressHUD dismiss];
			if (model.processing == 1) {
				MSFSocialInsuranceCashViewModel *viewModel = [[MSFSocialInsuranceCashViewModel alloc] initWithFormsViewModel:self.viewModel.formViewModel productID:@"4102" services:self.viewModel.services];
				MSFUserInfomationViewController *userInfoVC = [[MSFUserInfomationViewController alloc] initWithViewModel:viewModel services:self.viewModel.services];
				userInfoVC.showNextStep = YES;
				[self.navigationController pushViewController:userInfoVC animated:YES];
			} else {
				[[[UIAlertView alloc] initWithTitle:@"提示" message:@"您目前还有一笔贷款正在进行中，暂不能申请贷款。" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil] show];
			}
		}];
	}];
	[self.viewModel.executeAllowMLCommand.errors subscribeNext:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];
}

- (BOOL)hasTransactionalCode {
	MSFUser *user = [self.viewModel.services httpClient].user;
	if (!user.hasTransactionalCode) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先设置交易密码" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
		[alert show];
		[alert.rac_buttonClickedSignal subscribeNext:^(NSNumber *index) {
			if (index.intValue == 1) {
				AppDelegate *delegate = [UIApplication sharedApplication].delegate;
				MSFAuthorizeViewModel *viewModel = delegate.authorizeVewModel;
				MSFSetTradePasswordTableViewController *setTradePasswordVC = [[MSFSetTradePasswordTableViewController alloc] initWithViewModel:viewModel];
				[self.navigationController pushViewController:setTradePasswordVC animated:YES];
			}
		}];
		return NO;
	}
	return YES;
}

- (RACCommand *)withdrawCashCommand {
	return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
			if ([self hasTransactionalCode]) {
				[[[self.circulateViewModel fetchBankCardListSignal].collect replayLazily] subscribeNext:^(id x) {
					[SVProgressHUD dismiss];
					self.dataArray = x;
					if (self.dataArray.count == 0) {
						[[[UIAlertView alloc] initWithTitle:@"提示" message:@"请先添加银行卡" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] show];
					} else {
						for (MSFBankCardListModel *model in self.dataArray) {
							if (model.master) {
								MSFDrawCashViewModel *viewModel = [[MSFDrawCashViewModel alloc] initWithModel:model AndCirculateViewmodel:self.circulateViewModel AndServices:self.viewModel.services AndType:0];
								MSFDrawCashTableViewController *drawCashVC = [UIStoryboard storyboardWithName:@"DrawCash" bundle:nil].instantiateInitialViewController;
								viewModel.drawCash = self.circulateViewModel.usableLimit;
								drawCashVC.viewModel = viewModel;
								drawCashVC.type = 0;
								[self.navigationController pushViewController:drawCashVC animated:YES];
								break;
							}
						}
					}
				} completed:^{
					[subscriber sendCompleted];
				}];
			} else {
				[subscriber sendCompleted];
			}
			return [RACDisposable disposableWithBlock:^{}];
		}];
	}];
}

- (RACCommand *)repayCommand {
	return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
			if ([self hasTransactionalCode]) {
				[[[self.circulateViewModel fetchBankCardListSignal].collect replayLazily] subscribeNext:^(id x) {
					[SVProgressHUD dismiss];
					self.dataArray = x;
					if (self.dataArray.count == 0) {
						[[[UIAlertView alloc] initWithTitle:@"提示" message:@"请先添加银行卡" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] show];
					} else {
						for (MSFBankCardListModel *model in self.dataArray) {
							if (model.master) {
								//TODO: 参数类型错误
								/*
								 MSFDrawCashViewModel *viewModel = [[MSFDrawCashViewModel alloc] initWithModel:model AndCirculateViewmodel:self.circulateViewModel AndServices:self.viewModel.services AndType:1];
								 MSFDrawCashTableViewController *drawCashVC = [UIStoryboard storyboardWithName:@"DrawCash" bundle:nil].instantiateInitialViewController;
								 viewModel.drawCash = self.usedL;
								 drawCashVC.viewModel = viewModel;
								 drawCashVC.type = 1;
								 [self.navigationController pushViewController:drawCashVC animated:YES];
								 break;
								 */
							}
						}
					}
				} completed:^{
					[subscriber sendCompleted];
				}];
			} else {
				[subscriber sendCompleted];
			}
			return [RACDisposable disposableWithBlock:^{}];
		}];
	}];
}

@end
