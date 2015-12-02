//
//  MSFCashHomePageViewController.m
//  Finance
//
//  Created by xbm on 15/10/2.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFCashHomePageViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <Masonry/Masonry.h>

#import "MSFCheckAllowApply.h"
#import "MSFLoanType.h"

#import "MSFApplyView.h"
#import "MSFCashHomeLoanLimit.h"

#import "MSFApplyCashVIewModel.h"
#import "MSFCashHomePageViewModel.h"
#import "MSFUserInfomationViewController.h"

#import "MSFSocialInsuranceCashViewModel.h"
#import "MSFSubmitApplyModel.h"

@implementation MSFCashHomePageViewController

- (instancetype)initWithViewModel:(MSFCashHomePageViewModel *)viewModel {
	self = [super init];
	if (self) {
		_viewModel = viewModel;
	}
	return self;
}

//马上贷申请全屏入口
- (void)msAdView {
	for (MSFApplyView *view in self.view.subviews) {
		if ([view isKindOfClass:MSFApplyView.class] && view.type == MSFApplyViewTypeLimitMS) {
			return;
		}
	}
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

//马上贷、社保带申请入口
- (void)sbAdView {
	for (MSFApplyView *view in self.view.subviews) {
		if ([view isKindOfClass:MSFApplyView.class] && view.type == MSFApplyViewTypeLimitMS) {
			return;
		}
	}
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

//展示额度、马上贷申请入口
- (void)limitView {
	for (MSFApplyView *view in self.view.subviews) {
		if ([view isKindOfClass:MSFApplyView.class] && view.type == MSFApplyViewTypeLimitMS) {
			return;
		}
	}
	[self removeAllSubviews];
	MSFCashHomeLoanLimit *limit = [[MSFCashHomeLoanLimit alloc] init];
	limit.withdrawButton.rac_command = self.viewModel.executeWithdrawCommand;
	limit.repayButton.rac_command = self.viewModel.executeRepayCommand;
	MSFApplyView *ms = [[MSFApplyView alloc] initWithStatus:MSFApplyViewTypeLimitMS actionBlock:^{
		[self.viewModel.executeAllowMSCommand execute:nil];
	}];
	[self.view addSubview:limit];
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
	[RACObserve(self, viewModel.usedLmt) subscribeNext:^(id x) {
		@strongify(self)
		[limit setAvailableCredit:self.viewModel.usableLmt usedCredit:self.viewModel.usedLmt];
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
		@strongify(self)
		[self showPlaceholderView:NO];
		if (self.view.subviews.count == 0) {
			[SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
		}
		[[_viewModel fetchProductType] subscribeNext:^(NSNumber *x) {
			[SVProgressHUD dismiss];
			switch (x.integerValue) {
				case 0:
					[self msAdView];
					break;
				case 1:
					[self sbAdView];
					break;
				case 2:
					[self limitView];
					[self.viewModel refreshCirculate];
					break;
			}
		} error:^(NSError *error) {
			[SVProgressHUD dismiss];
			[self showPlaceholderView:YES];
		}];
	}];
	[self.viewModel.executeAllowMSCommand.executionSignals subscribeNext:^(RACSignal *signal) {
		@strongify(self)
		[SVProgressHUD showWithStatus:@"正在加载..." maskType:SVProgressHUDMaskTypeClear];
		[signal subscribeNext:^(MSFCheckAllowApply *model) {
			[SVProgressHUD dismiss];
			if (model.processing == 1) {
				
				MSFLoanType *loanType = [[MSFLoanType alloc] initWithTypeID:@"1101"];
				MSFApplyCashVIewModel *viewModel = [[MSFApplyCashVIewModel alloc] initWithViewModel:self.viewModel.formViewModel loanType:loanType];
				[[viewModel submitSignalWithStatus:@"0"] subscribeNext:^(MSFSubmitApplyModel *applyCash) {
					viewModel.applicationNo = applyCash.appNo;
					MSFUserInfomationViewController *userInfoVC = [[MSFUserInfomationViewController alloc] initWithViewModel:viewModel services:self.viewModel.services];
					userInfoVC.showNextStep = YES;
					[self.navigationController pushViewController:userInfoVC animated:YES];
					
				}];
				
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
				MSFLoanType *loanType = [[MSFLoanType alloc] initWithTypeID:@"4102"];
				MSFSocialInsuranceCashViewModel *viewModel = [[MSFSocialInsuranceCashViewModel alloc] initWithFormsViewModel:self.viewModel.formViewModel loanType:loanType services:self.viewModel.services];
				viewModel.applicationNo = @"";
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

- (void)showPlaceholderView:(BOOL)show {
	for (UIView *subview in self.view.subviews) {
		if (subview.tag == 1000) {
			[subview removeFromSuperview];
		}
	}
	if (!show) {
		return;
	}
	for (UIView *subview in self.view.subviews) {
		[subview removeFromSuperview];
	}
	UIView *view = [[UIView alloc] init];
	view.tag = 1000;
	view.backgroundColor = UIColor.clearColor;
	[self.view addSubview:view];
	[view mas_makeConstraints:^(MASConstraintMaker *make) {
		make.center.equalTo(self.view);
		make.width.equalTo(self.view);
		make.height.equalTo(@300);
	}];
	/*
	UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	[view addSubview:activityIndicatorView];
	
	[activityIndicatorView startAnimating];
	[activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(view);
		make.centerY.equalTo(view).offset(-40);
	}];*/
	
	UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-empty"]];
	[view addSubview:imgView];
	[imgView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(view);
		make.centerY.equalTo(view).offset(-40);
		make.size.mas_equalTo(CGSizeMake(69, 69));
	}];
	
	UILabel *label = UILabel.new;
	label.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
	label.textColor = UIColor.darkGrayColor;
	label.numberOfLines = 2;
	label.textAlignment = NSTextAlignmentCenter;
	label.text = @"数据加载异常，请稍后重试";
	[view addSubview:label];
	[label mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(imgView.mas_bottom).with.offset(10);
		make.height.equalTo(@40);
		make.left.equalTo(view).offset(30);
		make.right.equalTo(view).offset(-30);
	}];
}

@end
