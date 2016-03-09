//
//	MSFPersonInfoTableViewController.m
//	Cash
//
//	Created by xbm on 15/5/23.
//	Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFProfessionalViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <SVProgressHUD/SVProgressHUD.h>

#import "MSFProfessionalViewModel.h"
#import "MSFSelectionViewModel.h"
#import "MSFSelectionViewController.h"
#import "MSFSelectKeyValues.h"
#import "MSFAddress.h"

#import "MSFCommandView.h"
#import "MSFXBMCustomHeader.h"
#import "NSDateFormatter+MSFFormattingAdditions.h"
#import "MSFContact.h"
#import "MSFContactViewModel.h"
#import "MSFInventoryViewModel.h"
#import "MSFInventoryViewController.h"
#import "MSFHeaderView.h"

typedef NS_ENUM(NSUInteger, MSFProfessionalViewSection) {
	MSFProfessionalViewSectionIncome = 1,
	MSFProfessionalViewSectionSchool = 2,
	MSFProfessionalViewSectionCompany = 3,
	MSFProfessionalViewSectionDepartment = 4,
	MSFProfessionalViewSectionContact = 5,
};

@interface MSFProfessionalViewController ()

// 社会身份
@property (nonatomic, weak) IBOutlet UITextField *socialStatus;//社会身份
@property (nonatomic, weak) IBOutlet UITextField *workingLength;//工作年限
@property (nonatomic, weak) IBOutlet UIButton *socialStatusButton;
@property (nonatomic, weak) IBOutlet UIButton *workingLengthButton;

// 学校信息
@property (nonatomic, weak) IBOutlet UITextField *universityName;//学校名称
@property (nonatomic, weak) IBOutlet UITextField *enrollmentYear;//入学年份
@property (nonatomic, weak) IBOutlet UIButton *enrollmentYearButton;//入学年份
@property (nonatomic, weak) IBOutlet UITextField *programLength;//学制

//收入信息
@property (weak, nonatomic) IBOutlet UITextField *incomeTF;//工作月收入
@property (weak, nonatomic) IBOutlet UITextField *extraIncomeTF;//其他收入
@property (weak, nonatomic) IBOutlet UITextField *loanTF;//其他贷款每月偿还额

// 单位信息
@property (nonatomic, weak) IBOutlet UITextField *company;//单位/个体名称
@property (nonatomic, weak) IBOutlet UITextField *companyType;//单位性质code
@property (nonatomic, weak) IBOutlet UITextField *industry;//行业类别code
@property (nonatomic, weak) IBOutlet UIButton *companyTypeButton;//单位性质code
@property (nonatomic, weak) IBOutlet UIButton *industryButton;//行业类别code

// 职位信息
@property (nonatomic, weak) IBOutlet UITextField *department;//任职部门
@property (nonatomic, weak) IBOutlet UITextField *position;//职位 title
@property (nonatomic, weak) IBOutlet UITextField *currentJobDate;//现工作开始时间
@property (nonatomic, weak) IBOutlet UIButton *positionButton;//职位 title
@property (nonatomic, weak) IBOutlet UIButton *currentJobDateButton;//现工作开始时间

// 单位联系方式
@property (nonatomic, weak) IBOutlet UITextField *unitTelephone;//办公/个体电话
@property (nonatomic, weak) IBOutlet UITextField *unitExtensionTelephone;//办公/个体电话分机号

//地址
@property (nonatomic, weak) IBOutlet UITextField *address;
@property (nonatomic, weak) IBOutlet UIButton *addressButton;
@property (nonatomic, weak) IBOutlet UITextField *detailAddressTextField;//单位所在镇

@property (nonatomic, weak) IBOutlet UIButton *nextButton;

@property (nonatomic, weak) IBOutlet UIButton *marriageButton;
@property (nonatomic, weak) IBOutlet UITextField *marriageTextField;

@property (nonatomic, strong) MSFProfessionalViewModel *viewModel;

@end

@implementation MSFProfessionalViewController

- (instancetype)initWithViewModel:(id)viewModel {
	self = [UIStoryboard storyboardWithName:@"professional" bundle:nil].instantiateInitialViewController;
	if (!self) return nil;
	_viewModel = viewModel;
	
	return self;
}

#pragma mark - MSFReactiveView

- (void)bindViewModel:(id)viewModel {
	_viewModel = viewModel;
}

#pragma mark - Lifecycle

- (void)dealloc {
	NSLog(@"MSFProfessionalViewController `-dealloc`");
}

- (void)viewDidLoad {
	[super viewDidLoad];
	@weakify(self)
	self.title = @"其它信息";
	self.socialStatusButton.rac_command = self.viewModel.executeSocialStatusCommand;
	RAC(self, socialStatus.text) = RACObserve(self.viewModel, identifier);
	
	self.marriageButton.rac_command = self.viewModel.executeMarriageCommand;
	RAC(self, marriageTextField.text) = RACObserve(self.viewModel, marriage);
	
	RACChannelTerminal *channel = RACChannelTo(self.viewModel, normalIncome);
	RAC(self.incomeTF, text) = channel;
	[self.incomeTF.rac_textSignal subscribe:channel];
	
	channel = RACChannelTo(self.viewModel, surplusIncome);
	RAC(self.extraIncomeTF, text) = channel;
	[self.extraIncomeTF.rac_textSignal subscribe:channel];
	
	channel = RACChannelTo(self.viewModel, loan);
	RAC(self.loanTF, text) = channel;
	[self.loanTF.rac_textSignal subscribe:channel];
	
	channel = RACChannelTo(self.viewModel, schoolName);
	RAC(self.universityName, text) = channel;
	[self.universityName.rac_textSignal subscribe:channel];
	
	channel = RACChannelTo(self.viewModel, schoolLength);
	RAC(self.programLength, text) = channel;
	[self.programLength.rac_textSignal subscribe:channel];
	
	self.enrollmentYearButton.rac_command = self.viewModel.executeSchoolDateCommand;
	RAC(self, enrollmentYear.text) = RACObserve(self.viewModel, schoolDate);
	
	self.industryButton.rac_command = self.viewModel.executeIndustryCommand;
	RAC(self.industry, text) = RACObserve(self.viewModel, jobCategory);
	
	self.companyTypeButton.rac_command = self.viewModel.executeNatureCommand;
	RAC(self, companyType.text) = RACObserve(self.viewModel, jobNature);
	
	self.currentJobDateButton.rac_command = self.viewModel.executeJobPositionDateCommand;
	RAC(self, currentJobDate.text) = RACObserve(self.viewModel, jobPositionDate);
	
	self.workingLengthButton.rac_command = self.viewModel.executeJobDateCommand;
	RAC(self, workingLength.text) = RACObserve(self.viewModel, jobDate);
	
	self.positionButton.rac_command = self.viewModel.executePositionCommand;
	RAC(self, position.text) = RACObserve(self.viewModel, jobPosition);
	
	channel = RACChannelTo(self.viewModel, jobName);
	RAC(self.company, text) = channel;
	[self.company.rac_textSignal subscribe:channel];
	
	channel = RACChannelTo(self.viewModel, jobPhone);
	RAC(self.unitTelephone, text) = channel;
	[self.unitTelephone.rac_textSignal subscribe:channel];
	
	channel = RACChannelTo(self.viewModel, jobExtPhone);
	RAC(self.unitExtensionTelephone, text) = channel;
	[self.unitExtensionTelephone.rac_textSignal subscribe:channel];
	
	channel = RACChannelTo(self.viewModel, jobDetailAddress);
	RAC(self.detailAddressTextField, text) = channel;
	[self.detailAddressTextField.rac_textSignal subscribe:channel];
	RAC(self, address.text) = RACObserve(self.viewModel, jobAddress);
	self.addressButton.rac_command = self.viewModel.executeAddressCommand;
	
	channel = RACChannelTo(self.viewModel, jobPositionDepartment);
	RAC(self.department, text) = channel;
	[self.department.rac_textSignal subscribe:channel];
	
	self.nextButton.rac_command = self.viewModel.executeCommitCommand;
	[self.viewModel.executeCommitCommand.errors subscribeNext:^(NSError *x) {
		[SVProgressHUD showErrorWithStatus:x.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];
	[self.viewModel.executeCommitCommand.executionSignals subscribeNext:^(id x) {
		@strongify(self)
		[SVProgressHUD showWithStatus:@"正在提交..."];
		[x subscribeNext:^(id x) {
			[SVProgressHUD dismiss];
			if (self.viewModel.viewModel) {
				MSFInventoryViewModel *viewModel = [[MSFInventoryViewModel alloc] initWitViewModel:self.viewModel.viewModel services:self.viewModel.services];
				[self.viewModel.services pushViewModel:viewModel];
			} else {
				[self.navigationController popViewControllerAnimated:YES];
			}
		}];
	}];
	if (self.viewModel.viewModel) {
		self.tableView.tableHeaderView = [MSFHeaderView headerViewWithIndex:1];
		[self.nextButton setTitle:@"下一步" forState:UIControlStateNormal];
	} else {
		[self.nextButton setTitle:@"提交" forState:UIControlStateNormal];
	}
	
	[RACObserve(self.viewModel, code) subscribeNext:^(id x) {
		@strongify(self);
		[self.tableView reloadData];
	}];
	[RACObserve(self.viewModel, viewModels) subscribeNext:^(id x) {
		@strongify(self);
		[self.tableView reloadData];
	}];
	[self.viewModel.executeRelationshipCommand.executionSignals subscribeNext:^(RACSignal *x) {
		@strongify(self);
		[x subscribeNext:^(id x) {
			[self.tableView reloadData];
		}];
	}];
	[self.viewModel.executeContactCommand.executionSignals subscribeNext:^(RACSignal *x) {
		@strongify(self);
		[x subscribeNext:^(id x) {
			[self.tableView reloadData];
		}];
	}];
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

- (void)viewDidLayoutSubviews {
	if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
		[self.tableView setSeparatorInset:UIEdgeInsetsZero];
	}
	
	if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
		[self.tableView setLayoutMargins:UIEdgeInsetsZero];
	}
}

#pragma mark - 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 2) { // 教育信息相关内容
		if (![self.viewModel.code isEqualToString:@"SI01"]) return 0;
	} else if (section == 3) { // 职业相关内容
		if (!([self.viewModel.code isEqualToString:@"SI02"] || [self.viewModel.code isEqualToString:@"SI04"])) return 0;
	} else if (section == 7) { // 最大联系人数量为3
		return [super tableView:tableView numberOfRowsInSection:section] - 1;
	}
	if (section > 4) { // 新增联系人按钮cell变化
		if (self.viewModel.numberOfSections - 1 != section) return [super tableView:tableView numberOfRowsInSection:section] - 1;
	}
	return [super tableView:tableView numberOfRowsInSection:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 18)];
	view.backgroundColor = UIColor.groupTableViewBackgroundColor;
	UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), .5)];
	line.backgroundColor = [UIColor colorWithWhite:0.800 alpha:1.000];
	[view addSubview:line];
	line = [[UIView alloc] initWithFrame:CGRectMake(0, 17.5, CGRectGetWidth([UIScreen mainScreen].bounds), .5)];
	line.backgroundColor = [UIColor colorWithWhite:0.800 alpha:1.000];
	[view addSubview:line];
	if (section == 2) {
		if (![self.viewModel.code isEqualToString:@"SI01"]) return nil;
	} else if (section == 3) {
		if (!([self.viewModel.code isEqualToString:@"SI02"] || [self.viewModel.code isEqualToString:@"SI04"])) return nil;
	}
	return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	if (section == 2) {
		if (![self.viewModel.code isEqualToString:@"SI01"]) return 0;
	} else if (section == 3) {
		if (!([self.viewModel.code isEqualToString:@"SI02"] || [self.viewModel.code isEqualToString:@"SI04"])) return 0;
	} else if (section == self.viewModel.numberOfSections - 1) {
		return 0;
	}
	return 18;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return self.viewModel.numberOfSections;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section > 4 && indexPath.row == 5) {
		if (self.viewModel.viewModels.count > indexPath.section - 5) {
			MSFContactViewModel *viewModel = self.viewModel.viewModels[indexPath.section - 5];
			return viewModel.on ? 0 : 44;
		}
	}
	return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
	if (indexPath.section < 5) return cell;
	NSInteger index  = indexPath.section - 5;
	MSFContactViewModel *viewModel = self.viewModel.viewModels[index];
	UIButton *button;
	UITextField *textField;
	
	button = [cell viewWithTag:MSFProfessionalContactCellAdditionButton + index];
	button.rac_command = self.viewModel.executeAddContactCommand;
	
	button = [cell viewWithTag:MSFProfessionalContactCellRemoveButton + index];
	button.rac_command = self.viewModel.executeRemoveContactCommand;
	
	button = [cell viewWithTag:MSFProfessionalContactCellRelationshipButton + index];
	button.rac_command = self.viewModel.executeRelationshipCommand;
	textField = [cell viewWithTag:MSFProfessionalContactCellRelationshipTextFeild + index];
	textField.text = viewModel.relationship;
	
	button = [cell viewWithTag:MSFProfessionalContactCellPhoneButton + index];
	button.rac_command = self.viewModel.executeContactCommand;
	textField = [cell viewWithTag:MSFProfessionalContactCellNameTextFeild + index];
	textField.text = viewModel.name;
	[[textField.rac_textSignal takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
		viewModel.name = x;
	}];
	
	textField = [cell viewWithTag:MSFProfessionalContactCellPhoneTextFeild + index];
	textField.text = viewModel.phone;
	[[textField.rac_textSignal takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
		viewModel.phone = x;
	}];
	
	textField = [cell viewWithTag:MSFProfessionalContactCellAddressTextFeild + index];
	textField.text = viewModel.address;
	[[textField.rac_textSignal takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
		viewModel.address = x;
	}];
	
	UISwitch *sw = [cell viewWithTag:MSFProfessionalContactCellAddressSwitch + index];
	sw.on = viewModel.on;
	@weakify(self)
	[sw.rac_newOnChannel subscribeNext:^(id x) {
		@strongify(self)
		viewModel.on = [x boolValue];
		if ([x boolValue]) viewModel.address = @"";
		[self.tableView reloadData];
	}];
	
	return cell;
}

@end
