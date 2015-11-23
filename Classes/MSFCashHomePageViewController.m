//
//  MSFCashHomePageViewController.m
//  Finance
//
//  Created by xbm on 15/10/2.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFCashHomePageViewController.h"
#import "MSFEdgeButton.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFApplyCashVIewModel.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "MSFCheckAllowApply.h"
#import "MSFCirculateCashViewModel.h"
#import "MSFCirculateCashTableViewController.h"
#import "MSFProductViewController.h"
#import "MSFDeviceGet.h"
#import "UIColor+Utils.h"
#import "MSFClient.h"
#import "MSFUser.h"
#import "AppDelegate.h"
#import "MSFSetTradePasswordTableViewController.h"
#import "MSFBankCardListModel.h"
#import "MSFDrawCashViewModel.h"
#import "MSFDrawCashTableViewController.h"
#import "MSFGrayButton.h"
#import "MSFDrawCashViewModel.h"
#import "MSFLoanLimitView.h"
#import "MSFSocialCaskApplyTableViewController.h"
#import "MSFSocialInsuranceCashViewModel.h"

@interface MSFCashHomePageViewController ()
@property (weak, nonatomic) IBOutlet UIButton *nextBT;
@property (weak, nonatomic) IBOutlet UIButton *applyCashBT;
@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;
@property (weak, nonatomic) IBOutlet UIButton *applySocialBT;
@property (weak, nonatomic) IBOutlet UIView *twoAplyesView;
@property (weak, nonatomic) IBOutlet MSFEdgeButton *thirdApplyCashBT;
@property (weak, nonatomic) IBOutlet MSFGrayButton *outMoneyBT;
@property (weak, nonatomic) IBOutlet MSFGrayButton *repayMoneyBT;
@property (weak, nonatomic) IBOutlet UIView *circulateView;
@property (weak, nonatomic) IBOutlet MSFLoanLimitView *loanlimiteView;

@property (nonatomic, strong) MSFCirculateCashViewModel *circulateViewModel;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, copy) NSString *usableLimit;
@property (nonatomic, copy) NSString *usedL;
@property (nonatomic, copy) NSString *usedMoneyCount;

@end

@implementation MSFCashHomePageViewController

- (instancetype)initWithViewModel:(MSFApplyCashVIewModel *)viewModel AndCirculateViewModel:(MSFCirculateCashViewModel *)circulateViewModel {
	self = [UIStoryboard storyboardWithName:@"CashHomePage" bundle:nil].instantiateInitialViewController;
	if (!self) {
		return nil;
	}
	_viewModel = viewModel;
	_circulateViewModel = circulateViewModel;
	//self.circulateViewModel = [[MSFCirculateCashViewModel alloc] initWithServices:viewModel.services];
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	DeviceTypeNum deviceType = [MSFDeviceGet deviceNum];
	if (deviceType &( IPHONE4 | IPHONE4S)) {
		self.bgImgView.contentMode = UIViewContentModeCenter;
	}
	
	self.automaticallyAdjustsScrollViewInsets = NO;
	self.edgesForExtendedLayout = UIRectEdgeNone;
	
	self.circulateView.hidden = YES;
	[RACObserve(self, circulateViewModel.status) subscribeNext:^(NSNumber *status) {
		NSInteger type = status.integerValue;
		if (type == APPLYCASH) {
			self.twoAplyesView.hidden = YES;
//			self.applyCashBT.rac_command = self.viewModel.executeAllowCashCommand;
			self.nextBT.rac_command = self.viewModel.executeAllowCashCommand;
		} else if (type == APPLYANGCIRCULATECASH) {
			self.twoAplyesView.hidden = NO;
			self.circulateView.hidden = NO;
			self.thirdApplyCashBT.rac_command = self.viewModel.executeAllowCashCommand;
			
			
		} else if (type == ALLPYANDSOCIALCASH) {
			self.twoAplyesView.hidden = NO;
			self.circulateView.hidden = YES;
			self.applyCashBT.rac_command = self.viewModel.executeAllowCashCommand;
			
		}
//		if (![self.viewModel.services.httpClient.user.type isEqualToString:@"1101"]) {
//			self.twoAplyesView.hidden = YES;
//			self.applyCashBT.rac_command = self.viewModel.executeAllowCashCommand;
//			self.thirdApplyCashBT.rac_command = self.viewModel.executeAllowCashCommand;
//		} else if ([self.viewModel.services.httpClient.user.type isEqualToString:@"4401"]) {
//			
//			
//		} else if ([self.viewModel.services.httpClient.user.type isEqualToString:@""]) {
//			
//		}
	}];
	
	
	
	[[self.applySocialBT rac_signalForControlEvents:UIControlEventTouchUpInside]
	subscribeNext:^(id x) {
		MSFSocialInsuranceCashViewModel *viewModel = [[MSFSocialInsuranceCashViewModel alloc] initWithServices:self.viewModel.services];
		MSFSocialCaskApplyTableViewController *vc = [[MSFSocialCaskApplyTableViewController alloc] initWithViewModel:viewModel];
		vc.hidesBottomBarWhenPushed = YES;
		[self.navigationController pushViewController:vc animated:YES];
	}];
	
	//self.nextBT.rac_command = self.viewModel.executeAllowCashCommand;
	
	[self.viewModel.executeAllowCashCommand.executionSignals subscribeNext:^(RACSignal *signal) {
		[SVProgressHUD showWithStatus:@"正在加载..." maskType:SVProgressHUDMaskTypeClear];
		[signal subscribeNext:^(MSFCheckAllowApply *model) {
			[SVProgressHUD dismiss];
			if (model.processing == 1) {
				
					MSFProductViewController *productViewController = [[MSFProductViewController alloc] initWithViewModel:self.viewModel];
				  [productViewController setHidesBottomBarWhenPushed:YES];
					[self.navigationController pushViewController:productViewController animated:YES];

				
			} else {
				[[[UIAlertView alloc] initWithTitle:@"提示"
																		message:@"您目前还有一笔贷款正在进行中，暂不能申请贷款。"
																	 delegate:nil
													cancelButtonTitle:@"确认"
													otherButtonTitles:nil] show];
			}
			
		}];
	}];
	[self.viewModel.executeAllowCashCommand.errors subscribeNext:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];
	
	RAC(self, usableLimit) = [RACObserve(self.circulateViewModel, usableLimit) map:^id(id value) {
		
		return value;
	}];
	RAC(self, usedL) = RACObserve(self, circulateViewModel.latestDueMoney);
	
	RAC(self, usedMoneyCount) = [RACObserve(self, circulateViewModel.usedLimit) map:^id(id value) {
		[self.loanlimiteView setAvailableCredit:self.circulateViewModel.usableLimit usedCredit:self.circulateViewModel.usedLimit];
		//self.circulateView.hidden = NO;
		
		
		return value;
	}];

	
	[[self.outMoneyBT rac_signalForControlEvents:UIControlEventTouchUpInside]
	 subscribeNext:^(id x) {
		 
		 MSFUser *user = [self.viewModel.services httpClient].user;
		 if (!user.hasTransactionalCode) {
			 
			 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
																											 message:@"请先设置交易密码" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
			 [alert show];
			 [alert.rac_buttonClickedSignal subscribeNext:^(NSNumber *index) {
				 if (index.intValue == 1) {
					 AppDelegate *delegate = [UIApplication sharedApplication].delegate;
					 MSFAuthorizeViewModel *viewModel = delegate.authorizeVewModel;
					 MSFSetTradePasswordTableViewController *setTradePasswordVC = [[MSFSetTradePasswordTableViewController alloc] initWithViewModel:viewModel];
					 
					 [self.navigationController pushViewController:setTradePasswordVC animated:YES];
				 }
				 
			 }];
		 } else {
			 RACSignal *signal = [[self.circulateViewModel fetchBankCardListSignal].collect replayLazily];
			 [signal subscribeNext:^(id x) {
				 [SVProgressHUD dismiss];
				 self.dataArray = x;
				 if (self.dataArray.count == 0) {
					 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
																													 message:@"请先添加银行卡" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
					 [alert show];
					 return ;
				 }
				 for (MSFBankCardListModel *model in self.dataArray) {
					 if (model.master) {
						 MSFDrawCashViewModel *viewModel = [[MSFDrawCashViewModel alloc] initWithModel:model AndCirculateViewmodel:self.circulateViewModel AndServices:self.viewModel.services AndType:0];
						 MSFDrawCashTableViewController *drawCashVC = [UIStoryboard storyboardWithName:@"DrawCash" bundle:nil].instantiateInitialViewController;
						 viewModel.drawCash = self.usableLimit;
						 drawCashVC.viewModel = viewModel;
						 drawCashVC.type = 0;
						 [self.navigationController pushViewController:drawCashVC animated:YES];
						 break;
					 }
				 }
			 }];
		 }
		 
		 
	 }];
	
	[[self.repayMoneyBT rac_signalForControlEvents:UIControlEventTouchUpInside]
	 subscribeNext:^(id x) {
			MSFUser *user = [self.viewModel.services httpClient].user;
		 if (!user.hasTransactionalCode) {
			 
			 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
																											 message:@"请先设置交易密码" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
			 [alert show];
			 [alert.rac_buttonClickedSignal subscribeNext:^(NSNumber *index) {
				 if (index.intValue == 1) {
					 AppDelegate *delegate = [UIApplication sharedApplication].delegate;
					 MSFAuthorizeViewModel *viewModel = delegate.authorizeVewModel;
					 MSFSetTradePasswordTableViewController *setTradePasswordVC = [[MSFSetTradePasswordTableViewController alloc] initWithViewModel:viewModel];
					 
					 [self.navigationController pushViewController:setTradePasswordVC animated:YES];
				 }
				 
			 }];
		 } else {
			 RACSignal *signal = [[self.circulateViewModel fetchBankCardListSignal].collect replayLazily];
			 [signal subscribeNext:^(id x) {
				 [SVProgressHUD dismiss];
				 self.dataArray = x;
				 if (self.dataArray.count == 0) {
					 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
																													 message:@"请先添加银行卡" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
					 [alert show];
					 return ;
				 }
				 for (MSFBankCardListModel *model in self.dataArray) {
					 if (model.master) {
						 MSFDrawCashViewModel *viewModel = [[MSFDrawCashViewModel alloc] initWithModel:model AndCirculateViewmodel:self.circulateViewModel AndServices:self.viewModel.services AndType:1];
						 MSFDrawCashTableViewController *drawCashVC = [UIStoryboard storyboardWithName:@"DrawCash" bundle:nil].instantiateInitialViewController;
						 viewModel.drawCash = self.usedL;
						 drawCashVC.viewModel = viewModel;
						 drawCashVC.type = 1;
						 [self.navigationController pushViewController:drawCashVC animated:YES];
						 break;
					 }
				 }
			 }];
			 
		 }
		 
		 
		 
	 }];

	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
