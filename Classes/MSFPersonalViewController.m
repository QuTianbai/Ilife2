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
#import <libextobjc/extobjc.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "MSFAreas.h"
#import "MSFApplicationForms.h"
#import "MSFApplicationResponse.h"
#import "MSFSelectionViewModel.h"
#import "MSFSelectionViewController.h"
#import "NSString+Matches.h"
#import "MSFPersonalViewModel.h"
#import "MSFAddressViewModel.h"
#import "MSFProfessionalViewModel.h"
#import "MSFProfessionalViewController.h"
#import "UITextField+RACKeyboardSupport.h"
#import "MSFCommandView.h"
#import "MSFHeaderView.h"
#import "MSFCommandView.h"
#import "MSFXBMCustomHeader.h"

@interface MSFPersonalViewController ()<MSFSegmentDelegate>

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

- (void)viewDidLoad {
	[super viewDidLoad];
  
  // Left Bar button
  UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  backBtn.frame = CGRectMake(0, 0, 100, 44);
  [backBtn setTitle:@"申请贷款" forState:UIControlStateNormal];
  [backBtn setTitleColor:[MSFCommandView getColorWithString:POINTCOLOR] forState:UIControlStateNormal];
  backBtn.titleLabel.font = [UIFont systemFontOfSize:16];
  [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 15)];
  [backBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
  [backBtn setImage:[UIImage imageNamed:@"left_arrow"] forState:UIControlStateNormal];
  UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
  @weakify(self)
  backBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
    @strongify(self)
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"退出" message:@"您确定放弃贷款申请?" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
		[alert.rac_buttonClickedSignal subscribeNext:^(id x) {
			if ([x integerValue] == 1) [self.navigationController popToRootViewControllerAnimated:YES];
		}];
		[alert show];
    return [RACSignal empty];
  }];
  self.navigationItem.leftBarButtonItem = item;
  
	self.title = @"基本信息";
	self.tableView.tableHeaderView = [MSFHeaderView headerViewWithIndex:0];
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
	
  [[self.homeLineCodeTF rac_signalForControlEvents:UIControlEventEditingChanged]
  subscribeNext:^(UITextField *textField) {
		@strongify(self)
		if (textField.text.length == 3) {
			if ([self validaCode:textField.text]) {
				[self.homeTelTF becomeFirstResponder];
			}
		} else if (textField.text.length == 4 ) {
			//textField.text = [textField.text substringToIndex:4];
			[textField endEditing:YES];
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
	
	RACChannelTerminal *emailChannel = RACChannelTo(self.viewModel.model, email);
	RAC(self.emailTF, text) = emailChannel;
	[self.emailTF.rac_textSignal subscribe:emailChannel];
	
	[[self.townTF rac_signalForControlEvents:UIControlEventEditingChanged] subscribeNext:^(UITextField *textField) {
		if (textField.text.length > 10) {
			textField.text = [textField.text substringToIndex:10];
		}
	}];
	RACChannelTerminal *townChannel = RACChannelTo(self.viewModel.model, currentTown);
	RAC(self.townTF, text) = townChannel;
	[self.townTF.rac_textSignal subscribe:townChannel];
	
	[[self.currentStreetTF rac_signalForControlEvents:UIControlEventEditingChanged] subscribeNext:^(UITextField *textField) {
		if (textField.text.length > 10) {
			textField.text = [textField.text substringToIndex:10];
		}
	}];
	RACChannelTerminal *streetChannel = RACChannelTo(self.viewModel.model, currentStreet);
	RAC(self.currentStreetTF, text) = streetChannel;
	[self.currentStreetTF.rac_textSignal subscribe:streetChannel];

	[[self.currentCommunityTF rac_signalForControlEvents:UIControlEventEditingChanged] subscribeNext:^(UITextField *textField) {
		if (textField.text.length > 10) {
			textField.text = [textField.text substringToIndex:10];
		}
	}];
	RACChannelTerminal *communityChannel = RACChannelTo(self.viewModel.model, currentCommunity);
	RAC(self.currentCommunityTF, text) = communityChannel;
	[self.currentCommunityTF.rac_textSignal subscribe:communityChannel];

	[[self.currentApartmentTF rac_signalForControlEvents:UIControlEventEditingChanged] subscribeNext:^(UITextField *textField) {
		if (textField.text.length > 10) {
			textField.text = [textField.text substringToIndex:10];
		}
	}];
	RACChannelTerminal *apartmentChannel = RACChannelTo(self.viewModel.model, currentApartment);
	RAC(self.currentApartmentTF, text) = apartmentChannel;
	[self.currentApartmentTF.rac_textSignal subscribe:apartmentChannel];
	
	RACChannelTerminal *tencentUsernameChannel = RACChannelTo(self.viewModel.model, qq);
	RAC(self.tencentUsername, text) = tencentUsernameChannel;
	[self.tencentUsername.rac_textSignal subscribe:tencentUsernameChannel];
	
	RACChannelTerminal *taobaoUsernameChannel = RACChannelTo(self.viewModel.model, taobao);
	RAC(self.taobaoUsername, text) = taobaoUsernameChannel;
	[self.taobaoUsername.rac_textSignal subscribe:taobaoUsernameChannel];
	
	RACChannelTerminal *taobaoPasscodeChannel = RACChannelTo(self.viewModel.model, taobaoPassword);
	RAC(self.taobaoPasscode, text) = taobaoPasscodeChannel;
	[self.taobaoPasscode.rac_textSignal subscribe:taobaoPasscodeChannel];
	
	RACChannelTerminal *jdPasscodeChannel = RACChannelTo(self.viewModel.model, jdAccountPwd);
	RAC(self.jdPasscode, text) = jdPasscodeChannel;
	[self.jdPasscode.rac_textSignal subscribe:jdPasscodeChannel];
	
	RACChannelTerminal *jdUsernameChannel = RACChannelTo(self.viewModel.model, jdAccount);
	RAC(self.jdUsername, text) = jdUsernameChannel;
	[self.jdUsername.rac_textSignal subscribe:jdUsernameChannel];
	
	
	RAC(self.provinceTF, text) = RACObserve(self.viewModel, address);
	self.selectAreasBT.rac_command = self.viewModel.executeAlterAddressCommand;
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
			[SVProgressHUD dismiss];
			UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"professional" bundle:nil];
			UIViewController <MSFReactiveView> *vc = storyboard.instantiateInitialViewController;
			MSFProfessionalViewModel *viewModel = [[MSFProfessionalViewModel alloc] initWithFormsViewModel:self.viewModel.formsViewModel];
			[vc bindViewModel:viewModel];
			[self.navigationController pushViewController:vc animated:YES];
		}];
	}];
	[self.viewModel.executeCommitCommand.errors subscribeNext:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];
	
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
	}];
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
