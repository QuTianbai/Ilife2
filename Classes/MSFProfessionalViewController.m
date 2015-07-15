//
//	MSFPersonInfoTableViewController.m
//	Cash
//
//	Created by xbm on 15/5/23.
//	Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFProfessionalViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <RMPickerViewController/RMPickerViewController.h>
#import <ActionSheetPicker-3.0/ActionSheetDatePicker.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "MSFSelectKeyValues.h"
#import "MSFApplicationForms.h"
#import <libextobjc/extobjc.h>
#import "NSDateFormatter+MSFFormattingAdditions.h"
#import "MSFAreas.h"
#import <FMDB/FMDatabase.h>
#import "MSFApplicationResponse.h"
#import "MSFProfessionalViewModel.h"
#import "MSFSelectionViewModel.h"
#import "MSFSelectionViewController.h"
#import "MSFRelationshipViewModel.h"
#import "MSFRelationshipViewController.h"
#import "UITextField+RACKeyboardSupport.h"

typedef NS_ENUM(NSUInteger, MSFProfessionalViewSection) {
		MSFProfessionalViewSectionSchool = 1,
		MSFProfessionalViewSectionCompany = 2,
		MSFProfessionalViewSectionDepartment = 3,
		MSFProfessionalViewSectionContact = 4,
};

@interface MSFProfessionalViewController ()

@property(nonatomic,strong) MSFProfessionalViewModel *viewModel;

@end

@implementation MSFProfessionalViewController

#pragma mark - MSFReactiveView

- (void)bindViewModel:(id)viewModel {
	self.viewModel = viewModel;
}

#pragma mark - Lifecycle

- (void)dealloc {
	NSLog(@"MSFProfessionalViewController `-dealloc`");
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"在职人员";
	
	RACChannelTerminal *universityNameChannel = RACChannelTo(self.viewModel.model, universityName);
	RAC(self.universityName, text) = universityNameChannel;
	[self.universityName.rac_textSignal subscribe:universityNameChannel];
	
	RACChannelTerminal *companyChannel = RACChannelTo(self.viewModel.model, company);
	RAC(self.company, text) = companyChannel;
	[self.company.rac_textSignal subscribe:companyChannel];
	
	RACChannelTerminal *unitExtensionTelephoneChannel = RACChannelTo(self.viewModel.model, unitExtensionTelephone);
	RAC(self.unitExtensionTelephone, text) = unitExtensionTelephoneChannel;
	[self.unitExtensionTelephone.rac_textSignal subscribe:unitExtensionTelephoneChannel];
	
	RACChannelTerminal *unitAreaCodeChannel = RACChannelTo(self.viewModel.model, unitAreaCode);
	RAC(self.unitAreaCode, text) = unitAreaCodeChannel;
	[self.unitAreaCode.rac_textSignal subscribe:unitAreaCodeChannel];
	
	RACChannelTerminal *unitTelephoneChannel = RACChannelTo(self.viewModel.model, unitTelephone);
	RAC(self.unitTelephone, text) = unitTelephoneChannel;
	[self.unitTelephone.rac_textSignal subscribe:unitTelephoneChannel];
	
	RACChannelTerminal *workTownChannel = RACChannelTo(self.viewModel.model, workTown);
	RAC(self.workTown, text) = workTownChannel;
	[self.unitTelephone.rac_textSignal subscribe:workTownChannel];
	
	RAC(self.education, text) = RACObserve(self.viewModel, degreesTitle);
	self.educationButton.rac_command = self.viewModel.executeEducationCommand;
	RAC(self.socialStatus, text) = RACObserve(self.viewModel, socialstatusTitle);
	self.socialStatusButton.rac_command = self.viewModel.executeSocialStatusCommand;
	RAC(self.programLength, text) = RACObserve(self.viewModel, eductionalSystmeTitle);
	self.programLengthButton.rac_command = self.viewModel.executeEductionalSystmeCommand;
	RAC(self.enrollmentYear, text) = RACObserve(self.viewModel, enrollmentYear);
	self.enrollmentYearButton.rac_command = self.viewModel.executeEnrollmentYearCommand;
	RAC(self.workingLength, text) = RACObserve(self.viewModel, seniorityTitle);
	self.workingLengthButton.rac_command = self.viewModel.executeWorkingLengthCommand;
	RAC(self.industry, text) = RACObserve(self.viewModel, industryTitle);
	self.industryButton.rac_command = self.viewModel.executeIndustryCommand;
	RAC(self.companyType, text) = RACObserve(self.viewModel, natureTitle);
	self.companyTypeButton.rac_command = self.viewModel.executeNatureCommand;
	RAC(self.department, text) = RACObserve(self.viewModel, departmentTitle);
	self.departmentButton.rac_command = self.viewModel.executeDepartmentCommand;
	RAC(self.position, text) = RACObserve(self.viewModel, positionTitle);
	self.positionButton.rac_command = self.viewModel.executePositionCommand;
	RAC(self.currentJobDate, text) = RACObserve(self.viewModel, startedDate);
	self.currentJobDateButton.rac_command = self.viewModel.executeStartedDateCommand;
	RAC(self.address, text) = RACObserve(self.viewModel, address);
	self.addressButton.rac_command = self.viewModel.executeAddressCommand;
	
	
	@weakify(self)
	[RACObserve(self.viewModel, socialstatus) subscribeNext:^(id x) {
		@strongify(self)
		[self.tableView reloadData];
	}];
	
	self.nextButton.rac_command = self.viewModel.executeCommitCommand;
	[self.viewModel.executeCommitCommand.executionSignals subscribeNext:^(RACSignal *signal) {
		@strongify(self)
		[SVProgressHUD showWithStatus:@"正在提交..." maskType:SVProgressHUDMaskTypeClear];
		[signal subscribeNext:^(id x) {
			[SVProgressHUD dismiss];
			UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"relationship" bundle:nil];
			UIViewController <MSFReactiveView> *vc = storyboard.instantiateInitialViewController;
			MSFRelationshipViewModel *viewModel = [[MSFRelationshipViewModel alloc] initWithFormsViewModel:self.viewModel.formsViewModel contentViewController:vc];
			[vc bindViewModel:viewModel];
			[self.navigationController pushViewController:vc animated:YES];
		}];
	}];
	[self.viewModel.executeCommitCommand.errors subscribeNext:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];
	[self.workTown.rac_keyboardReturnSignal subscribeNext:^(id x) {
		@strongify(self)
		[self.viewModel.executeCommitCommand execute:nil];
	}];
}

#pragma mark - UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (!self.viewModel.socialstatus && section == 0) {
		return [super tableView:tableView titleForHeaderInSection:section];
	}
	if ([self.viewModel.socialstatus.code isEqualToString:@"SI01"]) {
		if (section == 0 || section == MSFProfessionalViewSectionSchool) {
			return [super tableView:tableView titleForHeaderInSection:section];
		}
	}
	if ([self.viewModel.socialstatus.code isEqualToString:@"SI02"]) {
		if (section == 0 || section == MSFProfessionalViewSectionCompany || section == MSFProfessionalViewSectionContact || section == MSFProfessionalViewSectionDepartment) {
			return [super tableView:tableView titleForHeaderInSection:section];
		}
	}
	if ([self.viewModel.socialstatus.code isEqualToString:@"SI03"] && section == 0) {
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
		if (section == MSFProfessionalViewSectionSchool) {
			return [super tableView:tableView numberOfRowsInSection:section];
		}
	}
	if ([self.viewModel.socialstatus.code isEqualToString:@"SI02"]) {
		if (section == 0 || section == MSFProfessionalViewSectionCompany || section == MSFProfessionalViewSectionContact || section == MSFProfessionalViewSectionDepartment) {
			return [super tableView:tableView numberOfRowsInSection:section];
		}
	}
	if ([self.viewModel.socialstatus.code isEqualToString:@"SI03"] && section == 0) {
		return 2;
	}
	return 0;
}

@end
