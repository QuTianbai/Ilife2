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

@interface MSFPersonalViewController ()<MSFSegmentDelegate>

@property(nonatomic,strong) MSFPersonalViewModel *viewModel;

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
	self.title = @"基本信息";
	self.edgesForExtendedLayout = UIRectEdgeNone;
  
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
       if (textField.text.length > 5) {
         textField.text = [textField.text substringToIndex:5];
       }
     }
   }];
	RACChannelTerminal *familyExpenseChannel = RACChannelTo(self.viewModel.model, familyExpense);
	RAC(self.repayMonthTF,text) = familyExpenseChannel;
	[self.repayMonthTF.rac_textSignal subscribe:familyExpenseChannel];

  [[self.familyOtherIncomeYF rac_signalForControlEvents:UIControlEventEditingChanged]
   subscribeNext:^(UITextField *textField) {
     if (textField.text.length > 5) {
       if (textField.text.length > 5) {
         textField.text = [textField.text substringToIndex:5];
       }
     }
   }];
	RACChannelTerminal *otherIncomeChannel = RACChannelTo(self.viewModel.model, otherIncome);
	RAC(self.familyOtherIncomeYF,text) = otherIncomeChannel;
	[self.familyOtherIncomeYF.rac_textSignal subscribe:otherIncomeChannel];
	
  [[self.homeLineCodeTF rac_signalForControlEvents:UIControlEventEditingChanged]
  subscribeNext:^(UITextField *textField) {
    NSLog(@"%@",textField.text);
    if (textField.text.length >4 ) {
      textField.text = [textField.text substringToIndex:4];
    }
  }];
  [[self.homeTelTF rac_signalForControlEvents:UIControlEventEditingChanged]
  subscribeNext:^(UITextField *textField) {
    if (textField.text.length>8) {
      if (textField.text.length >4 ) {
        textField.text = [textField.text substringToIndex:8];
      }
    }
  }];
	RACChannelTerminal *homecodeChannel = RACChannelTo(self.viewModel.model, homeCode);
	RAC(self.homeLineCodeTF,text) = homecodeChannel;
	[self.homeLineCodeTF.rac_textSignal subscribe:homecodeChannel];
	
	RACChannelTerminal *hometelephoneChannel = RACChannelTo(self.viewModel.model, homeLine);
	RAC(self.homeTelTF,text) = hometelephoneChannel;
	[self.homeTelTF.rac_textSignal subscribe:hometelephoneChannel];
	
	RACChannelTerminal *emailChannel = RACChannelTo(self.viewModel.model, email);
	RAC(self.emailTF,text) = emailChannel;
	[self.emailTF.rac_textSignal subscribe:emailChannel];
	
	RACChannelTerminal *townChannel = RACChannelTo(self.viewModel.model, currentTown);
	RAC(self.townTF,text) = townChannel;
	[self.townTF.rac_textSignal subscribe:townChannel];
	
	RACChannelTerminal *streetChannel = RACChannelTo(self.viewModel.model, currentStreet);
	RAC(self.currentStreetTF,text) = streetChannel;
	[self.currentStreetTF.rac_textSignal subscribe:streetChannel];
	
	RACChannelTerminal *communityChannel = RACChannelTo(self.viewModel.model, currentCommunity);
	RAC(self.currentCommunityTF,text) = communityChannel;
	[self.currentCommunityTF.rac_textSignal subscribe:communityChannel];
	
	RACChannelTerminal *apartmentChannel = RACChannelTo(self.viewModel.model, currentApartment);
	RAC(self.currentApartmentTF,text) = apartmentChannel;
	[self.currentApartmentTF.rac_textSignal subscribe:apartmentChannel];
	
	RACChannelTerminal *tencentUsernameChannel = RACChannelTo(self.viewModel.model, qq);
	RAC(self.tencentUsername,text) = tencentUsernameChannel;
	[self.tencentUsername.rac_textSignal subscribe:tencentUsernameChannel];
	
	RACChannelTerminal *taobaoUsernameChannel = RACChannelTo(self.viewModel.model, taobao);
	RAC(self.taobaoUsername,text) = taobaoUsernameChannel;
	[self.taobaoUsername.rac_textSignal subscribe:taobaoUsernameChannel];
	
	RACChannelTerminal *taobaoPasscodeChannel = RACChannelTo(self.viewModel.model, taobaoPassword);
	RAC(self.taobaoPasscode,text) = taobaoPasscodeChannel;
	[self.taobaoPasscode.rac_textSignal subscribe:taobaoPasscodeChannel];
	
	RACChannelTerminal *jdPasscodeChannel = RACChannelTo(self.viewModel.model, jdAccountPwd);
	RAC(self.jdPasscode,text) = jdPasscodeChannel;
	[self.jdPasscode.rac_textSignal subscribe:jdPasscodeChannel];
	
	RACChannelTerminal *jdUsernameChannel = RACChannelTo(self.viewModel.model, jdAccount);
	RAC(self.jdUsername,text) = jdUsernameChannel;
	[self.jdUsername.rac_textSignal subscribe:jdUsernameChannel];
	
	@weakify(self)
	RAC(self.provinceTF,text) = RACObserve(self.viewModel, address);
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
		[SVProgressHUD showWithStatus:@"正在提交..." maskType:SVProgressHUDMaskTypeClear];
		[signal subscribeNext:^(id x) {
			[SVProgressHUD dismiss];
			UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"professional" bundle:nil];
			UIViewController <MSFReactiveView> *vc = storyboard.instantiateInitialViewController;
			MSFProfessionalViewModel *viewModel = [[MSFProfessionalViewModel alloc] initWithFormsViewModel:self.viewModel.formsViewModel contentViewController:vc];
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
  
  NSLog(@"%ld",self.selectQQorJDSegment.selectedSegmentIndex);
	if (section == 0 || section == self.selectQQorJDSegment.selectedSegmentIndex + 1) {
		return [super tableView:tableView numberOfRowsInSection:section];
	}
  if (section ==1 && self.selectQQorJDSegment.selectedSegmentIndex == -1) {
    return [super tableView:tableView numberOfRowsInSection:1];
  }
	return 0;
}

#pragma mark - MSFSegmenDelegate

- (void)setLineColor:(NSMutableArray *)array {
  for (UILabel *label in array) {
    if (label.tag == self.selectQQorJDSegment.selectedSegmentIndex) {
      label.hidden = NO;
    }
    else {
      label.hidden = YES;
    }
  }
}

@end
