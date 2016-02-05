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

#import "AppDelegate.h"

#import "MSFCheckAllowApply.h"
#import "MSFLoanType.h"
#import "MSFClient.h"
#import "MSFUser.h"

#import "MSFApplyView.h"
#import "MSFCashHomeLoanLimit.h"

#import "MSFApplyCashViewModel.h"
#import "MSFCashHomePageViewModel.h"
#import "MSFUserInfomationViewController.h"

#import "MSFSocialInsuranceCashViewModel.h"
#import "MSFSubmitApplyModel.h"

#import "MSFSetTradePasswordTableViewController.h"
#import "MSFAddBankCardTableViewController.h"
#import "MSFSocialCaskApplyTableViewController.h"
#import "MSFFormsViewModel.h"

@implementation MSFCashHomePageViewController

- (instancetype)initWithViewModel:(MSFCashHomePageViewModel *)viewModel {
	self = [super init];
	if (self) {
		_viewModel = viewModel;
		self.edgesForExtendedLayout = UIRectEdgeNone;
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
		make.edges.equalTo(self.view);
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
		make.top.left.right.equalTo(self.view);
	}];
	[ms mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(ml.mas_bottom);
		make.left.right.bottom.equalTo(self.view);
		make.height.equalTo(ml).multipliedBy(0.33);
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
		make.left.right.bottom.equalTo(self.view);
		make.height.equalTo(ms.mas_width).multipliedBy(0.583);
	}];
	[limit mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.left.right.equalTo(self.view);
		make.bottom.equalTo(ms.mas_top);
	}];
	[[RACSignal combineLatest:@[RACObserve(self, viewModel.usableLmt), RACObserve(self, viewModel.usedLmt)]] subscribeNext:^(RACTuple *x) {
		[limit setAvailableCredit:x.first usedCredit:x.second];
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
	
	//!!!: 重构贷款申请条件验证, 是否允许申请，是否绑定银行卡，是否设置交易密码
	// 判断是否允马上贷
	[self.viewModel.executeAllowMSCommand.executionSignals subscribeNext:^(RACSignal *signal) {
		@strongify(self)
		[SVProgressHUD showWithStatus:@"正在加载..." maskType:SVProgressHUDMaskTypeClear];
		[signal subscribeNext:^(MSFCheckAllowApply *model) {
			[SVProgressHUD dismiss];
			if (model.processing == 1) {
				
				MSFLoanType *loanType = [[MSFLoanType alloc] initWithTypeID:@"1101"];
				MSFApplyCashViewModel *viewModel = [[MSFApplyCashViewModel alloc] initWithViewModel:self.viewModel.formViewModel loanType:loanType];
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
	
	// 判断是否允许麻辣贷
	[self.viewModel.executeAllowMLCommand.executionSignals subscribeNext:^(RACSignal *signal) {
		@strongify(self)
		[SVProgressHUD showWithStatus:@"正在加载..." maskType:SVProgressHUDMaskTypeClear];
		[signal subscribeNext:^(MSFCheckAllowApply *model) {
			[SVProgressHUD dismiss];
			if (model.processing == 1) {
				MSFUser *user = self.viewModel.services.httpClient.user;
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
					return ;
				}
				if (!self.viewModel.formViewModel.master) {
					[SVProgressHUD showErrorWithStatus:@"请先添加银行卡"];
					MSFAddBankCardTableViewController *vc =  [UIStoryboard storyboardWithName:@"AddBankCard" bundle:nil].instantiateInitialViewController;
					BOOL isFirstBankCard = YES;
					vc.viewModel =  [[MSFAddBankCardViewModel alloc] initWithFormsViewModel:self.viewModel.formViewModel andIsFirstBankCard:isFirstBankCard];
					[self.navigationController pushViewController:vc animated:YES];
					return ;
				}
				MSFLoanType *loanType = [[MSFLoanType alloc] initWithTypeID:@"4102"];
				MSFSocialInsuranceCashViewModel *viewModel = [[MSFSocialInsuranceCashViewModel alloc] initWithFormsViewModel:self.viewModel.formViewModel loanType:loanType services:self.viewModel.services];
				viewModel.applicationNo = @"";
				MSFSocialCaskApplyTableViewController *insuranceViewController = [[MSFSocialCaskApplyTableViewController alloc] initWithViewModel:viewModel];
				insuranceViewController.hidesBottomBarWhenPushed = YES;
				[self.navigationController pushViewController:insuranceViewController animated:YES];
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
