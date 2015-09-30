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
#import "MSFApplicationForms.h"
#import "MSFApplicationResponse.h"
#import "MSFSelectionViewModel.h"
#import "MSFSelectionViewController.h"
#import "NSString+Matches.h"
#import "MSFPersonalViewModel.h"
#import "MSFAddressViewModel.h"

#import "UITextField+RACKeyboardSupport.h"
#import "MSFCommandView.h"
#import "MSFHeaderView.h"
#import "MSFCommandView.h"
#import "MSFXBMCustomHeader.h"

@interface MSFPersonalViewController ()<MSFSegmentDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailTF;

@property (weak, nonatomic) IBOutlet UITextField *provinceTF;
@property (weak, nonatomic) IBOutlet UIButton *selectAreasBT;

@property (weak, nonatomic) IBOutlet UITextField *detailAddressTF;

@property (weak, nonatomic) IBOutlet UITextField *housingTF;
@property (weak, nonatomic) IBOutlet UIButton *housingBT;

@property (weak, nonatomic) IBOutlet UITextField *homeTelCodeTF;
@property (weak, nonatomic) IBOutlet UITextField *homeTelTF;

@property (weak, nonatomic) IBOutlet UITextField *marriageTF;
@property (weak, nonatomic) IBOutlet UIButton *marriageBT;

@property (weak, nonatomic) IBOutlet MSFSegment *selectQQorJDSegment;
@property (nonatomic, weak) IBOutlet UITextField *tencentUsername;
@property (nonatomic, weak) IBOutlet UITextField *taobaoUsername;
@property (nonatomic, weak) IBOutlet UITextField *jdUsername;

@property (weak, nonatomic) IBOutlet UIButton *nextPageBT;

@property (nonatomic, strong) MSFPersonalViewModel *viewModel;

@end

@implementation MSFPersonalViewController

#pragma mark - MSFReactiveView

- (void)bindViewModel:(id)viewModel {
	self.viewModel = viewModel;
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
	/*
	[[self.monthInComeTF rac_signalForControlEvents:UIControlEventEditingChanged]
	 subscribeNext:^(UITextField *textField) {
		 if (textField.text.length > 5) {
			 textField.text = [textField.text substringToIndex:5];
		 }
	 }];
	
	RACChannelTerminal *incomeChannel = RACChannelTo(self.viewModel.model, income);
	RAC(self.monthInComeTF, text) = incomeChannel;
	[self.monthInComeTF.rac_textSignal subscribe:incomeChannel];
	
	[[self.repayMonthTF rac_signalForControlEvents:UIControlEventEditingChanged]
	 subscribeNext:^(UITextField *textField) {
		 if (textField.text.length > 5) {
			 textField.text = [textField.text substringToIndex:5];
		 }
	 }];
	RACChannelTerminal *familyExpenseChannel = RACChannelTo(self.viewModel.model, familyExpense);
	RAC(self.repayMonthTF, text) = familyExpenseChannel;
	[self.repayMonthTF.rac_textSignal subscribe:familyExpenseChannel];
	
	[[self.familyOtherIncomeYF rac_signalForControlEvents:UIControlEventEditingChanged]
	 subscribeNext:^(UITextField *textField) {
		 if (textField.text.length > 6) {
			 if (textField.text.length > 6) {
				 textField.text = [textField.text substringToIndex:6];
			 }
		 }
	 }];
	RACChannelTerminal *otherIncomeChannel = RACChannelTo(self.viewModel.model, otherIncome);
	RAC(self.familyOtherIncomeYF, text) = otherIncomeChannel;
	[self.familyOtherIncomeYF.rac_textSignal subscribe:otherIncomeChannel];
	*/
	
	@weakify(self)
	
	[[self.emailTF rac_signalForControlEvents:UIControlEventEditingChanged]
	 subscribeNext:^(UITextField *textField) {
		 if (textField.text.length > 40) {
			 textField.text = [textField.text substringToIndex:40];
		 }
	 }];
	RACChannelTerminal *emailChannel = RACChannelTo(self.viewModel.model, email);
	RAC(self.emailTF, text) = emailChannel;
	[self.emailTF.rac_textSignal subscribe:emailChannel];
	
	RAC(self.provinceTF, text) = RACObserve(self.viewModel, address);
	self.selectAreasBT.rac_command = self.viewModel.executeAlterAddressCommand;

	[[self.detailAddressTF rac_signalForControlEvents:UIControlEventEditingChanged]
	 subscribeNext:^(UITextField *textField) {
		 if (textField.text.length > 80) {
			 textField.text = [textField.text substringToIndex:80];
		 }
	 }];
	RACChannelTerminal *detailAddrChannel = RACChannelTo(self.viewModel.model, abodeDetail);
	RAC(self.detailAddressTF, text) = detailAddrChannel;
	[self.detailAddressTF.rac_textSignal subscribe:detailAddrChannel];
	
	RAC(self.housingTF, text) = RACObserve(self.viewModel, houseTypeTitle);
	self.housingBT.rac_command = self.viewModel.executeHouseValuesCommand;
	
	
	[[self.homeTelCodeTF rac_signalForControlEvents:UIControlEventEditingChanged]
  subscribeNext:^(UITextField *textField) {
		@strongify(self)
		if (textField.text.length == 3) {
			NSArray *validArea = @[@"010", @"020", @"021" ,@"022" ,@"023" ,@"024" ,@"025" ,@"027" ,@"028", @"029"];
			if ([validArea containsObject:textField.text]) {
				[self.homeTelTF becomeFirstResponder];
			}
		} else if (textField.text.length == 4) {
			[self.homeTelTF becomeFirstResponder];
		}
	}];
	[[self.homeTelTF rac_signalForControlEvents:UIControlEventEditingChanged]
	 subscribeNext:^(UITextField *textField) {
		 if (textField.text.length > 8) {
			 textField.text = [textField.text substringToIndex:8];
		 }
	 }];
	RACSignal *homeTlelSignal = [RACSignal
	 combineLatest:@[self.homeTelCodeTF.rac_textSignal, self.homeTelTF.rac_textSignal]
	 reduce:^id(NSString *code, NSString *tel) {
		 return [NSString stringWithFormat:@"%@-%@", code, tel];
	}];
	RAC(self.viewModel.model, homeLine) = homeTlelSignal;
//	RACChannelTerminal *homeLineChannel = RACChannelTo(self.viewModel.model, homeLine);
//	RAC(self.homeTelTF, text) = homeLineChannel;
//	[self.homeTelTF.rac_textSignal subscribe:homeLineChannel];
	
	RAC(self.marriageTF, text) = RACObserve(self.viewModel, marriageTitle);
	self.marriageBT.rac_command = self.viewModel.executeMarryValuesCommand;
	/*
	[[self.repayMonthTF rac_signalForControlEvents:UIControlEventEditingChanged]
	 subscribeNext:^(UITextField *textField) {
		 if (textField.text.length > 5) {
			 textField.text = [textField.text substringToIndex:5];
		 }
	 }];
	RACChannelTerminal *familyExpenseChannel = RACChannelTo(self.viewModel.model, familyExpense);
	RAC(self.repayMonthTF, text) = familyExpenseChannel;
	[self.repayMonthTF.rac_textSignal subscribe:familyExpenseChannel];
	
	[[self.homeLineCodeTF rac_signalForControlEvents:UIControlEventEditingChanged]
  subscribeNext:^(UITextField *textField) {
		@strongify(self)
		if (textField.text.length == 3) {
			NSArray *validArea = @[@"010", @"020", @"021" ,@"022" ,@"023" ,@"024" ,@"025" ,@"027" ,@"028", @"029"];
			if ([validArea containsObject:textField.text]) {
				[self.homeTelTF becomeFirstResponder];
			}
		} else if (textField.text.length == 4) {
			[self.homeTelTF becomeFirstResponder];
		}
	}];
	[[self.homeTelTF rac_signalForControlEvents:UIControlEventEditingChanged]
  subscribeNext:^(UITextField *textField) {
		@strongify(self)
		if (textField.text.length == 0) {
			[self.homeLineCodeTF becomeFirstResponder];
		}
		
		if (textField.text.length>8) {
			//if (textField.text.length >4 ) {
			textField.text = [textField.text substringToIndex:8];
			//}
		}
	}];
	RACChannelTerminal *homecodeChannel = RACChannelTo(self.viewModel.model, homeCode);
	RAC(self.homeLineCodeTF, text) = homecodeChannel;
	[self.homeLineCodeTF.rac_textSignal subscribe:homecodeChannel];
	
	RACChannelTerminal *hometelephoneChannel = RACChannelTo(self.viewModel.model, homeLine);
	RAC(self.homeTelTF, text) = hometelephoneChannel;
	[self.homeTelTF.rac_textSignal subscribe:hometelephoneChannel];
	*/

	[[self.tencentUsername rac_signalForControlEvents:UIControlEventEditingChanged]
	 subscribeNext:^(UITextField *textField) {
		 if (textField.text.length > 15) {
			 textField.text = [textField.text substringToIndex:15];
		 }
	 }];
	RACChannelTerminal *tencentUsernameChannel = RACChannelTo(self.viewModel.model, qq);
	RAC(self.tencentUsername, text) = tencentUsernameChannel;
	[self.tencentUsername.rac_textSignal subscribe:tencentUsernameChannel];
	
	[[self.taobaoUsername rac_signalForControlEvents:UIControlEventEditingChanged]
	 subscribeNext:^(UITextField *textField) {
		 if (textField.text.length > 40) {
			 textField.text = [textField.text substringToIndex:40];
		 }
	 }];
	RACChannelTerminal *taobaoUsernameChannel = RACChannelTo(self.viewModel.model, taobao);
	RAC(self.taobaoUsername, text) = taobaoUsernameChannel;
	[self.taobaoUsername.rac_textSignal subscribe:taobaoUsernameChannel];

	[[self.jdUsername rac_signalForControlEvents:UIControlEventEditingChanged]
	 subscribeNext:^(UITextField *textField) {
		 if (textField.text.length > 40) {
			 textField.text = [textField.text substringToIndex:40];
		 }
	 }];
	RACChannelTerminal *jdUsernameChannel = RACChannelTo(self.viewModel.model, jdAccount);
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
		
		NSString *checkForm = [self.viewModel checkForm];
		if (checkForm) {
			[SVProgressHUD showErrorWithStatus:checkForm];
			return;
		}
		
		[SVProgressHUD showWithStatus:@"正在提交..." maskType:SVProgressHUDMaskTypeClear];
		[signal subscribeNext:^(id x) {
			[SVProgressHUD showSuccessWithStatus:@"提交成功"];
			[self.navigationController popViewControllerAnimated:YES];
		}];
	}];
	
	[self.viewModel.executeCommitCommand.errors subscribeNext:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];
	/*
	[self.tencentUsername.rac_keyboardReturnSignal subscribeNext:^(id x) {
		@strongify(self)
		[self.viewModel.executeCommitCommand execute:nil];
	}];
	[self.jdPasscode.rac_keyboardReturnSignal subscribeNext:^(id x) {
		@strongify(self)
		[self.viewModel.executeCommitCommand execute:nil];
	}];
	[self.taobaoPasscode.rac_keyboardReturnSignal subscribeNext:^(id x) {
		@strongify(self)
		[self.viewModel.executeCommitCommand execute:nil];
	}];*/
}

- (void)back {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"您确定放弃基本信息编辑？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
	[alert.rac_buttonClickedSignal subscribeNext:^(id x) {
		if ([x integerValue] == 1) {
			[self.navigationController popViewControllerAnimated:YES];
		}
	}];
	[alert show];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	NSLog(@"%ld", (long)self.selectQQorJDSegment.selectedSegmentIndex);
	if (section == 0 || section == self.selectQQorJDSegment.selectedSegmentIndex + 1) {
		return [super tableView:tableView numberOfRowsInSection:section];
	}
	if (section ==1 && self.selectQQorJDSegment.selectedSegmentIndex == -1) {
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

- (void)viewDidLayoutSubviews {
	if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
		[self.tableView setSeparatorInset:UIEdgeInsetsZero];
	}
	
	if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
		[self.tableView setLayoutMargins:UIEdgeInsetsZero];
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

- (BOOL)validaCode:(NSString *)code {
	NSMutableArray *codeArray = [[NSMutableArray alloc] init];
	[codeArray addObject:@"010"];
	for ( int i = 0; i < 10; i++) {
		if (i != 6) {
			[codeArray addObject:[NSString stringWithFormat:@"02%d", i]];
		}
	}
	
	
	
	return [codeArray containsObject:code] ? YES : NO;
}

@end
