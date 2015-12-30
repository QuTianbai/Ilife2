//
//  MSFSocialCaskApplyTableViewController.m
//  Finance
//
//  Created by xbm on 15/11/20.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFSocialCaskApplyTableViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "MSFSocialInsuranceCashViewModel.h"
#import "MSFEdgeButton.h"
#import "MSFLoanAgreementViewModel.h"
#import "MSFLoanAgreementController.h"
#import "MSFSocialInsuranceModel.h"
#import "MSFApplicationForms.h"

@interface MSFSocialCaskApplyTableViewController ()

@property (nonatomic, strong) MSFSocialInsuranceCashViewModel *viewModel;

@property (weak, nonatomic) IBOutlet UITextField *cashPuposeTF;
@property (weak, nonatomic) IBOutlet UIButton *cashPurposeBT;

@property (weak, nonatomic) IBOutlet UIButton *insuranceBT;
@property (weak, nonatomic) IBOutlet UISwitch *insuranceSwitch;

@property (weak, nonatomic) IBOutlet UILabel *liveAreaTF;
@property (weak, nonatomic) IBOutlet UIButton *liveAreaBT;

@property (weak, nonatomic) IBOutlet UITextField *liveAddressTF;

@property (weak, nonatomic) IBOutlet UITextField *companyNameTF;

@property (weak, nonatomic) IBOutlet UITextField *companyAreaTF;
@property (weak, nonatomic) IBOutlet UIButton *companyAreaBT;

@property (weak, nonatomic) IBOutlet UITextField *companyAddressTF;

@property (weak, nonatomic) IBOutlet UITextField *relationTF;
@property (weak, nonatomic) IBOutlet UIButton *relationBT;

@property (weak, nonatomic) IBOutlet UITextField *nameTF;

@property (weak, nonatomic) IBOutlet UITextField *mobileTF;

@property (weak, nonatomic) IBOutlet UITextField *basePayTF;
@property (weak, nonatomic) IBOutlet UIButton *basePayBT;

@property (weak, nonatomic) IBOutlet MSFEdgeButton *submitBT;

@end

@implementation MSFSocialCaskApplyTableViewController

- (instancetype)initWithViewModel:(MSFSocialInsuranceCashViewModel *)viewModel {
	self = [UIStoryboard storyboardWithName:@"SocialCashApply" bundle:nil].instantiateInitialViewController;
	if (!self) {
		return nil;
	}
	_viewModel = viewModel;
	
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	RAC(self, cashPuposeTF.text) = RACObserve(self, viewModel.purpose.text);
	
	RACChannelTerminal *joinChannel = RACChannelTo(self, viewModel.joinInsurance);
	[joinChannel subscribe:self.insuranceSwitch.rac_newOnChannel];
	[self.insuranceSwitch.rac_newOnChannel subscribe:joinChannel];
	self.insuranceBT.rac_command = self.viewModel.executeInsuranceCommand;
	
	RAC(self, liveAreaTF.text) = RACObserve(self, viewModel.liveArea);
	self.liveAreaBT.rac_command = self.viewModel.executeLiveAddressCommand;
	
	RACChannelTerminal *liveAddrChannel = RACChannelTo(self, viewModel.liveAddress);
	RAC(self, liveAddressTF.text) = liveAddrChannel;
	[self.liveAddressTF.rac_textSignal subscribe:liveAddrChannel];
	
	RACChannelTerminal *compNameChannel = RACChannelTo(self, viewModel.companyName);
	RAC(self, companyNameTF.text) = compNameChannel;
	[self.companyNameTF.rac_textSignal subscribe:compNameChannel];
	
	RAC(self, companyAreaTF.text) = RACObserve(self, viewModel.companyArea);
	self.companyAreaBT.rac_command = self.viewModel.executeCompAddressCommand;
	
	RACChannelTerminal *compAddrChannel = RACChannelTo(self, viewModel.companyAddress);
	RAC(self, companyAddressTF.text) = compAddrChannel;
	[self.companyAddressTF.rac_textSignal subscribe:compAddrChannel];
	
	RAC(self, relationTF.text) = RACObserve(self, viewModel.relation.text);
	self.relationBT.rac_command = self.viewModel.executeRelationCommand;
	
	RACChannelTerminal *nameChannel = RACChannelTo(self, viewModel.name);
	RAC(self, nameTF.text) = nameChannel;
	[self.nameTF.rac_textSignal subscribe:nameChannel];
	
	RACChannelTerminal *mobileChannel = RACChannelTo(self, viewModel.mobile);
	RAC(self, mobileTF.text) = mobileChannel;
	[self.mobileTF.rac_textSignal subscribe:mobileChannel];
	
	RAC(self, basePayTF.text) = RACObserve(self, viewModel.basicPayment.text);
	self.basePayBT.rac_command = self.viewModel.executeBasicPaymentCommand;
	
	@weakify(self)
	
	self.submitBT.rac_command = self.viewModel.executeSubmitCommand;
	[self.viewModel.executeSubmitCommand.executionSignals subscribeNext:^(RACSignal *signal) {
		@strongify(self)
		[SVProgressHUD showWithStatus:@"正在保存..." maskType:SVProgressHUDMaskTypeClear];
		[signal subscribeNext:^(id x) {
			[SVProgressHUD dismiss];
			MSFLoanAgreementViewModel *viewModel = [[MSFLoanAgreementViewModel alloc] initWithApplicationViewModel:self.viewModel];
			MSFLoanAgreementController *viewController = [[MSFLoanAgreementController alloc] initWithViewModel:viewModel];
			[self.navigationController pushViewController:viewController animated:YES];
		}];
	}];
	[self.viewModel.executeSubmitCommand.errors subscribeNext:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];
	
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
		[cell setSeparatorInset:UIEdgeInsetsZero];
	}
	if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
		[cell setLayoutMargins:UIEdgeInsetsZero];
	}
}

- (void)viewDidLayoutSubviews {
	if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
		[self.tableView setSeparatorInset:UIEdgeInsetsZero];
	}
	
	if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
		[self.tableView setLayoutMargins:UIEdgeInsetsZero];
	}
}

@end
