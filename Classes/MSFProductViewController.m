//
//  MSFProductViewController.m
//
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFProductViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/extobjc.h>
#import "MSFUtils.h"
#import "MSFCheckEmployee.h"
#import "MSFMonths.h"
#import "MSFTeams.h"
#import "MSFApplyStartViewModel.h"
#import "MSFApplyInfo.h"
#import "MSFEdgeButton.h"
#import "MSFSelectKeyValues.h"
#import "MSFApplyCash.h"
#import "MSFProgressHUD.h"
#import "MSFSelectionViewModel.h"
#import "MSFSelectionViewController.h"
#import "MSFProductViewModel.h"
#import "MSFWebViewController.h"
#import "MSFAgreementViewModel.h"
#import "MSFAgreement.h"
#import "MSFLoanAgreementWebView.h"
#import "MSFFormsViewModel.h"

static NSString *const MSFAutoinputDebuggingEnvironmentKey = @"INPUT_AUTO_DEBUG";

@interface MSFProductViewController ()

@property(weak, nonatomic) IBOutlet UITextField *applyCashNumTF;
@property(weak, nonatomic) IBOutlet UIButton *applyMonthsBT;
@property(weak, nonatomic) IBOutlet UITextField *applyMonthsTF;
@property(weak, nonatomic) IBOutlet UIButton *moneyUsedBT;
@property(weak, nonatomic) IBOutlet UITextField *moneyUsesTF;
@property(weak, nonatomic) IBOutlet UISwitch *isInLifeInsurancePlaneSW;
@property(weak, nonatomic) IBOutlet UILabel *repayMoneyMonth;
@property(weak, nonatomic) IBOutlet UIButton *nextPageBT;
@property(weak, nonatomic) IBOutlet UIButton *lifeInsuranceButton;

@property(nonatomic,strong) MSFProductViewModel *viewModel;
@property(nonatomic,strong) MSFFormsViewModel *formsViewModel;

@property(nonatomic,strong) RACCommand *executePurposeCommand;
@property(nonatomic,strong) RACCommand *executeTermCommand;
@property(nonatomic,strong) RACCommand *executeNextCommand;
@property(nonatomic,strong) RACCommand *executeLifeInsuranceCommand;

@end

@implementation MSFProductViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	if (NSProcessInfo.processInfo.environment[MSFAutoinputDebuggingEnvironmentKey]) {
		self.applyCashNumTF.text = @"50000";
	}
	
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
	label.text = @"贷款申请";
	label.textColor = [UIColor whiteColor];
	label.font = [UIFont boldSystemFontOfSize:17];
	label.textAlignment = NSTextAlignmentCenter;
	self.navigationItem.titleView = label;
	self.applyMonthsTF.placeholder = @"请选择期数";
	self.moneyUsesTF.placeholder = @"请选择贷款用途";
	
	@weakify(self)
	self.formsViewModel = [[MSFFormsViewModel alloc] initWithClient:MSFUtils.httpClient];
	
	self.viewModel = [[MSFProductViewModel alloc] initWithFormsViewModel:self.formsViewModel];
	RAC(self.viewModel,totalAmount) = self.applyCashNumTF.rac_textSignal;
	RAC(self.viewModel,insurance) = self.isInLifeInsurancePlaneSW.rac_newOnChannel;
	
	RAC(self.applyCashNumTF,placeholder) = RACObserve(self.viewModel, totalAmountPlacholder);
	RAC(self.repayMoneyMonth,text) = RACObserve(self.viewModel, termAmountText);
	RAC(self.moneyUsesTF,text) = RACObserve(self.viewModel, purposeText);
	RAC(self.applyMonthsTF,text) = RACObserve(self.viewModel, productTitle);
	self.applyMonthsBT.rac_command = self.executeTermCommand;
	[self.executeTermCommand.executionSignals subscribeNext:^(RACSignal *signal) {
		@strongify(self)
		[signal subscribeNext:^(id x) {
			self.viewModel.product = x;
		}];
	}];
	[self.executeTermCommand.errors subscribeNext:^(NSError *error) {
		@strongify(self)
		[MSFProgressHUD showErrorMessage:error.userInfo[NSLocalizedFailureReasonErrorKey] inView:self.navigationController.view];
	}];
	
	self.moneyUsedBT.rac_command = self.executePurposeCommand;
	[self.executePurposeCommand.executionSignals subscribeNext:^(RACSignal *signal) {
		@strongify(self)
		[signal subscribeNext:^(id x) {
			self.viewModel.purpose = x;
		}];
	}];
	
	self.nextPageBT.rac_command = self.executeNextCommand;
	[self.executeNextCommand.errors subscribeNext:^(NSError *error) {
		@strongify(self)
		[MSFProgressHUD showErrorMessage:error.userInfo[NSLocalizedFailureReasonErrorKey] inView:self.navigationController.view];
	}];
	self.lifeInsuranceButton.rac_command = self.executeLifeInsuranceCommand;
	
	self.formsViewModel.active = YES;
	[[self.tabBarController rac_signalForSelector:@selector(setSelectedViewController:)] subscribeNext:^(id x) {
		@strongify(self)
		UINavigationController *navigationController = [x first];
		self.formsViewModel.active = [navigationController.topViewController isKindOfClass:self.class];
	}];
}

#pragma mark - Private

- (RACCommand *)executePurposeCommand {
	if (_executePurposeCommand) {
		return _executePurposeCommand;
	}
	@weakify(self)
	_executePurposeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		[self.view endEditing:YES];
		MSFSelectionViewModel *viewModel = [MSFSelectionViewModel selectViewModelWithFilename:@"moneyUse"];
		MSFSelectionViewController *selectionViewController = [[MSFSelectionViewController alloc] initWithViewModel:viewModel];
		selectionViewController.title = @"选择贷款用途";
		[self.navigationController pushViewController:selectionViewController animated:YES];
		@weakify(selectionViewController)
		return [selectionViewController.selectedSignal doNext:^(id x) {
			@strongify(selectionViewController)
			[selectionViewController.navigationController popViewControllerAnimated:YES];
		}];
	}];
	_executePurposeCommand.allowsConcurrentExecution = YES;
	
	return _executePurposeCommand;
}

- (RACCommand *)executeTermCommand {
	if (_executeTermCommand) {
		return _executeTermCommand;
	}
	
	@weakify(self)
	_executeTermCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
			[self.view endEditing:YES];
				if (self.applyCashNumTF.text.integerValue % 100 != 0) {
				[subscriber sendError:[NSError errorWithDomain:@"MSFProductViewController" code:0 userInfo:@{
					NSLocalizedFailureReasonErrorKey: @"贷款金额必须为100的整数倍"
				}]];
				return nil;
			}
			if (self.viewModel.market.teams.count == 0) {
				[subscriber sendError:[NSError errorWithDomain:@"MSFProductViewController" code:0 userInfo:@{
					NSLocalizedFailureReasonErrorKey: @"没有适合的贷款产品"
				}]];
				return nil;
			}
			MSFSelectionViewModel *viewModel = [MSFSelectionViewModel monthsViewModelWithProducts:self.viewModel.market total:self.viewModel.totalAmount.integerValue];
			if ([viewModel numberOfItemsInSection:0] == 0) {
				NSString *string;
				NSMutableArray *region = [[NSMutableArray alloc] init];
				[self.viewModel.market.teams enumerateObjectsUsingBlock:^(MSFTeams *obj, NSUInteger idx, BOOL *stop) {
					[region addObject:[NSString stringWithFormat:@"%@ 到 %@ 之间", obj.minAmount,obj.maxAmount]];
				}];
				string = [NSString stringWithFormat:@"请输入贷款金额范围在 %@ 的数字", [region componentsJoinedByString:@","]];
				
				[subscriber sendError:[NSError errorWithDomain:@"MSFProductViewController" code:0 userInfo:@{
					NSLocalizedFailureReasonErrorKey: string,
				}]];
				return nil;
			}
			MSFSelectionViewController *selectionViewController = [[MSFSelectionViewController alloc] initWithViewModel:viewModel];
			selectionViewController.title = @"选择贷款期数";
			[self.navigationController pushViewController:selectionViewController animated:YES];
			@weakify(selectionViewController)
			[selectionViewController.selectedSignal subscribeNext:^(id x) {
				[subscriber sendNext:x];
				@strongify(selectionViewController)
				[selectionViewController.navigationController popViewControllerAnimated:YES];
			}];
			
			return nil;
		}];
	}];
	_executeTermCommand.allowsConcurrentExecution = YES;
	
	return _executeTermCommand;
}

- (RACCommand *)executeNextCommand {
	if (_executeNextCommand) {
		return _executeNextCommand;
	}
	@weakify(self)
	_executeNextCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
			@strongify(self)
			if (!self.viewModel.product) {
				[subscriber sendError:[NSError errorWithDomain:@"MSFProductViewController" code:0 userInfo:@{
					NSLocalizedFailureReasonErrorKey: @"请选择贷款期数",
				}]];
				return nil;
			}
			if (!self.viewModel.purpose) {
				[subscriber sendError:[NSError errorWithDomain:@"MSFProductViewController" code:0 userInfo:@{
					NSLocalizedFailureReasonErrorKey: @"请选择贷款用途",
				}]];
				return nil;
			}
			MSFLoanAgreementWebView *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MSFLoanAgreementWebView"];
			vc.hidesBottomBarWhenPushed = YES;
			[vc bindViewModel:self.viewModel.formsViewModel];
			[self.navigationController pushViewController:vc animated:YES];
			[subscriber sendCompleted];
			return nil;
		}];
	}];
	
	return _executeNextCommand;
}

- (RACCommand *)executeLifeInsuranceCommand {
	if (_executeLifeInsuranceCommand) {
		return _executeLifeInsuranceCommand;
	}
		@weakify(self)
	_executeLifeInsuranceCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
			@strongify(self)
			MSFWebViewController *webViewController = [[MSFWebViewController alloc] initWithHTMLURL:
			[MSFUtils.agreementViewModel.agreement lifeInsuranceURL]];
			webViewController.hidesBottomBarWhenPushed = YES;
			[self.navigationController pushViewController:webViewController animated:YES];
			return nil;
		}];
	}];
	
	return _executeLifeInsuranceCommand;
}

@end
