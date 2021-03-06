//
//	MSFAppliesIncomeTableViewController.m
//	Cash
//
//	Created by xbm on 15/5/23.
//	Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFPersonalViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "UITextField+Limit.h"
#import "MSFSelectionViewController.h"

#import "MSFCommandView.h"

#import "MSFSelectionViewModel.h"
#import "MSFPersonalViewModel.h"

#import "MSFAddress.h"

#import "NSString+Matches.h"

#import "MSFProfessionalViewModel.h"
#import "MSFProfessionalViewController.h"
#import "MSFHeaderView.h"
#import "UITextField+Limit.h"

@interface MSFPersonalViewController ()

@property (weak, nonatomic) IBOutlet UITextField *housingTF;
@property (weak, nonatomic) IBOutlet UIButton *housingBT;

@property (weak, nonatomic) IBOutlet UITextField *emailTF;

@property (weak, nonatomic) IBOutlet UITextField *homeTelTF;

@property (weak, nonatomic) IBOutlet UITextField *provinceTF;
@property (weak, nonatomic) IBOutlet UIButton *selectAreasBT;
@property (weak, nonatomic) IBOutlet UITextField *detailAddressTF;

@property (weak, nonatomic) IBOutlet UIButton *nextPageBT;

@property (nonatomic, strong) MSFPersonalViewModel *viewModel;

@end

@implementation MSFPersonalViewController

#pragma mark - MSFReactiveView

- (instancetype)initWithViewModel:(id)viewModel {
	self = [UIStoryboard storyboardWithName:@"personal" bundle:nil].instantiateInitialViewController;
	if (!self) return nil;
	_viewModel = viewModel;
	return self;
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"基本信息";
	@weakify(self)
	RAC(self.housingTF, text) = RACObserve(self.viewModel, house);
	self.housingBT.rac_command = self.viewModel.executeHouseValuesCommand;
	
	//电子邮件
	RACChannelTerminal *emailChannel = RACChannelTo(self.viewModel, email);
	RAC(self.emailTF, text) = emailChannel;
	[self.emailTF.rac_textSignal subscribe:emailChannel];
    self.emailTF.keyboardType = UIKeyboardTypeASCIICapable;
    [self.emailTF limitWitRex:@"[A-Z0-9a-z\\._%+-@]{0,}"];
	//住宅电话
    [self.homeTelTF limitWitLength:12];
    [self.homeTelTF limitWitRex:@"[0-9]{0,12}"];
    [self.homeTelTF dylimitWithRex:^BOOL(NSString *str) {
        @strongify(self);
        if (str.length >= 3) {
            str = [str substringToIndex:3];
            if ([str isEqual:@"010"] || [str isEqual:@"021"] ||[str isEqual:@"022"] || [str isEqual:@"023"]) {
                [self.homeTelTF limitWitLength:11];
            } else {
                [self.homeTelTF limitWitLength:12];
            }
        }
        return YES;
    }];
	RACChannelTerminal *homeTelChannel = RACChannelTo(self.viewModel, phone);
	RAC(self.homeTelTF, text) = homeTelChannel;
	[self.homeTelTF.rac_textSignal subscribe:homeTelChannel];
	
	//现居地址
	RAC(self.provinceTF, text) = RACObserve(self.viewModel, address);
	self.selectAreasBT.rac_command = self.viewModel.executeAlterAddressCommand;
	
	//详细地址
	RACChannelTerminal *detailAddrChannel = RACChannelTo(self.viewModel, detailAddress);
	RAC(self.detailAddressTF, text) = detailAddrChannel;
    [self.detailAddressTF limitWitLength:50];
	[self.detailAddressTF.rac_textSignal subscribe:detailAddrChannel];
	
	self.nextPageBT.rac_command = self.viewModel.executeCommitCommand;
	[self.viewModel.executeCommitCommand.executionSignals subscribeNext:^(RACSignal *signal) {
		@strongify(self)
		[SVProgressHUD showWithStatus:@"正在提交..." maskType:SVProgressHUDMaskTypeClear];
		[signal subscribeNext:^(id x) {
			[SVProgressHUD dismiss];
			if (self.viewModel.viewModel) {
				MSFProfessionalViewModel *viewModel = [[MSFProfessionalViewModel alloc] initWithViewModel:self.viewModel.viewModel services:self.viewModel.services];
				[self.viewModel.services pushViewModel:viewModel];
			} else {
				[self.navigationController popViewControllerAnimated:YES];
			}
		}];
	}];
	
	if (self.viewModel.viewModel) {
		self.tableView.tableHeaderView = [MSFHeaderView headerViewWithIndex:0];
		[self.nextPageBT setTitle:@"下一步" forState:UIControlStateNormal];
	} else {
		[self.nextPageBT setTitle:@"提交" forState:UIControlStateNormal];
	}
	
	[self.viewModel.executeCommitCommand.errors subscribeNext:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];
    //对textfiled进行限
    
}

- (void)viewDidLayoutSubviews {
	if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
		[self.tableView setSeparatorInset:UIEdgeInsetsZero];
	}
	
	if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
		[self.tableView setLayoutMargins:UIEdgeInsetsZero];
	}
}

#pragma mark - UITableViewDataSource

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
		[cell setSeparatorInset:UIEdgeInsetsZero];
	}
	
	if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
		[cell setLayoutMargins:UIEdgeInsetsZero];
	}
}

@end
