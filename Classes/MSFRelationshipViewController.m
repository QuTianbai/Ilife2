//
//  MSFFamilyInfoTableViewController.m
//  Cash
//
//  Created by xbm on 15/5/23.
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFRelationshipViewController.h"
#import <libextobjc/extobjc.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFSelectKeyValues.h"
#import "MSFSelectionViewController.h"
#import "MSFSelectionViewModel.h"
#import "MSFRelationshipViewModel.h"
#import "MSFApplicationForms.h"
#import "MSFApplicationResponse.h"
#import "MSFProgressHUD.h"
#import "MSFCommandView.h"
#import "MSFRelationshipViewModel.h"

#define SEPARATORCOLOR @"5787c0"
#define CELLBACKGROUNDCOLOR @"dce6f2"
#define TYPEFACECOLOR @"5787c0"

typedef NS_ENUM(NSUInteger, MSFRelationshipViewSection) {
	MSFRelationshipViewSectionTitle,
	MSFRelationshipViewSectionMember1,
	MSFRelationshipViewSectionMember2,
	MSFRelationshipViewSectionContact1,
	MSFRelationshipViewSectionContact2,
};

@interface MSFRelationshipViewController ()

@property(nonatomic,strong) MSFRelationshipViewModel *viewModel;
/**
 *  婚姻状况，住房状况
 */
@property(weak, nonatomic) IBOutlet UITextField *marriageTF;
@property(weak, nonatomic) IBOutlet UIButton *marriageBT;
@property(weak, nonatomic) IBOutlet UITextField *houseTF;
@property(weak, nonatomic) IBOutlet UIButton *housesBT;

/**
 *  家庭联系人一
 */
@property(weak, nonatomic) IBOutlet UITextField *familyNameTF;
@property(weak, nonatomic) IBOutlet UIButton *relationBT;
@property(weak, nonatomic) IBOutlet UITextField *relationTF;
@property(weak, nonatomic) IBOutlet UITextField *telTF;
@property(weak, nonatomic) IBOutlet UISwitch *isSameCurrentSW;
@property(weak, nonatomic) IBOutlet UITextField *diffCurrentTF;
@property(weak, nonatomic) IBOutlet UIButton *addFamilyBT;

/**
 *  家庭联系人二
 */
@property(weak, nonatomic) IBOutlet UITextField *num2FamilyNameTF;
@property(weak, nonatomic) IBOutlet UIButton *num2RelationBT;
@property(weak, nonatomic) IBOutlet UITextField *num2RelationTF;
@property(weak, nonatomic) IBOutlet UITextField *num2TelTF;
@property(weak, nonatomic) IBOutlet UISwitch *num2IsSameCurrentSW;
@property(weak, nonatomic) IBOutlet UITextField *num2DiffCurrentTF;

/**
 *  其他联系人一
 */
@property(weak, nonatomic) IBOutlet UITextField *otherNameTF;
@property(weak, nonatomic) IBOutlet UIButton *otherRelationBT;
@property(weak, nonatomic) IBOutlet UITextField *otherRelationTF;
@property(weak, nonatomic) IBOutlet UITextField *otherTelTF;

/**
 *  其他联系人二
 */
@property(weak, nonatomic) IBOutlet UITextField *num2_otherNameTF;
@property(weak, nonatomic) IBOutlet UIButton *num2_otherRelationBT;
@property(weak, nonatomic) IBOutlet UITextField *num2_otherRelationTF;
@property(weak, nonatomic) IBOutlet UITextField *num2_otherTelTF;
@property(weak, nonatomic) IBOutlet UIButton *addOtherBT;

/**
 *  下一步
 */
@property(weak, nonatomic) IBOutlet UIButton *nextPageBT;

#define RELATION_VIEW_MODEL self.viewModel.relationViewModel

@end

@implementation MSFRelationshipViewController

#pragma mark - MSFReactiveView

- (void)bindViewModel:(id)viewModel {
  self.viewModel = viewModel;
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"家庭信息";
  self.edgesForExtendedLayout = UIRectEdgeNone;
	
	@weakify(self)
	[[self.addFamilyBT rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
		@strongify(self)
		self.viewModel.hasMember2 = !self.viewModel.hasMember2;
		[self.addFamilyBT setTitle:self.viewModel.hasMember2 ? @"-删除第二位家庭成员" : @"✚增加第二位家庭成员" forState:UIControlStateNormal];
		[self.tableView reloadData];
	}];
	[[self.addOtherBT rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
		@strongify(self)
		self.viewModel.hasContact2 = !self.viewModel.hasContact2;
		[self.addOtherBT setTitle:self.viewModel.hasContact2 ? @"-删除第二位联系人" : @"✚增加第二位联系人" forState:UIControlStateNormal];
		[self.tableView reloadData];
	}];
	
	RAC(self.marriageTF, text) = RACObserve(self.viewModel, marryValuesTitle);
	self.marriageBT.rac_command = self.viewModel.executeMarryValuesCommand;
	RAC(self.houseTF, text) = RACObserve(self.viewModel, houseValuesTitle);
	self.housesBT.rac_command = self.viewModel.executeHouseValuesCommand;
	
	// 第一位家庭成员
	RACChannelTerminal *memer1Channel = RACChannelTo(self.viewModel.model, memberName);
	RAC(self.familyNameTF, text) = memer1Channel;
  [self.familyNameTF.rac_textSignal subscribe:memer1Channel];
	RAC(self.relationTF, text) = RACObserve(self.viewModel, familyOneValuesTitle);
	self.relationBT.rac_command = self.viewModel.executeFamilyOneValuesCommand;
	RACChannelTerminal *member1PhoneChannel = RACChannelTo(self.viewModel.model, memberCellNum);
	RAC(self.telTF, text) = member1PhoneChannel;
  [self.telTF.rac_textSignal subscribe:member1PhoneChannel];
	RACChannelTerminal *member1AddressChannel = RACChannelTo(self.viewModel.model, memberAddress);
	RAC(self.diffCurrentTF, text) = member1AddressChannel;
  [self.diffCurrentTF.rac_textSignal subscribe:member1AddressChannel];
	self.diffCurrentTF.enabled = !self.isSameCurrentSW.on;
	[self.isSameCurrentSW.rac_newOnChannel subscribeNext:^(NSNumber *value) {
		@strongify(self)
		self.diffCurrentTF.enabled = !value.boolValue;
		if (value.boolValue) {
			self.diffCurrentTF.text = @"";
		}
	}];
	
	// 第二位家庭成员
	RACChannelTerminal *memer2Channel = RACChannelTo(self.viewModel.model, memberName2);
	RAC(self.num2FamilyNameTF, text) = memer2Channel;
  [self.num2FamilyNameTF.rac_textSignal subscribe:memer2Channel];
	RAC(self.num2RelationTF, text) = RACObserve(self.viewModel, familyTwoValuesTitle);
	self.num2RelationBT.rac_command = self.viewModel.executeFamilyTwoValuesCommand;
	RACChannelTerminal *member2PhoneChannel = RACChannelTo(self.viewModel.model, memberCellNum2);
	RAC(self.num2TelTF, text) = member2PhoneChannel;
  [self.num2TelTF.rac_textSignal subscribe:member2PhoneChannel];
	RACChannelTerminal *member2AddressChannel = RACChannelTo(self.viewModel.model, memberAddress2);
	RAC(self.num2DiffCurrentTF, text) = member2AddressChannel;
  [self.num2DiffCurrentTF.rac_textSignal subscribe:member2AddressChannel];
	self.num2DiffCurrentTF.enabled = !self.num2IsSameCurrentSW.on;
	[self.num2IsSameCurrentSW.rac_newOnChannel subscribeNext:^(NSNumber *value) {
		@strongify(self)
		self.num2DiffCurrentTF.enabled = !value.boolValue;
		if (value.boolValue) {
			self.num2DiffCurrentTF.text = @"";
		}
	}];
	
	// 其他联系人一
	RACChannelTerminal *name1Channel = RACChannelTo(self.viewModel.model, name1);
	RAC(self.otherNameTF, text) = name1Channel;
  [self.otherNameTF.rac_textSignal subscribe:name1Channel];
	
	RAC(self.otherRelationTF, text) = RACObserve(self.viewModel, otherOneValuesTitle);
	self.otherRelationBT.rac_command = self.viewModel.executeOtherOneValuesCommand;
	RACChannelTerminal *phone1Channel = RACChannelTo(self.viewModel.model, phone1);
	
	RAC(self.otherTelTF, text) = phone1Channel;
  [self.otherTelTF.rac_textSignal subscribe:phone1Channel];
	
	// 其他联系人二
	RACChannelTerminal *name2Channel = RACChannelTo(self.viewModel.model, name2);
	RAC(self.num2_otherNameTF, text) = name2Channel;
  [self.num2_otherNameTF.rac_textSignal subscribe:name2Channel];
	
	RAC(self.num2_otherRelationTF, text) = RACObserve(self.viewModel, otherTwoValuesTitle);
	self.num2_otherRelationBT.rac_command = self.viewModel.executeOtherTwoValuesCommand;
	
	RACChannelTerminal *phone2Channel = RACChannelTo(self.viewModel.model, phone2);
	RAC(self.num2_otherTelTF, text) = phone2Channel;
  [self.num2_otherTelTF.rac_textSignal subscribe:phone2Channel];
	
	self.nextPageBT.rac_command = self.viewModel.executeCommitCommand;
	[self.viewModel.executeCommitCommand.executionSignals subscribeNext:^(RACSignal *signal) {
		[MSFProgressHUD showStatusMessage:@"申请提交中..."];
		[signal subscribeNext:^(id x) {
			[MSFProgressHUD showSuccessMessage:@"申请提交成功"];
			@strongify(self)
			[self.navigationController popToRootViewControllerAnimated:YES];
		}];
	}];
	[self.viewModel.executeCommitCommand.errors subscribeNext:^(NSError *error) {
		[MSFProgressHUD showErrorMessage:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];
	
}

#pragma mark - UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  if (section == MSFRelationshipViewSectionMember2) {
		if (!self.viewModel.hasMember2) {
			return nil;
		}
  }
	if (section == MSFRelationshipViewSectionContact2) {
		if (!self.viewModel.hasContact2) {
			return nil;
		}
	}
	return [super tableView:tableView titleForHeaderInSection:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (section == MSFRelationshipViewSectionMember2) {
		if (!self.viewModel.hasMember2) {
			return 0;
		}
  }
  if (section == MSFRelationshipViewSectionContact2) {
		if (!self.viewModel.hasContact2) {
			return 0;
		}
  }
	return [super tableView:tableView numberOfRowsInSection:section];
}

@end