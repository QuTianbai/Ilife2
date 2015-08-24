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
#import "MSFCommandView.h"
#import "MSFXBMCustomHeader.h"
#import "MSFHeaderView.h"
#import "NSDate+UTC0800.h"

typedef NS_ENUM(NSUInteger, MSFProfessionalViewSection) {
	MSFProfessionalViewSectionSchool = 1,
	MSFProfessionalViewSectionCompany = 2,
	MSFProfessionalViewSectionDepartment = 3,
	MSFProfessionalViewSectionContact = 4,
};

@interface MSFProfessionalViewController ()

@property (nonatomic, strong) MSFProfessionalViewModel *viewModel;

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
	self.title = @"职业信息";
	self.tableView.tableHeaderView = [MSFHeaderView headerViewWithIndex:1];
	
	[[self.universityName rac_signalForControlEvents:UIControlEventEditingChanged]
		subscribeNext:^(UITextField *textField) {
			if (textField.text.length > 14) {
				textField.text = [textField.text substringToIndex:14];
			}
		}];
	
	RACChannelTerminal *universityNameChannel = RACChannelTo(self.viewModel.model, universityName);
	RAC(self.universityName, text) = universityNameChannel;
	[self.universityName.rac_textSignal subscribe:universityNameChannel];
	
	[[self.company rac_signalForControlEvents:UIControlEventEditingChanged]
		subscribeNext:^(UITextField *textField) {
			if (textField.text.length > 20) {
				textField.text = [textField.text substringToIndex:20];
			}
		}];
	
	RACChannelTerminal *companyChannel = RACChannelTo(self.viewModel.model, company);
	RAC(self.company, text) = companyChannel;
	[self.company.rac_textSignal subscribe:companyChannel];
	
	[[self.unitExtensionTelephone rac_signalForControlEvents:UIControlEventEditingChanged]
		subscribeNext:^(UITextField *textField) {
			if (textField.text.length > 4) {
				textField.text = [textField.text substringToIndex:4];
			}
		}];
	RACChannelTerminal *unitExtensionTelephoneChannel = RACChannelTo(self.viewModel.model, unitExtensionTelephone);
	RAC(self.unitExtensionTelephone, text) = unitExtensionTelephoneChannel;
	[self.unitExtensionTelephone.rac_textSignal subscribe:unitExtensionTelephoneChannel];
	
	@weakify(self)
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
	RACChannelTerminal *unitAreaCodeChannel = RACChannelTo(self.viewModel.model, unitAreaCode);
	RAC(self.unitAreaCode, text) = unitAreaCodeChannel;
	[self.unitAreaCode.rac_textSignal subscribe:unitAreaCodeChannel];
	
	[[self.unitTelephone rac_signalForControlEvents:UIControlEventEditingChanged]
		subscribeNext:^(UITextField *textField) {
			if (textField.text.length>8) {
				textField.text = [textField.text substringToIndex:8];
			}
		}];
	RACChannelTerminal *unitTelephoneChannel = RACChannelTo(self.viewModel.model, unitTelephone);
	RAC(self.unitTelephone, text) = unitTelephoneChannel;
	[self.unitTelephone.rac_textSignal subscribe:unitTelephoneChannel];
	
	RACChannelTerminal *workTownChannel = RACChannelTo(self.viewModel.model, workTown);
	RAC(self.workTown, text) = workTownChannel;
	[self.workTown.rac_textSignal subscribe:workTownChannel];
	
	RAC(self.education, text) = RACObserve(self.viewModel, degreesTitle);
	self.educationButton.rac_command = self.viewModel.executeEducationCommand;
	RAC(self.socialStatus, text) = RACObserve(self.viewModel, socialstatusTitle);
	RAC(self, title) = RACObserve(self.viewModel, socialstatusTitle);
	self.socialStatusButton.rac_command = self.viewModel.executeSocialStatusCommand;
	RAC(self.programLength, text) = RACObserve(self.viewModel, eductionalSystmeTitle);
	self.programLengthButton.rac_command = self.viewModel.executeEductionalSystmeCommand;
	RAC(self.workingLength, text) = RACObserve(self.viewModel, seniorityTitle);
	self.workingLengthButton.rac_command = self.viewModel.executeWorkingLengthCommand;
	RAC(self.industry, text) = RACObserve(self.viewModel, industryTitle);
	self.industryButton.rac_command = self.viewModel.executeIndustryCommand;
	RAC(self.companyType, text) = RACObserve(self.viewModel, natureTitle);
	self.companyTypeButton.rac_command = self.viewModel.executeNatureCommand;
	
	[[self.department rac_signalForControlEvents:UIControlEventEditingChanged]
		subscribeNext:^(UITextField *textField) {
			if (textField.text.length > 20) {
				textField.text = [textField.text substringToIndex:20];
			}
		}];
	
	RACChannelTerminal *departmentChannel = RACChannelTo(self.viewModel.model, department);
	RAC(self.department, text) = departmentChannel;
	[self.department.rac_textSignal subscribe:departmentChannel];

	RAC(self.position, text) = RACObserve(self.viewModel, positionTitle);
	self.positionButton.rac_command = self.viewModel.executePositionCommand;
	RAC(self.address, text) = RACObserve(self.viewModel, address);
	self.addressButton.rac_command = self.viewModel.executeAddressCommand;
	
	RAC(self.enrollmentYear, text) = RACObserve(self.viewModel, enrollmentYear);
	[[self.enrollmentYearButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
		@strongify(self)
		[self enrollmentYearSignal];
	}];
	RAC(self.currentJobDate, text) = RACObserve(self.viewModel, startedDate);
	[[self.currentJobDateButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
		@strongify(self)
		[self startedDateSignal];
	}];
	
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
			MSFRelationshipViewModel *viewModel = [[MSFRelationshipViewModel alloc] initWithFormsViewModel:self.viewModel.formsViewModel];
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

#pragma mark - Private

- (RACSignal *)startedDateSignal {
	@weakify(self)
	return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		@strongify(self)
		NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
		NSDate *currentDate = [NSDate msf_date];
		NSDateComponents *comps = [[NSDateComponents alloc] init];
		[comps setYear:0];
		NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
		[comps setYear:-50];
		NSDate *minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];

		[ActionSheetDatePicker
		 showPickerWithTitle:@""
		 datePickerMode:UIDatePickerModeDate
		 selectedDate:currentDate
		 minimumDate:minDate
		 maximumDate:maxDate
		 doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
			 self.viewModel.startedDate = [NSDateFormatter msf_stringFromDate2:[NSDate msf_date:selectedDate]];
			 [subscriber sendNext:nil];
			 [subscriber sendCompleted];
		 }
		 cancelBlock:^(ActionSheetDatePicker *picker) {
			 self.viewModel.startedDate = nil;
			 [subscriber sendNext:nil];
			 [subscriber sendCompleted];
		 }
		 origin:self.view];
		return nil;
	}] replay];
}

- (RACSignal *)enrollmentYearSignal {
	@weakify(self)
	return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		@strongify(self)
		NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
		NSDate *currentDate = [NSDate msf_date];
		NSDateComponents *comps = [[NSDateComponents alloc] init];
		[comps setYear:0];
		NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
		[comps setYear:-7];
		NSDate *minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
		
		[ActionSheetDatePicker
		 showPickerWithTitle:@""
		 datePickerMode:UIDatePickerModeDate
		 selectedDate:currentDate
		 minimumDate:minDate
		 maximumDate:maxDate
		 doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
			 self.viewModel.enrollmentYear = [NSDateFormatter msf_stringFromDate3:[NSDate msf_date:selectedDate]];
			 [subscriber sendNext:nil];
			 [subscriber sendCompleted];
		 }
		 cancelBlock:^(ActionSheetDatePicker *picker) {
			 self.viewModel.enrollmentYear = [NSDateFormatter msf_stringFromDate:[NSDate msf_date]];
			 [subscriber sendNext:nil];
			 [subscriber sendCompleted];
		 }
		 origin:self.view];
		return nil;
	}] replay];
}

@end
