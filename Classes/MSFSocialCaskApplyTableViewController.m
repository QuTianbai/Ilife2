//
//  MSFSocialCaskApplyTableViewController.m
//  Finance
//
//  Created by xbm on 15/11/20.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFSocialCaskApplyTableViewController.h"
#import "MSFCommandView.h"
#import "MSFXBMCustomHeader.h"
#import "MSFSocialInsuranceCashViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFEdgeButton.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "MSFLoanAgreementViewModel.h"
#import "MSFLoanAgreementController.h"
#import "MSFSocialInsuranceModel.h"

@interface MSFSocialCaskApplyTableViewController ()

@property (nonatomic, strong) MSFSocialInsuranceCashViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UITextField *cashPuposeTF;
@property (weak, nonatomic) IBOutlet UITextField *olderStatusTF;
@property (weak, nonatomic) IBOutlet UITextField *olderBaseTF;
@property (weak, nonatomic) IBOutlet UITextField *olderDateTF;
@property (weak, nonatomic) IBOutlet UITextField *olderMonthsTF;
@property (weak, nonatomic) IBOutlet UITextField *medicalStatusTF;
@property (weak, nonatomic) IBOutlet UITextField *medicalBaseTF;
@property (weak, nonatomic) IBOutlet UITextField *medicalDate;
@property (weak, nonatomic) IBOutlet UITextField *medicalMonths;
@property (weak, nonatomic) IBOutlet UITextField *injuryStatusTF;
@property (weak, nonatomic) IBOutlet UITextField *unEmployTF;
@property (weak, nonatomic) IBOutlet UITextField *bearTF;
@property (weak, nonatomic) IBOutlet MSFEdgeButton *submitBT;
@property (weak, nonatomic) IBOutlet UILabel *monthsOrYeasLB;
@property (weak, nonatomic) IBOutlet UILabel *oldMonthsOrYeasLB;
@property (weak, nonatomic) IBOutlet UILabel *oldTypeLB;
@property (weak, nonatomic) IBOutlet UILabel *medicalTypeLB;

@property (nonatomic, copy) NSString *professional;

@end

@implementation MSFSocialCaskApplyTableViewController

- (instancetype)initWithViewModel:(MSFSocialInsuranceCashViewModel *)viewModel {
	self = [UIStoryboard storyboardWithName:@"SocialCashApply" bundle:nil].instantiateInitialViewController;
	if (!self) {
		return nil;
	}
	
	_viewModel = viewModel;
	self.professional = @"";
	
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	RAC(self, cashPuposeTF.text) = [RACObserve(self, viewModel.cashpurpose) ignore:nil];
	
	if ([self.professional isEqualToString:@""]) {//居民
		self.monthsOrYeasLB.text = @"缴费年数";
		self.oldTypeLB.text = @"缴费档次";
		self.medicalTypeLB.text = @"缴费档次";
		self.monthsOrYeasLB.text = @"缴费年数";
		RAC(self, olderStatusTF.text) = [RACObserve(self, viewModel.residentOlderInsuranceStatusTitle) ignore:nil];
		RAC(self, olderBaseTF.text) = [RACObserve(self, viewModel.residentOlderInsuranceMoneyTitle) ignore:nil];
		RAC(self, medicalStatusTF.text) = [RACObserve(self, viewModel.residentMedicalInsuranceStatusTitle) ignore:nil];
		RAC(self, medicalBaseTF.text) = [RACObserve(self, viewModel.residentMedicalInsuranceMoneyTitle) ignore:nil];
		RAC(self.olderDateTF, text) = RACObserve(self.viewModel, residentOlderInsuranceDate);
		RAC(self.medicalDate, text) = RACObserve(self.viewModel, residentMedicalInsuranceDate);
		
		//self.olderMonthsTF.text = @"2";
		
		RACChannelTerminal *residentOlderInsuranceYearsChannel = RACChannelTo(self, viewModel.residentOlderInsuranceYears);
		RAC(self.olderMonthsTF, text) = residentOlderInsuranceYearsChannel;
		[self.olderMonthsTF.rac_textSignal subscribe:residentOlderInsuranceYearsChannel];
		
		RACChannelTerminal *residentMedicalInsuranceYears = RACChannelTo(self, viewModel.residentMedicalInsuranceYears);
		RAC(self.medicalMonths, text) = residentMedicalInsuranceYears;
		[self.medicalMonths.rac_textSignal subscribe:residentMedicalInsuranceYears];
		
		[[self.medicalMonths rac_signalForControlEvents:UIControlEventEditingDidEnd]
		subscribeNext:^(UITextField *x) {
			if (x.text.integerValue < 1) {
				x.text = @"2";
			}
		}];
		
		[[self.olderMonthsTF rac_signalForControlEvents:UIControlEventEditingDidEnd]
		 subscribeNext:^(UITextField *x) {
			 if (x.text.integerValue < 1) {
				 x.text = @"2";
			 }
		 }];
		
	} else {//职工
		RAC(self, olderStatusTF.text) = [RACObserve(self, viewModel.employeeOldInsuranceStatusTitle) ignore:nil];
		RAC(self, olderBaseTF.text) = [RACObserve(self, viewModel.employeeOlderModeyTitle) ignore:nil];
		RAC(self, medicalStatusTF.text) = [RACObserve(self, viewModel.employMedicalStatusTitle) ignore:nil];
		RAC(self, medicalBaseTF.text) = [RACObserve(self, viewModel.employeeMedicalMoneyTitle) ignore:nil];
		RAC(self, injuryStatusTF.text) = [RACObserve(self, viewModel.emplyoeeJuryStatusTitle) ignore:nil];
		RAC(self, unEmployTF.text) = [RACObserve(self, viewModel.employeeOutJobStatusTitle) ignore:nil];
		RAC(self, bearTF.text) = [RACObserve(self, viewModel.employeeBearStatusTitle) ignore:nil];
		
		RAC(self.olderDateTF, text) = RACObserve(self.viewModel, employeeOlderDate);
		RAC(self.medicalDate, text) = RACObserve(self.viewModel, employeeMedicalDate);
		
		RACChannelTerminal *employeeOlderMonths = RACChannelTo(self, viewModel.employeeOlderMonths);
		RAC(self.olderMonthsTF, text) = employeeOlderMonths;
		[self.olderMonthsTF.rac_textSignal subscribe:employeeOlderMonths];
		
		RACChannelTerminal *employeeMedicalMonths = RACChannelTo(self, viewModel.employeeMedicalMonths);
		RAC(self.medicalMonths, text) = employeeMedicalMonths;
		[self.medicalMonths.rac_textSignal subscribe:employeeMedicalMonths];
		
		[[self.medicalMonths rac_signalForControlEvents:UIControlEventEditingDidEnd]
		 subscribeNext:^(UITextField *x) {
			 if (x.text.integerValue < 1) {
				 x.text = @"12";
			 }
		 }];
		
		[[self.olderMonthsTF rac_signalForControlEvents:UIControlEventEditingDidEnd]
		 subscribeNext:^(UITextField *x) {
			 if (x.text.integerValue < 1) {
				 x.text = @"12";
			 }
		 }];
		
	}
	
	self.submitBT.rac_command = self.viewModel.executeSaveCommand;
	@weakify(self)
	[self.viewModel.executeSaveCommand.executionSignals subscribeNext:^(RACSignal *signal) {
		@strongify(self)
		[SVProgressHUD showWithStatus:@"正在保存..." maskType:SVProgressHUDMaskTypeClear];
		[signal subscribeNext:^(id x) {
			[SVProgressHUD dismiss];
			MSFLoanAgreementViewModel *viewModel = [[MSFLoanAgreementViewModel alloc] initWithApplicationViewModel:self.viewModel];
			MSFLoanAgreementController *viewController = [[MSFLoanAgreementController alloc] initWithViewModel:viewModel];
			[self.navigationController pushViewController:viewController animated:YES];
			//[self.navigationController popViewControllerAnimated:YES];
		}];
	}];
	[self.viewModel.executeSaveCommand.errors subscribeNext:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	
	NSString *sectionTitle = [super tableView:tableView titleForHeaderInSection:section];
	if (sectionTitle == nil) {
		return  nil;
	}
	
	UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, self.view.frame.size.height)];
	
	UIView *firstRow = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 44)];
	
	CGFloat labelHeight = 5;
	if (section == 0) {
		[sectionView addSubview:firstRow];
		labelHeight = 44;
	}
	sectionView.backgroundColor = [MSFCommandView getColorWithString:@"#f8f8f8"];
	
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, labelHeight, 200, 22)];
	if ([self.professional isEqualToString:@""]) {
		sectionTitle = [sectionTitle stringByReplacingOccurrencesOfString:@"职工" withString:@"居民"];
	}
	titleLabel.text = sectionTitle;
	titleLabel.font = [UIFont systemFontOfSize:14];
	titleLabel.textColor = [MSFCommandView getColorWithString:POINTCOLOR];
	titleLabel.backgroundColor = [UIColor clearColor];
	
	
	[sectionView addSubview:titleLabel];
	
	return sectionView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case 0:
			switch (indexPath.row) {
				case 0:
				{
					[self.viewModel.executePurposeCommand execute:nil];
				}
					break;
					
				default:
					break;
			}
			break;
		case 1:
			switch (indexPath.row) {
				case 0:
				{
					if ([self.professional isEqualToString:@""]) {
					[self.viewModel.executeResidentOlderInsuranceStatusCommand execute:nil];
					break;
				}
					[self.viewModel.executeEmployeeInsuranceStatusCommand execute:nil];
				}
					break;
				case 1:
					if ([self.professional isEqualToString:@""]) {
						[self.viewModel.executeResidentOlderInsuranceMoneyCommand execute:nil];
						break;
					}
					[self.viewModel.executeEmployeeOlderModeyCommand execute:nil];
					break;
				case 2:
					[self.viewModel.executeoldInsuranceDateCommand execute:self.view];
					break;
				default:
				case 3:
					break;
					break;
			}
			break;
		case 2:
			switch (indexPath.row) {
				case 0:
					if ([self.professional isEqualToString:@""]) {
						[self.viewModel.executeResidentMedicalInsuranceStatusCommand execute:nil];
						break;
					}
					[self.viewModel.executeEmployMedicalStatusCommand execute:nil];
					break;
				case 1:
					if ([self.professional isEqualToString:@""]) {
						[self.viewModel.executeResidentMedicalInsuranceMoneyCommand execute:nil];
						break;
					}
					[self.viewModel.executeEmployeeMedicalMoneyCommand execute:nil];
					break;
				case 2:
					[self.viewModel.executeoldMedicalDateCommand execute:self.view];
					break;
				default:
					break;
			}
			break;
		case 3:
			switch (indexPath.row) {
				case 0:
					[self.viewModel.executeEmplyoeeJuryStatusCommand execute:nil];
					break;
				case 1:
					[self.viewModel.executeEmployeeOutJobStatusCommand execute:nil];
					break;
				case 2:
					[self.viewModel.executeEmployeeBearStatusCommand execute:nil];
					break;
					
				default:
					break;
			}
		break;
			
  default:
			break;
	}
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if ([self.professional isEqualToString:@""]) {
		return 3;
	}
	return 4;
	
}

@end
