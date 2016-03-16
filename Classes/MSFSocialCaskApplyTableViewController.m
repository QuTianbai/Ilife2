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
#import <ZSWTappableLabel/ZSWTappableLabel.h>
#import <ZSWTaggedString/ZSWTaggedString.h>
#import <KGModal/KGModal.h>
#import "MSFSocialInsuranceCashViewModel.h"
#import "MSFEdgeButton.h"
#import "MSFLoanAgreementViewModel.h"
#import "MSFLoanAgreementController.h"
#import "UIColor+Utils.h"
#import "MSFCommitedViewController.h"

@interface MSFSocialCaskApplyTableViewController ()<ZSWTappableLabelTapDelegate>

@property (nonatomic, strong) MSFSocialInsuranceCashViewModel *viewModel;

@property (weak, nonatomic) IBOutlet UITextField *cashPuposeTF;
@property (weak, nonatomic) IBOutlet UIButton *cashPurposeBT;

@property (weak, nonatomic) IBOutlet UIButton *insuranceBT;
@property (weak, nonatomic) IBOutlet UISwitch *insuranceSwitch;

@property (weak, nonatomic) IBOutlet UITextField *liveAreaTF;
@property (weak, nonatomic) IBOutlet UIButton *liveAreaBT;
@property (weak, nonatomic) IBOutlet UITextField *liveAddressTF;

@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *mobileTF;

@property (weak, nonatomic) IBOutlet UITextField *basePayTF;
@property (weak, nonatomic) IBOutlet UIButton *basePayBT;

@property (weak, nonatomic) IBOutlet MSFEdgeButton *submitBT;

@property (nonatomic, weak) IBOutlet UIButton *showProtocalButton;
@property (nonatomic, weak) IBOutlet UIButton *readProtocalButton;
@property (nonatomic, weak) IBOutlet UIImageView *readProtocalView;

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
	
	RAC(self, cashPuposeTF.text) = RACObserve(self, viewModel.purposeTitle);
	self.cashPurposeBT.rac_command = self.viewModel.executePurposeCommand;
	
	RACChannelTerminal *joinChannel = RACChannelTo(self, viewModel.joinInsurance);
	[joinChannel subscribe:self.insuranceSwitch.rac_newOnChannel];
	[self.insuranceSwitch.rac_newOnChannel subscribe:joinChannel];
	@weakify(self)
	[[self.insuranceBT rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
		@strongify(self)
		UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 390)];
		contentView.backgroundColor = [UIColor whiteColor];
		
		UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 10, 80, 20)];
		titleLabel.textColor = [UIColor themeColorNew];
		titleLabel.font = [UIFont boldSystemFontOfSize:18];
		titleLabel.text = @"寿险条约";
		[contentView addSubview:titleLabel];
		
		UIView *line = [[UIView alloc] initWithFrame:CGRectMake(8, 40, contentView.frame.size.width-16, 1)];
		line.backgroundColor = [UIColor themeColorNew];
		[contentView addSubview:line];
		
		NSString *path = [[NSBundle mainBundle] pathForResource:@"life-insurance" ofType:nil];
		NSString *string = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
		ZSWTappableLabel *label = [[ZSWTappableLabel alloc] initWithFrame:CGRectMake(8, 40, contentView.frame.size.width-8, contentView.frame.size.height-40)];
		label.numberOfLines = 0;
		label.font = [UIFont systemFontOfSize:15];
		label.tapDelegate = self;
		
		ZSWTaggedStringOptions *options = [ZSWTaggedStringOptions defaultOptions];
		[options setAttributes:@{
			ZSWTappableLabelTappableRegionAttributeName: @YES,
			ZSWTappableLabelHighlightedBackgroundAttributeName: [UIColor lightGrayColor],
			ZSWTappableLabelHighlightedForegroundAttributeName: [UIColor whiteColor],
			NSForegroundColorAttributeName: [UIColor themeColorNew],
			NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),
			@"URL": [NSURL URLWithString:@"http://www.msxf.com/msfinance/page/about/insuranceInfo.htm"],
		} forTagName:@"link"];
		label.attributedText = [[ZSWTaggedString stringWithString:string] attributedStringWithOptions:options];
		[contentView addSubview:label];
		[[KGModal sharedInstance] setCloseButtonLocation:KGModalCloseButtonLocationRight];
		[[KGModal sharedInstance] setModalBackgroundColor:[UIColor whiteColor]];
		[[KGModal sharedInstance] showWithContentView:contentView andAnimated:YES];
	}];
	[[self rac_signalForSelector:@selector(tappableLabel:tappedAtIndex:withAttributes:) fromProtocol:@protocol(ZSWTappableLabelTapDelegate)] subscribeNext:^(id x) {
		@strongify(self)
		[[KGModal sharedInstance] hideWithCompletionBlock:^{
			[self.viewModel.executeInsuranceCommand execute:nil];
		}];
	}];
	
	RAC(self, liveAreaTF.text) = RACObserve(self, viewModel.address);
	self.liveAreaBT.rac_command = self.viewModel.executeLiveAddressCommand;
	
	RACChannelTerminal *liveAddrChannel = RACChannelTo(self, viewModel.detailAddress);
	RAC(self, liveAddressTF.text) = liveAddrChannel;
	[self.liveAddressTF.rac_textSignal subscribe:liveAddrChannel];
	
	RACChannelTerminal *nameChannel = RACChannelTo(self, viewModel.contactName);
	RAC(self, nameTF.text) = nameChannel;
	[self.nameTF.rac_textSignal subscribe:nameChannel];

	RACChannelTerminal *phoneChannel = RACChannelTo(self, viewModel.contactPhone);
	[[self.mobileTF rac_signalForControlEvents:UIControlEventEditingChanged]
	subscribeNext:^(UITextField *textField) {
		if (textField.text.length > 11) {
			textField.text = [textField.text substringToIndex:11];
		}
	}];
	RAC(self, mobileTF.text) = phoneChannel;
	[self.mobileTF.rac_textSignal subscribe:phoneChannel];
	
	RAC(self, basePayTF.text) = RACObserve(self, viewModel.radixTitle);
	self.basePayBT.rac_command = self.viewModel.executeBasicPaymentCommand;
	
	self.submitBT.rac_command = self.viewModel.executeSubmitCommand;
	[self.viewModel.executeSubmitCommand.executionSignals subscribeNext:^(RACSignal *signal) {
		@strongify(self)
		if (!self.readProtocalView.highlighted) {
			[SVProgressHUD showInfoWithStatus:@"请阅读贷款协议"];
			return;
		}
		[SVProgressHUD showWithStatus:@"正在保存..." maskType:SVProgressHUDMaskTypeClear];
		[signal subscribeNext:^(id x) {
			[SVProgressHUD dismiss];
			[self.navigationController setViewControllers:@[
				self.navigationController.viewControllers.firstObject,
				[[MSFCommitedViewController alloc] init]
			] animated:YES];
		}];
	}];
	[self.viewModel.executeSubmitCommand.errors subscribeNext:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];
	
	[[self.showProtocalButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
		@strongify(self)
		MSFLoanAgreementViewModel *viewModel = [[MSFLoanAgreementViewModel alloc] initWithApplicationViewModel:self.viewModel];
		MSFLoanAgreementController *viewController = [[MSFLoanAgreementController alloc] initWithViewModel:viewModel];
		[self.navigationController pushViewController:viewController animated:YES];
	}];
	[[self.readProtocalButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
		@strongify(self)
		self.readProtocalView.highlighted = !self.readProtocalView.highlighted;
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		return 0.1f;
	}
	return 30.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		return nil;
	}
	UIView *reuse = [[UIView alloc] init];
	reuse.backgroundColor = UIColor.darkBackgroundColor;
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 30)];
	label.font = [UIFont boldSystemFontOfSize:15];
	label.textColor = UIColor.themeColorNew;
	switch (section) {
		case 1: label.text = @"基本信息"; break;
		case 2: label.text = @"联系人信息"; break;
		case 3: label.text = @"参保信息"; break;
		default: break;
	}
	[reuse addSubview:label];
	return reuse;
}

#pragma mark - ZSWTappableLabelTapDelegate

- (void)tappableLabel:(ZSWTappableLabel *)tappableLabel tappedAtIndex:(NSInteger)idx withAttributes:(NSDictionary *)attributes {
}

@end
