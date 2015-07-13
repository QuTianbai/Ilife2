//
//  MSFPersonInfoTableViewController.m
//  Cash
//
//  Created by xbm on 15/5/23.
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFProfessionalViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <RMPickerViewController/RMPickerViewController.h>
#import <ActionSheetPicker-3.0/ActionSheetDatePicker.h>
#import "MSFSelectKeyValues.h"
#import "MSFApplyStartViewModel.h"
#import "MSFApplicationForms.h"
#import <libextobjc/extobjc.h>
#import "NSDateFormatter+MSFFormattingAdditions.h"
#import "MSFAreas.h"
#import <FMDB/FMDatabase.h>
#import "MSFApplicationResponse.h"
#import "MSFProgressHUD.h"
#import "MSFProfessionalViewModel.h"
#import "MSFSelectionViewModel.h"
#import "MSFSelectionViewController.h"

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

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"在职人员";
	
	RACChannelTerminal *universityNameChannel = RACChannelTo(self.viewModel.model, universityName);
  RAC(self.universityName, text) = universityNameChannel;
  [self.universityName.rac_textSignal subscribe:universityNameChannel];
	
	RACChannelTerminal *companyChannel = RACChannelTo(self.viewModel.model, company);
  RAC(self.company, text) = companyChannel;
  [self.universityName.rac_textSignal subscribe:companyChannel];
	
	RAC(self.education, text) = RACObserve(self.viewModel, degreesTitle);
	self.educationButton.rac_command = self.viewModel.executeEducationCommand;
	RAC(self.socialStatus, text) = RACObserve(self.viewModel, socialstatusTitle);
	self.socialStatusButton.rac_command = self.viewModel.executeSocialStatusCommand;
	RAC(self.programLength, text) = RACObserve(self.viewModel, eductionalSystmeTitle);
	self.programLengthButton.rac_command = self.viewModel.executeEductionalSystmeCommand;
	RAC(self.enrollmentYear, text) = RACObserve(self.viewModel, enrollmentYear);
	self.enrollmentYearButton.rac_command = self.viewModel.executeEnrollmentYearCommand;
	RAC(self.workingLength,text) = RACObserve(self.viewModel, seniorityTitle);
	self.workingLengthButton.rac_command = self.viewModel.executeWorkingLengthCommand;
	
	@weakify(self)
	[RACObserve(self.viewModel, socialstatus) subscribeNext:^(id x) {
		@strongify(self)
		[self.tableView reloadData];
	}];
	
	[[self.nextButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
		@strongify(self)
		NSLog(@"%@", [self.viewModel.model description]);
	}];
	/*
  RAC(self.educationTF,text) =
  [RACObserve(self.viewModel.careerViewModel, degrees) map:^id(MSFSelectKeyValues *value) {
    return value.text;
  }];
  RAC(self.cardTypeTF,text)=
  [RACObserve(self.viewModel.careerViewModel, profession) map:^id(MSFSelectKeyValues *value) {
    return value.text;
  }];
  
  RAC(self.jobYeasTF,text) = [[RACObserve(self.viewModel, careerViewModel.seniority) ignore:nil]
   map:^id(MSFSelectKeyValues *value) {
     return value.text;
  }];
  
  RAC(self.industryTypeTF,text) = [[RACObserve(self.viewModel, careerViewModel.industry) ignore:nil]
   map:^id(MSFSelectKeyValues *value) {
     return value.text;
  }];
  
  RAC(self.posiotionTF,text) = [[RACObserve(self.viewModel, careerViewModel.position) ignore:nil]
   map:^id(MSFSelectKeyValues *value) {
     return value.text;
  }];
  
  RAC(self.natureTF,text) = [[RACObserve(self.viewModel, careerViewModel.nature) ignore:nil]
   map:^id(MSFSelectKeyValues *value) {
     return value.text;
  }];
  
  RAC(self.jobTimeTF,text) = [[RACObserve(self.viewModel, careerViewModel.date) ignore:nil]
   map:^id(NSDate *date) {
     return [NSDateFormatter msf_stringFromDate:date];
  }];
  
  RACChannelTerminal *codeChannel = RACChannelTo(self.viewModel,careerViewModel.areaCode);
  RAC(self.areaCodeTF,text) = codeChannel;
  [self.areaCodeTF.rac_textSignal subscribe:codeChannel];
  
  RACChannelTerminal *telephoneChannel = RACChannelTo(self.viewModel,careerViewModel.telephone);
  RAC(self.telTF,text) = telephoneChannel;
  [self.telTF.rac_textSignal subscribe:telephoneChannel];
  
  RACChannelTerminal *extensionTelephoneChannel = RACChannelTo(self.viewModel,careerViewModel.extensionTelephone);
  RAC(self.extensionTF,text) =  extensionTelephoneChannel;
  [self.extensionTF.rac_textSignal subscribe:extensionTelephoneChannel];
  
  RACChannelTerminal *addressChannel = RACChannelTo(self.viewModel,careerViewModel.address);
  RAC(self.companyAdressTF,text) =  addressChannel;
  [self.companyAdressTF.rac_textSignal subscribe:addressChannel];
  
  @weakify(self)
  [[self.jobYearsBT rac_signalForControlEvents:UIControlEventTouchUpInside]
   subscribeNext:^(id x) {
     @strongify(self)
     [self.view endEditing:YES];
     MSFSelectionViewModel *viewModel = [MSFSelectionViewModel selectKeyValuesViewModel:[MSFSelectKeyValues getSelectKeys:@"service_year"]];
     MSFSelectionViewController *selectionViewController = [[MSFSelectionViewController alloc] initWithViewModel:viewModel];
     selectionViewController.title = @"工作年限";
     [self.navigationController pushViewController:selectionViewController animated:YES];
     @weakify(selectionViewController)
     [selectionViewController.selectedSignal subscribeNext:^(MSFSelectKeyValues *selectValue) {
       @strongify(selectionViewController)
       [selectionViewController.navigationController popViewControllerAnimated:YES];
       self.viewModel.careerViewModel.seniority = selectValue;
     }];
   }];
  
  RACChannelTerminal *companyChannel = RACChannelTo(self.viewModel,careerViewModel.company);
  RAC(self.companyNameTF,text) = companyChannel;
  [self.companyNameTF.rac_textSignal subscribe:companyChannel];
  
  [[self.industryTypeBT rac_signalForControlEvents:UIControlEventTouchUpInside]
   subscribeNext:^(id x) {
     @strongify(self)
     [self.view endEditing:YES];
     MSFSelectionViewModel *viewModel = [MSFSelectionViewModel selectKeyValuesViewModel:[MSFSelectKeyValues getSelectKeys:@"industry_category"]];
     MSFSelectionViewController *selectionViewController = [[MSFSelectionViewController alloc] initWithViewModel:viewModel];
     selectionViewController.title = @"行业类别";
     [self.navigationController pushViewController:selectionViewController animated:YES];
     @weakify(selectionViewController)
     [selectionViewController.selectedSignal subscribeNext:^(MSFSelectKeyValues *selectValue) {
       @strongify(selectionViewController)
       [selectionViewController.navigationController popViewControllerAnimated:YES];
       self.viewModel.careerViewModel.industry = selectValue;
     }];
   }];
  
  [[self.positionBT rac_signalForControlEvents:UIControlEventTouchUpInside]
   subscribeNext:^(id x) {
     @strongify(self)
     [self.view endEditing:YES];
     MSFSelectionViewModel *viewModel = [MSFSelectionViewModel selectKeyValuesViewModel:[MSFSelectKeyValues getSelectKeys:@"position"]];
     MSFSelectionViewController *selectionViewController = [[MSFSelectionViewController alloc] initWithViewModel:viewModel];
     selectionViewController.title = @"职位";
     [self.navigationController pushViewController:selectionViewController animated:YES];
     @weakify(selectionViewController)
     [selectionViewController.selectedSignal subscribeNext:^(MSFSelectKeyValues *selectValue) {
       @strongify(selectionViewController)
       [selectionViewController.navigationController popViewControllerAnimated:YES];
       self.viewModel.careerViewModel.position = selectValue;
     }];
   }];
  [[self.natureBT rac_signalForControlEvents:UIControlEventTouchUpInside]
   subscribeNext:^(id x) {
     @strongify(self)
     [self.view endEditing:YES];
     MSFSelectionViewModel *viewModel = [MSFSelectionViewModel selectKeyValuesViewModel:[MSFSelectKeyValues getSelectKeys:@"unit_nature"]];
     MSFSelectionViewController *selectionViewController = [[MSFSelectionViewController alloc] initWithViewModel:viewModel];
     selectionViewController.title = @"职业性质";
     [self.navigationController pushViewController:selectionViewController animated:YES];
     @weakify(selectionViewController)
     [selectionViewController.selectedSignal subscribeNext:^(MSFSelectKeyValues *selectValue) {
       @strongify(selectionViewController)
       [selectionViewController.navigationController popViewControllerAnimated:YES];
       self.viewModel.careerViewModel.nature = selectValue;
     }];
   }];
  
  [[self.jobTimeBT rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
    @strongify(self)
    [self.view endEditing:YES];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:0];
    NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    [comps setYear:-30];
    NSDate *minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    
    [ActionSheetDatePicker
     showPickerWithTitle:@""
     datePickerMode:UIDatePickerModeDate
     selectedDate:[NSDate date]
     minimumDate:minDate
     maximumDate:maxDate
     doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
       self.viewModel.careerViewModel.date = selectedDate;
     }
     cancelBlock:^(ActionSheetDatePicker *picker) {
       self.viewModel.careerViewModel.date = [NSDate date];
     }
     origin:self.view];
  }];
  
  RAC(self.compneyAreasTF,text) = [RACSignal combineLatest:@[
     RACObserve(self.viewModel, careerViewModel.province),
     RACObserve(self.viewModel, careerViewModel.city),
     RACObserve(self.viewModel, careerViewModel.area),
     ]
   reduce:^id(MSFAreas *province,MSFAreas *city ,MSFAreas *area) {
     return [NSString stringWithFormat:@"%@ %@ %@",province.name?:@"省/直辖市",city.name?:@"市",area.name?:@"区"];
   }];
  
  NSString *path = [[NSBundle mainBundle] pathForResource:@"dicareas" ofType:@"db"];
  self.fmdb = [FMDatabase databaseWithPath:path];
  [[self.compneyAreasBT rac_signalForControlEvents:UIControlEventTouchUpInside]
   subscribeNext:^(id x) {
     @strongify(self)
     [self.view endEditing:YES];
     [self showSelectedViewController];
   }];
  
  self.nextPageBT.rac_command = self.viewModel.careerViewModel.executeIncumbencyRequest;
  [self.viewModel.careerViewModel.executeIncumbencyRequest.executionSignals subscribeNext:^(RACSignal *execution) {
    @strongify(self)
    [execution subscribeNext:^(id x) {
      self.applyCash = x;
      self.viewModel.applyInfoModel.loanId = self.applyCash.applyID;
      self.viewModel.applyInfoModel.personId = self.applyCash.personId;
      self.viewModel.applyInfoModel.applyNo = self.applyCash.applyNo;
      UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Family" bundle:nil];
      UIViewController <MSFReactiveView> *vc = storyboard.instantiateInitialViewController;
      [vc bindViewModel:self.viewModel];
      [self.navigationController pushViewController:vc animated:YES];
    }];
  }];
  [self.viewModel.careerViewModel.executeIncumbencyRequest.errors subscribeNext:^(NSError *error) {
    [MSFProgressHUD showErrorMessage:error.userInfo[NSLocalizedFailureReasonErrorKey] inView:self.navigationController.view];
  }];
  
  [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil]
    takeUntil:self.rac_willDeallocSignal]
   subscribeNext:^(NSNotification *notification) {
     @strongify(self)
     NSValue *keyboardBoundsValue = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
     CGRect keyboardBounds;
     [keyboardBoundsValue getValue:&keyboardBounds];
     UIEdgeInsets e = UIEdgeInsetsMake(0, 0, keyboardBounds.size.height, 0);
     [[self tableView] setScrollIndicatorInsets:e];
     [[self tableView] setContentInset:e];
   }];
  [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillHideNotification object:nil]
    takeUntil:self.rac_willDeallocSignal]
   subscribeNext:^(id x) {
     @strongify(self)
     [UIView animateWithDuration:.3 animations:^{
       UIEdgeInsets e = UIEdgeInsetsZero;
       [[self tableView] setScrollIndicatorInsets:e];
       [[self tableView] setContentInset:e];
     }];
   }];
	 */
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
