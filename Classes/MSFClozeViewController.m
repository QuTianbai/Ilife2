//
// MSFComplementViewController.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFClozeViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/extobjc.h>
#import "MSFClozeViewModel.h"
#import "MSFUtils.h"
#import "MSFProcedureViewController.h"
#import "MSFSelectionViewModel.h"
#import "MSFSelectionViewController.h"
#import "MSFSelectKeyValues.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface MSFClozeViewController () <UITextFieldDelegate>

@property(nonatomic,strong) MSFClozeViewModel *viewModel;
@property(nonatomic,strong) MSFProcedureViewController *procedureViewController;

@end

@implementation MSFClozeViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	self.edgesForExtendedLayout = UIRectEdgeNone;
	self.viewModel = [[MSFClozeViewModel alloc] initWithAuthorizedClient:MSFUtils.httpClient controller:self];
	RAC(self.viewModel,name) = self.procedureViewController.name.rac_textSignal;
	RAC(self.viewModel,card) = self.procedureViewController.card.rac_textSignal;
	RAC(self.viewModel,bankNO) = self.procedureViewController.bankNO.rac_textSignal;
	
	// Submit
	self.procedureViewController.submitButton.rac_command = self.viewModel.executeAuth;
	@weakify(self)
	[self.procedureViewController.submitButton.rac_command.executionSignals subscribeNext:^(RACSignal *authSignal) {
		@strongify(self)
		[self.procedureViewController.view endEditing:YES];
		[SVProgressHUD showWithStatus:@"正在提交..." maskType:SVProgressHUDMaskTypeClear];
		[authSignal subscribeNext:^(id x) {
			[SVProgressHUD dismiss];
			[self dismissViewControllerAnimated:YES completion:nil];
		}];
	}];
	[self.procedureViewController.submitButton.rac_command.errors subscribeNext:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];
	
	// Identifier Card Lifelong
	RAC(self.procedureViewController.permanentButton,selected) =	RACObserve(self.viewModel,permanent);
	RAC(self.procedureViewController.datePickerButton,enabled) = [RACSignal
		combineLatest:@[RACObserve(self.viewModel, permanent)]
		reduce:^id(NSNumber *permanent){
			return @(!permanent.boolValue);
	}];
	[RACObserve(self.viewModel, permanent) subscribeNext:^(NSNumber *permanent) {
		@strongify(self)
		if (permanent.boolValue) {
			self.procedureViewController.expired.text = @"";
			[self.procedureViewController.expired setBackgroundColor:[UIColor colorWithWhite:0.902 alpha:1.000]];
		}
		else {
			[self.procedureViewController.expired setBackgroundColor:[UIColor whiteColor]];
		}
	}];
	self.procedureViewController.permanentButton.rac_command = self.viewModel.executePermanent;
	
	// Left Bar button
	UIBarButtonItem *item = [[UIBarButtonItem alloc]
		initWithImage:[UIImage imageNamed:@"left_arrow"] style:UIBarButtonItemStyleDone target:nil action:nil];
	item.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		[self dismissViewControllerAnimated:YES completion:nil];
		
		return [RACSignal empty];
	}];
	self.navigationItem.leftBarButtonItem = item;
	
	// Bank name
	RAC(self.procedureViewController.bankName,text) = RACObserve(self.viewModel, bankName);
	[[self.procedureViewController.bankNameButton rac_signalForControlEvents:UIControlEventTouchUpInside]
		subscribeNext:^(id x) {
			[self.view endEditing:YES];
			MSFSelectionViewModel *viewModel = [MSFSelectionViewModel selectKeyValuesViewModel:[MSFSelectKeyValues getSelectKeys:@"json_banks"]];
			MSFSelectionViewController *selectViewController = [[MSFSelectionViewController alloc] initWithViewModel:viewModel];
			selectViewController.title = @"选择银行";
			[self.navigationController pushViewController:selectViewController animated:YES];
			
			[selectViewController.selectedSignal subscribeNext:^(MSFSelectKeyValues *selectValue) {
				[selectViewController.navigationController popViewControllerAnimated:YES];
				self.viewModel.bankName = selectValue.text;
				self.viewModel.bankCode = selectValue.code;
			}];
		}];
	
	// Bank Address
	RAC(self.procedureViewController.bankAddress,text) = RACObserve(self.viewModel, bankAddress);
	self.procedureViewController.bankAddressButton.rac_command = self.viewModel.executeSelected;
	
	// Bank No button
	[[self.procedureViewController.bankNOButton rac_signalForControlEvents:UIControlEventTouchUpInside]
		subscribeNext:^(id x) {
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
				message:@"为保证账户资金安全,仅支持本人的储蓄卡(借记卡)收款"
				delegate:nil
				cancelButtonTitle:@"￼关闭"
				otherButtonTitles:nil];
			[alertView show];
		}];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"procedure"]) {
		self.procedureViewController = segue.destinationViewController;
	}
}

@end
