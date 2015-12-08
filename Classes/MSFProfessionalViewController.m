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

#import "MSFFormsViewModel.h"
#import "MSFApplicationForms.h"
#import "MSFProfessionalViewModel.h"
#import "MSFSelectionViewModel.h"
#import "MSFSelectionViewController.h"
#import "MSFSelectKeyValues.h"
#import "MSFAreas.h"

#import "MSFCommandView.h"
#import "MSFXBMCustomHeader.h"
#import "NSDateFormatter+MSFFormattingAdditions.h"

typedef NS_ENUM(NSUInteger, MSFProfessionalViewSection) {
	MSFProfessionalViewSectionIncome = 1,
	MSFProfessionalViewSectionSchool = 2,
	MSFProfessionalViewSectionCompany = 3,
	MSFProfessionalViewSectionDepartment = 4,
	MSFProfessionalViewSectionContact = 5,
};

@interface MSFProfessionalViewController ()

// 社会身份
@property (nonatomic, weak) IBOutlet UITextField *education;//教育程度code
@property (nonatomic, weak) IBOutlet UITextField *socialStatus;//社会身份
@property (nonatomic, weak) IBOutlet UITextField *workingLength;//工作年限
@property (nonatomic, weak) IBOutlet UIButton *educationButton;
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
@property (nonatomic, weak) IBOutlet UITextField *unitAreaCode;//办公/个体电话区号
@property (nonatomic, weak) IBOutlet UITextField *unitTelephone;//办公/个体电话
@property (nonatomic, weak) IBOutlet UITextField *unitExtensionTelephone;//办公/个体电话分机号

//地址
@property (nonatomic, weak) IBOutlet UITextField *address;
@property (nonatomic, weak) IBOutlet UIButton *addressButton;
@property (nonatomic, weak) IBOutlet UITextField *workTown;//单位所在镇

@property (nonatomic, weak) IBOutlet UIButton *nextButton;

@property (nonatomic, strong) MSFProfessionalViewModel *viewModel;

@end

@implementation MSFProfessionalViewController

#pragma mark - MSFReactiveView

- (void)bindViewModel:(id)viewModel {
	_viewModel = viewModel;
}

#pragma mark - Lifecycle

- (void)dealloc {
	NSLog(@"MSFProfessionalViewController `-dealloc`");
}

- (instancetype)init {
	return [UIStoryboard storyboardWithName:@"professional" bundle:nil].instantiateInitialViewController;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.navigationItem.title = @"职业信息";
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"left_arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
	
	@weakify(self)
	//教育程度
	RAC(self.education, text) = RACObserve(self.viewModel, degreesTitle);
	self.educationButton.rac_command = self.viewModel.executeEducationCommand;
	
	//社会身份
	RAC(self.socialStatus, text) = RACObserve(self.viewModel, socialstatusTitle);
	self.socialStatusButton.rac_command = self.viewModel.executeSocialStatusCommand;
	[RACObserve(self.viewModel, socialstatus) subscribeNext:^(id x) {
		@strongify(self)
		[self.tableView reloadData];
	}];

	//学校名称
	[[self.universityName rac_signalForControlEvents:UIControlEventEditingChanged]
		subscribeNext:^(UITextField *textField) {
			if (textField.text.length > 80) {
				textField.text = [textField.text substringToIndex:80];
			}
		}];
	RACChannelTerminal *universityNameChannel = RACChannelTo(self.viewModel.forms, unitName);
	RAC(self.universityName, text) = universityNameChannel;
	[self.universityName.rac_textSignal subscribe:universityNameChannel];
	
	//入学时间
	RAC(self.enrollmentYear, text) = RACObserve(self.viewModel.forms, empStandFrom);
	[[self.enrollmentYearButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
		@strongify(self)
		[self.view endEditing:YES];
		[self.viewModel.enrollmentYearCommand execute:self.view];
	}];
	
	//学制
	[[self.programLength rac_signalForControlEvents:UIControlEventEditingChanged]
		subscribeNext:^(UITextField *textField) {
			if (textField.text.length > 1) {
				textField.text = [textField.text substringToIndex:1];
			}
		}];
	RACChannelTerminal *eductionalLengthChannel = RACChannelTo(self.viewModel.forms, programLength);
	RAC(self.programLength, text) = eductionalLengthChannel;
	[self.programLength.rac_textSignal subscribe:eductionalLengthChannel];
	
	//参加工作日期
	RAC(self.workingLength, text) = RACObserve(self.viewModel.forms, workStartDate);
	[[self.workingLengthButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
		@strongify(self)
		[self.view endEditing:YES];
		[self.viewModel.startedWorkDateCommand execute:self.view];
	}];
	
	//单位全称
	[[self.company rac_signalForControlEvents:UIControlEventEditingChanged]
		subscribeNext:^(UITextField *textField) {
			if (textField.text.length > 80) {
				textField.text = [textField.text substringToIndex:80];
			}
		}];
	RACChannelTerminal *companyChannel = RACChannelTo(self.viewModel.forms, unitName);
	RAC(self.company, text) = companyChannel;
	[self.company.rac_textSignal subscribe:companyChannel];
	
	//行业类别
	RAC(self.industry, text) = RACObserve(self.viewModel, industryTitle);
	self.industryButton.rac_command = self.viewModel.executeIndustryCommand;
	
	//单位性质
	RAC(self.companyType, text) = RACObserve(self.viewModel, natureTitle);
	self.companyTypeButton.rac_command = self.viewModel.executeNatureCommand;
	
	//单位地址
	RAC(self.address, text) = RACObserve(self.viewModel, address);
	self.addressButton.rac_command = self.viewModel.executeAddressCommand;
	
	RACChannelTerminal *workTownChannel = RACChannelTo(self.viewModel.forms, empAdd);
	RAC(self.workTown, text) = workTownChannel;
	[self.workTown.rac_textSignal subscribe:workTownChannel];
	
	//单位电话
	[[self.unitAreaCode rac_signalForControlEvents:UIControlEventEditingChanged]
		subscribeNext:^(UITextField *textField) {
			@strongify(self)
			if (textField.text.length == 3) {
				NSArray *validArea = @[@"010", @"020", @"021" ,@"022" ,@"023" ,@"024" ,@"025" ,@"027" ,@"028", @"029"];
				if ([validArea containsObject:textField.text]) {
					[self.unitTelephone becomeFirstResponder];
				}
			} else if (textField.text.length == 4) {
				[self.unitTelephone becomeFirstResponder];
			} else if (textField.text.length > 4) {
				textField.text = [textField.text substringToIndex:4];
			}
		}];
	RACChannelTerminal *unitAreaCodeChannel = RACChannelTo(self.viewModel.forms, unitAreaCode);
	RAC(self.unitAreaCode, text) = unitAreaCodeChannel;
	[self.unitAreaCode.rac_textSignal subscribe:unitAreaCodeChannel];
	
	[[self.unitTelephone rac_signalForControlEvents:UIControlEventEditingChanged]
		subscribeNext:^(UITextField *textField) {
			if (textField.text.length>8) {
				textField.text = [textField.text substringToIndex:8];
			}
		}];
	RACChannelTerminal *unitTelephoneChannel = RACChannelTo(self.viewModel.forms, unitTelephone);
	RAC(self.unitTelephone, text) = unitTelephoneChannel;
	[self.unitTelephone.rac_textSignal subscribe:unitTelephoneChannel];
	
	[[self.unitExtensionTelephone rac_signalForControlEvents:UIControlEventEditingChanged]
		subscribeNext:^(UITextField *textField) {
			if (textField.text.length > 5) {
				textField.text = [textField.text substringToIndex:5];
			}
		}];
	RACChannelTerminal *unitExtensionTelephoneChannel = RACChannelTo(self.viewModel.forms, unitExtensionTelephone);
	RAC(self.unitExtensionTelephone, text) = unitExtensionTelephoneChannel;
	[self.unitExtensionTelephone.rac_textSignal subscribe:unitExtensionTelephoneChannel];
	
	//部门
	[[self.department rac_signalForControlEvents:UIControlEventEditingChanged]
		subscribeNext:^(UITextField *textField) {
			if (textField.text.length > 20) {
				textField.text = [textField.text substringToIndex:20];
			}
		}];
	RACChannelTerminal *departmentChannel = RACChannelTo(self.viewModel.forms, department);
	RAC(self.department, text) = departmentChannel;
	[self.department.rac_textSignal subscribe:departmentChannel];
	
	//职位
	RAC(self.position, text) = RACObserve(self.viewModel, professionalTitle);
	self.positionButton.rac_command = self.viewModel.executePositionCommand;
	
	//入职日期
	RAC(self.currentJobDate, text) = RACObserve(self.viewModel.forms, empStandFrom);
	[[self.currentJobDateButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
		@strongify(self)
		[self.view endEditing:YES];
		[self.viewModel.startedDateCommand execute:self.view];
	}];
	
	//工作收入
	[[self.incomeTF rac_signalForControlEvents:UIControlEventEditingChanged]
		subscribeNext:^(UITextField *textField) {
			if (textField.text.length > 5) {
				textField.text = [textField.text substringToIndex:5];
			}
		}];
	RACChannelTerminal *incomeChannel = RACChannelTo(self.viewModel.forms, income);
	RAC(self.incomeTF, text) = incomeChannel;
	[self.incomeTF.rac_textSignal subscribe:incomeChannel];
	
	//其他收入
	[[self.extraIncomeTF rac_signalForControlEvents:UIControlEventEditingChanged]
		subscribeNext:^(UITextField *textField) {
			if (textField.text.length > 5) {
				textField.text = [textField.text substringToIndex:5];
			}
		}];
	RACChannelTerminal *extraIncomeChannel = RACChannelTo(self.viewModel.forms, otherIncome);
	RAC(self.extraIncomeTF, text) = extraIncomeChannel;
	[self.extraIncomeTF.rac_textSignal subscribe:extraIncomeChannel];
	
	//其他贷额
	[[self.loanTF rac_signalForControlEvents:UIControlEventEditingChanged]
		subscribeNext:^(UITextField *textField) {
			if (textField.text.length > 6) {
				textField.text = [textField.text substringToIndex:6];
			}
		}];
	RACChannelTerminal *loanChannel = RACChannelTo(self.viewModel.forms, familyExpense);
	RAC(self.loanTF, text) = loanChannel;
	[self.loanTF.rac_textSignal subscribe:loanChannel];
	
	//提交
	self.nextButton.rac_command = self.viewModel.executeCommitCommand;
	[self.viewModel.executeCommitCommand.executionSignals subscribeNext:^(RACSignal *signal) {
		@strongify(self)
		[SVProgressHUD showWithStatus:@"正在提交..." maskType:SVProgressHUDMaskTypeClear];
		[signal subscribeNext:^(id x) {
			[SVProgressHUD dismiss];
			[self.navigationController popViewControllerAnimated:YES];
		}];
	}];
	[self.viewModel.executeCommitCommand.errors subscribeNext:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];
}

- (void)back {
	if (!self.viewModel.edited) {
		[self.navigationController popViewControllerAnimated:YES];
		return;
	}
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"您确定放弃职业信息编辑？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
	[alert.rac_buttonClickedSignal subscribeNext:^(id x) {
		if ([x integerValue] == 1) {
			[self.navigationController popViewControllerAnimated:YES];
		}
	}];
	[alert show];
}

#pragma mark - UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (!self.viewModel.socialstatus && section == 0) {
		return [super tableView:tableView titleForHeaderInSection:section];
	}
	if ([self.viewModel.socialstatus.code isEqualToString:@"SI01"]) {
		if (section == 0 || section == MSFProfessionalViewSectionSchool || section == MSFProfessionalViewSectionIncome) {
			return [super tableView:tableView titleForHeaderInSection:section];
		}
	}
	if ([self.viewModel.socialstatus.code isEqualToString:@"SI02"] || [self.viewModel.socialstatus.code isEqualToString:@"SI04"]) {
		if (section == 0 || section == MSFProfessionalViewSectionCompany || section == MSFProfessionalViewSectionContact || section == MSFProfessionalViewSectionIncome || section == MSFProfessionalViewSectionDepartment) {
			return [super tableView:tableView titleForHeaderInSection:section];
		}
	}
	if (([self.viewModel.socialstatus.code isEqualToString:@"SI03"] || [self.viewModel.socialstatus.code isEqualToString:@"SI05"] || [self.viewModel.socialstatus.code isEqualToString:@"SI06"]) && (section == 0 || section == MSFProfessionalViewSectionIncome)) {
		return [super tableView:tableView titleForHeaderInSection:section];
	}
	return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (!self.viewModel.socialstatus && section == 0) {
		return 2;
	}
	if ([self.viewModel.socialstatus.code isEqualToString:@"SI01"]) {
		if (section == 0) {
			return 2;
		}
		if (section == MSFProfessionalViewSectionSchool || section == MSFProfessionalViewSectionIncome) {
			return [super tableView:tableView numberOfRowsInSection:section];
		}
	}
	if ([self.viewModel.socialstatus.code isEqualToString:@"SI02"] || [self.viewModel.socialstatus.code isEqualToString:@"SI04"]) {
		if (section == 0 || section == MSFProfessionalViewSectionCompany || section == MSFProfessionalViewSectionContact || section == MSFProfessionalViewSectionIncome || section == MSFProfessionalViewSectionDepartment) {
			return [super tableView:tableView numberOfRowsInSection:section];
		}
	}
	if (([self.viewModel.socialstatus.code isEqualToString:@"SI03"] || [self.viewModel.socialstatus.code isEqualToString:@"SI05"] || [self.viewModel.socialstatus.code isEqualToString:@"SI06"]) && (section == 0 || section == MSFProfessionalViewSectionIncome)) {
		if (section == 0) {
			return 2;
		} else if (section == MSFProfessionalViewSectionIncome) {
			return [super tableView:tableView numberOfRowsInSection:section];
		}
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	
	NSString *sectionTitle = [super tableView:tableView titleForHeaderInSection:section];
	if (sectionTitle == nil) {
		return  nil;
	}
	
	UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, self.view.frame.size.height)];
	sectionView.backgroundColor = [MSFCommandView getColorWithString:@"#f8f8f8"];
	
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 110, 22)];
	
	titleLabel.text = sectionTitle;
	titleLabel.font = [UIFont systemFontOfSize:14];
	titleLabel.textColor = [MSFCommandView getColorWithString:POINTCOLOR];
	titleLabel.backgroundColor = [UIColor clearColor];
	
	[sectionView addSubview:titleLabel];
	
	return sectionView;
}

@end
