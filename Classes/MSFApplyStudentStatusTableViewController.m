//
//  MSFApplyStudentStatusTableViewController.m
//  Cash
//
//  Created by xbm on 15/6/7.
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFApplyStudentStatusTableViewController.h"
#import <RMPickerViewController/RMPickerViewController.h>
#import <libextobjc/extobjc.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ActionSheetPicker-3.0/ActionSheetPicker.h>
#import "MSFApplyStartViewModel.h"
#import "MSFApplicationResponse.h"
#import "MSFApplicationForms.h"
#import "MSFSelectKeyValues.h"
#import "MSFProgressHUD.h"
#import "MSFAFStudentViewModel.h"
#import "MSFProfessionalViewModel.h"
#import "NSDateFormatter+MSFFormattingAdditions.h"
#import "MSFSelectionViewModel.h"
#import "MSFSelectionViewController.h"

@interface MSFApplyStudentStatusTableViewController()

@property(nonatomic,strong) MSFApplicationResponse *applyCash;
@property(nonatomic,strong) NSMutableArray *pickerArray;
@property(nonatomic,strong) MSFApplyStartViewModel *viewModel;
@property(weak, nonatomic) IBOutlet UITextField *educateTF;
@property(weak, nonatomic) IBOutlet UITextField *socalTF;
@property(weak, nonatomic) IBOutlet UITextField *shoolNameTF;
@property(weak, nonatomic) IBOutlet UITextField *shoolTimeTF;
@property(weak, nonatomic) IBOutlet UIButton *shoolTimeBT;
@property(weak, nonatomic) IBOutlet UITextField *shoolLengthTF;
@property(weak, nonatomic) IBOutlet UIButton *shoolLenghBT;
@property(weak, nonatomic) IBOutlet UIButton *nextPageBT;

@end

@implementation MSFApplyStudentStatusTableViewController

- (void)bindViewModel:(id)viewModel {
  self.viewModel = viewModel;
}

- (void)bindTitle:(id)titleDict {
}

- (void)viewWillAppear:(BOOL)animated {
  self.viewModel.applyInfoModel.page = @"3";
  self.viewModel.applyInfoModel.applyStatus1 = @"0";
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"学校信息";
  RAC(self,educateTF.text) =
  [RACObserve(self.viewModel, careerViewModel.degrees) map:^id(MSFSelectKeyValues *value) {
    return value.text;
  }];
  
//  RAC(self,socalTF.text) =
//  [RACObserve(self.viewModel, careerViewModel.profession) map:^id(MSFSelectKeyValues *value) {
//    return value.text;
//  }];
	
  RACChannelTerminal *schoolChannel = RACChannelTo(self.viewModel,studentViewModel.school);
  RAC(self,shoolNameTF.text) = schoolChannel;
  [self.shoolNameTF.rac_textSignal subscribe:schoolChannel];
  
  RAC(self,shoolTimeTF.text) =
  [RACObserve(self.viewModel,studentViewModel.year) map:^id(NSDate *value) {
    return [NSDateFormatter msf_stringFromDate:value==nil?[NSDate date]:value];
  }];
  
  RAC(self,shoolLengthTF.text) =
  [RACObserve(self.viewModel, studentViewModel.length) map:^id(MSFSelectKeyValues *value) {
    return value.text;
  }];
  
  @weakify(self)
  [[self.shoolTimeBT rac_signalForControlEvents:UIControlEventTouchUpInside]
   subscribeNext:^(id x) {
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
        self.viewModel.studentViewModel.year = selectedDate;
      }
      cancelBlock:^(ActionSheetDatePicker *picker) {
        self.viewModel.studentViewModel.year = [NSDate date];
      }
      origin:self.view];
   }];
  
  [[self.shoolLenghBT rac_signalForControlEvents:UIControlEventTouchUpInside]
   subscribeNext:^(id x) {
     [self.view endEditing:YES];
     MSFSelectionViewModel *viewModel = [MSFSelectionViewModel selectKeyValuesViewModel:[MSFSelectKeyValues getSelectKeys:@"school_system"]];
     MSFSelectionViewController *selectionViewController = [[MSFSelectionViewController alloc] initWithViewModel:viewModel];
     selectionViewController.title = @"选择学制";
     [self.navigationController pushViewController:selectionViewController animated:YES];
     @weakify(selectionViewController)
     [selectionViewController.selectedSignal subscribeNext:^(MSFSelectKeyValues *selectValue) {
       @strongify(selectionViewController)
       [selectionViewController.navigationController popViewControllerAnimated:YES];
       self.viewModel.studentViewModel.length = selectValue;
     }];
   }];
  
  self.nextPageBT.rac_command = self.viewModel.studentViewModel.executeRequest;
  [self.viewModel.studentViewModel.executeRequest.executionSignals subscribeNext:^(RACSignal *execution) {
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
  [self.viewModel.executeStudent.errors subscribeNext:^(NSError *error) {
    [MSFProgressHUD showErrorMessage:error.userInfo[NSLocalizedFailureReasonErrorKey] inView:self.navigationController.view];
  }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  [segue.destinationViewController bindViewModel:self.viewModel];
}

@end
