//
//  MSFApplyStartTableViewController.m
//  Cash
//
//  Created by xbm on 15/5/27.
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFApplyStartTableViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFUtils.h"
#import "MSFCheckEmployee.h"
#import "MSFClient+MSFCheckEmploee.h"
#import "MSFMonths.h"
#import "MSFTeams.h"
#import "MSFApplyStartViewModel.h"
#import "MSFClient+MSFApplyInfo.h"
#import "MSFApplyInfo.h"
#import "MSFEdgeButton.h"
#import <RMPickerViewController/RMPickerViewController.h>
#import "MSFSelectKeyValues.h"
#import <libextobjc/extobjc.h>
#import "MSFApplyCash.h"
#import "MSFProgressHUD.h"
#import "MSFSelectionViewModel.h"
#import "MSFSelectionViewController.h"
#import "MSFCheckButton.h"
#import "MSFAFRequestViewModel.h"
#import "MSFWebViewController.h"
#import "MSFAgreementViewModel.h"
#import "MSFAgreement.h"
#import "MSFLoanAgreementWebView.h"

static NSString *const MSFAutoinputDebuggingEnvironmentKey = @"INPUT_AUTO_DEBUG";

@interface MSFApplyStartTableViewController ()

@property(weak, nonatomic) IBOutlet UITextField *applyCashNumTF;
@property(weak, nonatomic) IBOutlet UIButton *applyMonthsBT;
@property(weak, nonatomic) IBOutlet UITextField *applyMonthsTF;
@property(weak, nonatomic) IBOutlet UIButton *moneyUsedBT;
@property(weak, nonatomic) IBOutlet UITextField *moneyUsesTF;
@property(weak, nonatomic) IBOutlet UISwitch *isInLifeInsurancePlaneSW;
@property(weak, nonatomic) IBOutlet UILabel *repayMoneyMonth;
@property(weak, nonatomic) IBOutlet UIButton *nextPageBT;
@property(weak, nonatomic) IBOutlet MSFCheckButton *agreeButton;
@property(weak, nonatomic) IBOutlet UIButton *iAgreeBT;
@property(weak, nonatomic) IBOutlet UIButton *lifeInsuranceButton;

@property(nonatomic,strong) MSFApplyStartViewModel *viewModel;

@end

@implementation MSFApplyStartTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
	label.text = @"贷款申请";
	label.textColor = [UIColor whiteColor];
	label.font = [UIFont boldSystemFontOfSize:17];
	label.textAlignment = NSTextAlignmentCenter;
	self.navigationItem.titleView = label;
	self.applyMonthsTF.placeholder = @"请选择期数";
	self.moneyUsesTF.placeholder = @"请选择贷款用途";
	self.applyCashNumTF.placeholder = @"请输入的贷款金额";
	if (NSProcessInfo.processInfo.environment[MSFAutoinputDebuggingEnvironmentKey]) {
		self.applyCashNumTF.text = @"5000";
	}
	@weakify(self)
	RAC(self,viewModel) = [[[self rac_signalForSelector:@selector(viewWillAppear:)]
		flattenMap:^RACStream *(id value) {
			@strongify(self)
			if (self.viewModel) {
				return nil;
			}
			return self.updateViewModelSignal;
		}]
		ignore:nil];
	
	[[RACObserve(self, viewModel) ignore:nil]
		subscribeNext:^(id x) {
		@strongify(self)
			self.viewModel.applyInfoModel.page = @"1";
			self.viewModel.applyInfoModel.applyStatus1 = @"0";
			self.applyCashNumTF.placeholder = [NSString stringWithFormat:@"请输入%@-%@之间的数字",
			self.viewModel.checkEmployee.allMinAmount,self.viewModel.checkEmployee.allMaxAmount];
			 
			RAC(self.viewModel.requestViewModel,totalAmount) = self.applyCashNumTF.rac_textSignal;
			RAC(self.viewModel.requestViewModel,insurance) = self.isInLifeInsurancePlaneSW.rac_newOnChannel;
			 
			RAC(self.applyMonthsTF,text) = [RACObserve(self.viewModel.requestViewModel, productTerms) ignore:nil];
			RAC(self.repayMoneyMonth,text) = [RACObserve(self.viewModel.requestViewModel, termAmount) map:^id(NSNumber *value) {
			if (value.integerValue == 0) {
				return @"未知";
			}
			 
			return value.stringValue;
		}];
		RAC(self.moneyUsesTF,text) = [[RACObserve(self.viewModel.requestViewModel,purpose) ignore:nil] map:^id(id value) {
			return [value text];
		}];
		 
		[[self.applyMonthsBT rac_signalForControlEvents:UIControlEventTouchUpInside]
			subscribeNext:^(id x) {
				[self.view endEditing:YES];
				if (self.applyCashNumTF.text.integerValue % 100 != 0) {
					[MSFProgressHUD showErrorMessage:@"贷款金额必须为100的整数倍" inView:self.navigationController.view ];
					return;
				}
				MSFSelectionViewModel *viewModel = [MSFSelectionViewModel
				monthsViewModelWithProducts:self.viewModel.requestViewModel.productSet
				total:self.viewModel.requestViewModel.totalAmount];
				if ([viewModel numberOfItemsInSection:0] == 0) {
					NSString *string;
					NSMutableArray *region = [[NSMutableArray alloc] init];
					[self.viewModel.requestViewModel.productSet.teams enumerateObjectsUsingBlock:^(MSFTeams *obj, NSUInteger idx, BOOL *stop) {
						[region addObject:[NSString stringWithFormat:@"%@ 到 %@ 之间", obj.minAmount,obj.maxAmount]];
					}];
					string = [NSString stringWithFormat:@"请输入贷款金额范围在 %@ 的数字", [region componentsJoinedByString:@","]];
					[MSFProgressHUD showAlertTitle:@"提示" message:string];
					return;
				}
				
				MSFSelectionViewController *selectionViewController = [[MSFSelectionViewController alloc] initWithViewModel:viewModel];
				selectionViewController.title = @"选择贷款期数";
				[self.navigationController pushViewController:selectionViewController animated:YES];
				@weakify(selectionViewController)
				[selectionViewController.selectedSignal subscribeNext:^(MSFMonths *months) {
					@strongify(selectionViewController)
					[selectionViewController.navigationController popViewControllerAnimated:YES];
					self.viewModel.requestViewModel.product = months;
				}];
			}];
		 
		[[self.moneyUsedBT rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
			[self.view endEditing:YES];
			MSFSelectionViewModel *viewModel = [MSFSelectionViewModel selectKeyValuesViewModel:[MSFSelectKeyValues getSelectKeys:@"moneyUse"]];
			 
			MSFSelectionViewController *selectionViewController = [[MSFSelectionViewController alloc] initWithViewModel:viewModel];
			selectionViewController.title = @"选择贷款用途";
			[self.navigationController pushViewController:selectionViewController animated:YES];
			@weakify(selectionViewController)
			[selectionViewController.selectedSignal subscribeNext:^(MSFSelectKeyValues *selectValue) {
				@strongify(selectionViewController)
				[selectionViewController.navigationController popViewControllerAnimated:YES];
				self.viewModel.requestViewModel.purpose = selectValue;
			}];
		}];
		 
		[[self.nextPageBT rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
			@strongify(self)
			if (!self.viewModel.requestViewModel.product) {
				[MSFProgressHUD showErrorMessage:@"请选择贷款期数" inView:self.navigationController.view];
				return;
			}
			MSFLoanAgreementWebView *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MSFLoanAgreementWebView"];
			vc.hidesBottomBarWhenPushed = YES;
			[vc bindViewModel:self.viewModel];
			[self.navigationController pushViewController:vc animated:YES];
		}];
		self.iAgreeBT.rac_command = self.viewModel.requestViewModel.executeAgreeOnLicense;
		self.agreeButton.rac_command  = self.viewModel.requestViewModel.executeAgreeOnLicense;
		RAC(self.agreeButton,selected) = RACObserve(self.viewModel.requestViewModel, agreeOnLicense);
	}];
	[[self.lifeInsuranceButton rac_signalForControlEvents:UIControlEventTouchUpInside]
		subscribeNext:^(id x) {
			@strongify(self)
			MSFWebViewController *webViewController = [[MSFWebViewController alloc] initWithHTMLURL:
				[MSFUtils.agreementViewModel.agreement lifeInsuranceURL]];
			webViewController.hidesBottomBarWhenPushed = YES;
			[self.navigationController pushViewController:webViewController animated:YES];
	}];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	[segue.destinationViewController bindViewModel:self.viewModel];
	[segue.destinationViewController setHidesBottomBarWhenPushed:YES];
}

#pragma mark - MSFReactiveView

- (void)bindViewModel:(MSFApplyStartViewModel *)viewModel {
}

#pragma mark - Private

- (RACSignal *)updateViewModelSignal {
	return [[[[MSFUtils.httpClient.fetchCheckEmployee
		zipWith:MSFUtils.httpClient.fetchApplyInfo]
		catch:^RACSignal *(NSError *error) {
			[MSFProgressHUD showErrorMessage:error.userInfo[NSLocalizedFailureReasonErrorKey] inView:self.navigationController.view];
			return [RACSignal return:nil];
		}]
		ignore:nil]
		map:^id(RACTuple *value) {
			RACTupleUnpack(MSFCheckEmployee *employee, MSFApplyInfo *applyinfo) = value;
			MSFApplyStartViewModel *viewModel = [[MSFApplyStartViewModel alloc] initWithEmployee:employee applyInfo:applyinfo];
			return viewModel;
		}];
}

@end
