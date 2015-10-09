//
//	MSFAppliesIncomeTableViewController.m
//	Cash
//
//	Created by xbm on 15/5/23.
//	Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFPersonalViewController.h"
#import <FMDB/FMDatabase.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "MSFAreas.h"

#import "MSFApplicationResponse.h"
#import "MSFSelectionViewModel.h"
#import "MSFSelectionViewController.h"
#import "NSString+Matches.h"

#import "MSFPersonalViewModel.h"
#import "MSFFormsViewModel.h"
#import "MSFApplicationForms.h"
//#import "MSFAddressViewModel.h"

#import "UITextField+RACKeyboardSupport.h"
#import "MSFCommandView.h"
#import "MSFHeaderView.h"
#import "MSFCommandView.h"
#import "MSFXBMCustomHeader.h"

#import "MSFSegment.h"

@interface MSFPersonalViewController ()
<MSFSegmentDelegate>

@property (weak, nonatomic) IBOutlet UITextField *marriageTF;
@property (weak, nonatomic) IBOutlet UIButton *marriageBT;

@property (weak, nonatomic) IBOutlet UITextField *housingTF;
@property (weak, nonatomic) IBOutlet UIButton *housingBT;

@property (weak, nonatomic) IBOutlet UITextField *emailTF;

@property (weak, nonatomic) IBOutlet UITextField *homeTelCodeTF;
@property (weak, nonatomic) IBOutlet UITextField *homeTelTF;

@property (weak, nonatomic) IBOutlet UITextField *provinceTF;
@property (weak, nonatomic) IBOutlet UIButton *selectAreasBT;
@property (weak, nonatomic) IBOutlet UITextField *detailAddressTF;

@property (weak, nonatomic) IBOutlet MSFSegment *selectQQorJDSegment;
@property (nonatomic, weak) IBOutlet UITextField *tencentUsername;
@property (nonatomic, weak) IBOutlet UITextField *taobaoUsername;
@property (nonatomic, weak) IBOutlet UITextField *jdUsername;

@property (weak, nonatomic) IBOutlet UIButton *nextPageBT;

@property (nonatomic, strong) MSFPersonalViewModel *viewModel;
@property (nonatomic, assign) NSInteger statusHash;

@end

@implementation MSFPersonalViewController

#pragma mark - MSFReactiveView

- (void)bindViewModel:(id)viewModel {
	self.viewModel = viewModel;
	_statusHash = self.viewModel.formsViewModel.model.hash;
}

#pragma mark - Lifecycle

- (void)dealloc {
	NSLog(@"MSFPersonalViewController `-dealloc`");
}

- (instancetype)init {
	return [UIStoryboard storyboardWithName:@"personal" bundle:nil].instantiateInitialViewController;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.navigationItem.title = @"基本信息";
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"left_arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];

	@weakify(self)
	//住房情况
	RAC(self.housingTF, text) = RACObserve(self.viewModel.formsViewModel.model, houseTypeTitle);
	self.housingBT.rac_command = self.viewModel.executeHouseValuesCommand;
	//婚姻状况
	RAC(self.marriageTF, text) = RACObserve(self.viewModel.formsViewModel.model, marriageTitle);
	self.marriageBT.rac_command = self.viewModel.executeMarryValuesCommand;
	//电子邮件
	[[self.emailTF rac_signalForControlEvents:UIControlEventEditingChanged]
	 subscribeNext:^(UITextField *textField) {
		 if (textField.text.length > 40) {
			 textField.text = [textField.text substringToIndex:40];
		 }
	 }];
	RACChannelTerminal *emailChannel = RACChannelTo(self.viewModel.formsViewModel.model, email);
	RAC(self.emailTF, text) = emailChannel;
	[self.emailTF.rac_textSignal subscribe:emailChannel];
	//住宅电话
	[[self.homeTelCodeTF rac_signalForControlEvents:UIControlEventEditingChanged]
  subscribeNext:^(UITextField *textField) {
		@strongify(self)
		[self checkTelCode:textField];
	}];
	[[self.homeTelTF rac_signalForControlEvents:UIControlEventEditingChanged]
	 subscribeNext:^(UITextField *textField) {
		 if (textField.text.length > 8) {
			 textField.text = [textField.text substringToIndex:8];
		 }
	 }];
	
	RACChannelTerminal *homeTelCodeChannel = RACChannelTo(self.viewModel.formsViewModel.model, homeCode);
	RAC(self.homeTelCodeTF, text) = homeTelCodeChannel;
	[self.homeTelCodeTF.rac_textSignal subscribe:homeTelCodeChannel];
	
	RACChannelTerminal *homeTelChannel = RACChannelTo(self.viewModel.formsViewModel.model, homeLine);
	RAC(self.homeTelTF, text) = homeTelChannel;
	[self.homeTelTF.rac_textSignal subscribe:homeTelChannel];
	
	//现居地址
	RAC(self.provinceTF, text) = RACObserve(self.viewModel, address);
	self.selectAreasBT.rac_command = self.viewModel.executeAlterAddressCommand;
	//详细地址
	[[self.detailAddressTF rac_signalForControlEvents:UIControlEventEditingChanged]
	 subscribeNext:^(UITextField *textField) {
		 if (textField.text.length > 80) {
			 textField.text = [textField.text substringToIndex:80];
		 }
	 }];
	RACChannelTerminal *detailAddrChannel = RACChannelTo(self.viewModel.formsViewModel.model, abodeDetail);
	RAC(self.detailAddressTF, text) = detailAddrChannel;
	[self.detailAddressTF.rac_textSignal subscribe:detailAddrChannel];

	//QQ
	[[self.tencentUsername rac_signalForControlEvents:UIControlEventEditingChanged]
	 subscribeNext:^(UITextField *textField) {
		 if (textField.text.length > 15) {
			 textField.text = [textField.text substringToIndex:15];
		 }
	 }];
	RACChannelTerminal *tencentUsernameChannel = RACChannelTo(self.viewModel.formsViewModel.model, qq);
	RAC(self.tencentUsername, text) = tencentUsernameChannel;
	[self.tencentUsername.rac_textSignal subscribe:tencentUsernameChannel];
	
	//TAOBAO
	[[self.taobaoUsername rac_signalForControlEvents:UIControlEventEditingChanged]
	 subscribeNext:^(UITextField *textField) {
		 if (textField.text.length > 40) {
			 textField.text = [textField.text substringToIndex:40];
		 }
	 }];
	RACChannelTerminal *taobaoUsernameChannel = RACChannelTo(self.viewModel.formsViewModel.model, taobao);
	RAC(self.taobaoUsername, text) = taobaoUsernameChannel;
	[self.taobaoUsername.rac_textSignal subscribe:taobaoUsernameChannel];

	//JD
	[[self.jdUsername rac_signalForControlEvents:UIControlEventEditingChanged]
	 subscribeNext:^(UITextField *textField) {
		 if (textField.text.length > 40) {
			 textField.text = [textField.text substringToIndex:40];
		 }
	 }];
	RACChannelTerminal *jdUsernameChannel = RACChannelTo(self.viewModel.formsViewModel.model, jdAccount);
	RAC(self.jdUsername, text) = jdUsernameChannel;
	[self.jdUsername.rac_textSignal subscribe:jdUsernameChannel];

	self.selectQQorJDSegment.delegate = self;
	[[self.selectQQorJDSegment rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(id x) {
		@strongify(self)
		[self.selectQQorJDSegment setLineColors];
		[self.tableView reloadData];
	}];
	
	self.nextPageBT.rac_command = self.viewModel.executeCommitCommand;
	[self.viewModel.executeCommitCommand.executionSignals subscribeNext:^(RACSignal *signal) {
		@strongify(self)
		[SVProgressHUD showWithStatus:@"正在提交..." maskType:SVProgressHUDMaskTypeClear];
		[signal subscribeNext:^(id x) {
			[SVProgressHUD showSuccessWithStatus:@"提交成功"];
			[self.navigationController popViewControllerAnimated:YES];
		}];
	}];
	
	[self.viewModel.executeCommitCommand.errors subscribeNext:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];
}

- (void)viewDidLayoutSubviews {
	if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
		[self.tableView setSeparatorInset:UIEdgeInsetsZero];
	}
	
	if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
		[self.tableView setLayoutMargins:UIEdgeInsetsZero];
	}
}

#pragma mark - Private Method

- (void)back {
	if (_statusHash == self.viewModel.formsViewModel.model.hash) {
		[self.navigationController popViewControllerAnimated:YES];
		return;
	}
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"您确定放弃基本信息编辑？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
	[alert.rac_buttonClickedSignal subscribeNext:^(id x) {
		if ([x integerValue] == 1) {
			[self.navigationController popViewControllerAnimated:YES];
		}
	}];
	[alert show];
}

- (void)checkTelCode:(UITextField *)textField {
	if (textField.text.length == 3) {
		NSArray *validArea = @[@"010", @"020", @"021" ,@"022" ,@"023" ,@"024" ,@"025" ,@"027" ,@"028", @"029"];
		if ([validArea containsObject:textField.text]) {
			[self.homeTelTF becomeFirstResponder];
		}
	} else if (textField.text.length == 4) {
		[self.homeTelTF becomeFirstResponder];
	}
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSLog(@"%ld", (long)self.selectQQorJDSegment.selectedSegmentIndex);
	if (section == 0 || section == self.selectQQorJDSegment.selectedSegmentIndex + 1) {
		return [super tableView:tableView numberOfRowsInSection:section];
	}
	if (section == 1 && self.selectQQorJDSegment.selectedSegmentIndex == -1) {
		return [super tableView:tableView numberOfRowsInSection:1];
	}
	return 0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
		[cell setSeparatorInset:UIEdgeInsetsZero];
	}
	
	if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
		[cell setLayoutMargins:UIEdgeInsetsZero];
	}
}

#pragma mark - MSFSegmenDelegate

- (void)setLineColor:(NSMutableArray *)array {
	for (UILabel *label in array) {
		if (label.tag == self.selectQQorJDSegment.selectedSegmentIndex) {
			label.hidden = NO;
		} else {
			label.hidden = YES;
		}
	}
}

@end
