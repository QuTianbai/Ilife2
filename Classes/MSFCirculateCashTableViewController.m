//
//  MSFCirculateCashTableViewController.m
//  Finance
//
//  Created by xbm on 15/10/1.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFCirculateCashTableViewController.h"
#import "MSFLoanLimitView.h"
#import "MSFEdgeButton.h"
#import "MSFCirculateCashViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFDrawCashTableViewController.h"
#import "MSFDrawCashViewModel.h"
#import "MSFClient+MSFBankCardList.h"
#import "MSFUtils.h"
#import "MSFBankCardListModel.h"
#import "MSFSetTradePasswordTableViewController.h"
#import "AppDelegate.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface MSFCirculateCashTableViewController ()
@property (weak, nonatomic) IBOutlet MSFLoanLimitView *loanlimiteView;
@property (weak, nonatomic) IBOutlet MSFEdgeButton *outMoneyBT;
@property (weak, nonatomic) IBOutlet MSFEdgeButton *inputMoneyBT;
@property (weak, nonatomic) IBOutlet UILabel *outTimeMoneyLB;
@property (weak, nonatomic) IBOutlet UILabel *lastInputMoneyLB;
@property (weak, nonatomic) IBOutlet UILabel *lastInputMoneyTimeLB;
@property (weak, nonatomic) IBOutlet UILabel *countInpoutMoneyLB;
@property (weak, nonatomic) IBOutlet UILabel *deadLineLB;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, copy) NSString *contractNO;

@property (nonatomic, copy) NSString *usableLimit;

@property (nonatomic, copy) NSString *usedL;

@property (nonatomic, strong) MSFCirculateCashViewModel *viewModel;

@end

@implementation MSFCirculateCashTableViewController

- (instancetype)initWithViewModel:(MSFCirculateCashViewModel *)viewModel {
	self = [UIStoryboard storyboardWithName:@"CirculateCash" bundle:nil].instantiateInitialViewController;
	if (!self) {
		return nil;
	}
	_viewModel = viewModel;
	
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	RAC(self.lastInputMoneyLB, text) = RACObserve(self.viewModel, latestDueMoney);
	RAC(self.lastInputMoneyTimeLB, text) = RACObserve(self.viewModel, latestDueDate);
	RAC(self.countInpoutMoneyLB, text) = [RACObserve(self.viewModel, usedLimit) ignore:nil];
	RAC(self.deadLineLB, text) = RACObserve(self.viewModel, contractExpireDate);
	RAC(self.outTimeMoneyLB, text) = RACObserve(self, viewModel.overdueMoney);
	RAC(self, contractNO) = RACObserve(self.viewModel, contractNo);
	
	RAC(self, usableLimit) = [RACObserve(self.viewModel, usableLimit) map:^id(id value) {
		
		return value;
	}];
	
	[[self.outMoneyBT rac_signalForControlEvents:UIControlEventTouchUpInside]
	subscribeNext:^(id x) {
		
		if ([MSFUtils.isSetTradePassword isEqualToString:@"NO"]) {
			
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
			RACSignal *signal = [[MSFUtils.httpClient fetchBankCardList].collect replayLazily];
			[signal subscribeNext:^(id x) {
				[SVProgressHUD dismiss];
				self.dataArray = x;
				for (MSFBankCardListModel *model in self.dataArray) {
					if (model.master) {
						MSFDrawCashViewModel *viewModel = [[MSFDrawCashViewModel alloc] initWithModel:model AndCirculateViewmodel:self.viewModel AndServices:self.viewModel.services AndType:0];
						MSFDrawCashTableViewController *drawCashVC = [UIStoryboard storyboardWithName:@"DrawCash" bundle:nil].instantiateInitialViewController;
						drawCashVC.viewModel = viewModel;
						drawCashVC.type = 0;
						[self.navigationController pushViewController:drawCashVC animated:YES];
					}
				}
			}];
		}
		
		
	}];
	
	[[self.inputMoneyBT rac_signalForControlEvents:UIControlEventTouchUpInside]
	 subscribeNext:^(id x) {
		 
		 if ([MSFUtils.isSetTradePassword isEqualToString:@"NO"]) {
			 
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
			 RACSignal *signal = [[MSFUtils.httpClient fetchBankCardList].collect replayLazily];
			 [signal subscribeNext:^(id x) {
				 [SVProgressHUD dismiss];
				 self.dataArray = x;
				 for (MSFBankCardListModel *model in self.dataArray) {
					 if (model.master) {
						 MSFDrawCashViewModel *viewModel = [[MSFDrawCashViewModel alloc] initWithModel:model AndCirculateViewmodel:self.viewModel AndServices:self.viewModel.services AndType:1];
						 MSFDrawCashTableViewController *drawCashVC = [UIStoryboard storyboardWithName:@"DrawCash" bundle:nil].instantiateInitialViewController;
						 drawCashVC.viewModel = viewModel;
						 drawCashVC.type = 1;
						 [self.navigationController pushViewController:drawCashVC animated:YES];
					 }
				 }
			 }];

		 }
		 
		 
		 
	 }];
	
//	RAC(self, usedL) = [[RACSignal
//		combineLatest:@[
//										RACObserve(self, viewModel.usableLimit),
//										RACObserve(self, viewModel.usedLimit),
//										]]
//	 flattenMap:^RACStream *(RACTuple *modelAndMarket) {
//		 RACTupleUnpack(NSString *abeluser, NSString *usedmoney) = modelAndMarket;
//		 [self.loanlimiteView setAvailableCredit:abeluser usedCredit:usedmoney];
//		 return usedmoney;
//	 }];
//	
	
	RAC(self, usedL) = [RACObserve(self, viewModel.usedLimit) map:^id(id value) {
		[self.loanlimiteView setAvailableCredit:self.viewModel.usableLimit usedCredit:self.viewModel.usedLimit];
		
		return value;
	}];
	
	//[self.loanlimiteView setAvailableCredit:@"4000" usedCredit:@"3000"];
	
	self.viewModel.active = YES;
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
		[cell setSeparatorInset:UIEdgeInsetsZero];
	}
	if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
		[cell setLayoutMargins:UIEdgeInsetsZero];
	}
}

@end
