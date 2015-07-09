//
//  MSFSocalStatusFirstTableViewController.m
//  Cash
//
//  Created by xbm on 15/6/6.
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFSocalStatusFirstTableViewController.h"
#import <libextobjc/extobjc.h>
#import <RMPickerViewController/RMPickerViewController.h>
#import "MSFPersonalViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFApplyStartViewModel.h"
#import "MSFSelectKeyValues.h"
#import "MSFApplyInfo.h"
#import "MSFApplyCash.h"
#import "MSFProgressHUD.h"
#import "MSFSelectionViewModel.h"
#import "MSFSelectionViewController.h"
#import "MSFSelectKeyValues.h"
#import "MSFProfessionalViewModel.h"

@interface MSFSocalStatusFirstTableViewController ()

@property(strong,nonatomic) MSFApplyCash *applyCash;
@property(weak, nonatomic) IBOutlet UITextField *educateTF;
@property(weak, nonatomic) IBOutlet UIButton *educateBT;
@property(weak, nonatomic) IBOutlet UITextField *socalTF;
@property(weak, nonatomic) IBOutlet UIButton *socalBT;
@property(strong,nonatomic) MSFApplyStartViewModel *viewModel;
@property(weak, nonatomic) IBOutlet UIButton *nextPageButton;

@end

@implementation MSFSocalStatusFirstTableViewController

#pragma mark - Lifecycle

- (void)bindViewModel:(id)viewModel {
  self.viewModel = viewModel;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"社会身份";
  RAC(self.educateTF,text) = [[RACObserve(self.viewModel.careerViewModel, degrees) ignore:nil]
   map:^id(id value) {
    return [value text];
  }];
  RAC(self.socalTF,text) = [[RACObserve(self.viewModel.careerViewModel, profession) ignore:nil]
   map:^id(id value) {
    return [value text];
  }];
  @weakify(self)
  [[self.educateBT rac_signalForControlEvents:UIControlEventTouchUpInside]
   subscribeNext:^(id x) {
     @strongify(self)
     [self.view endEditing:YES];
     MSFSelectionViewModel *viewModel = [MSFSelectionViewModel selectKeyValuesViewModel:[MSFSelectKeyValues getSelectKeys:@"edu_background"]];
     MSFSelectionViewController *selectionViewController = [[MSFSelectionViewController alloc] initWithViewModel:viewModel];
     selectionViewController.title = @"选择学历";
     [self.navigationController pushViewController:selectionViewController animated:YES];
     @weakify(selectionViewController)
     [selectionViewController.selectedSignal subscribeNext:^(MSFSelectKeyValues *selectValue) {
       @strongify(selectionViewController)
       [selectionViewController.navigationController popViewControllerAnimated:YES];
       self.viewModel.careerViewModel.degrees = selectValue;
     }];
   }];
  [[self.socalBT rac_signalForControlEvents:UIControlEventTouchUpInside]
   subscribeNext:^(id x) {
     @strongify(self)
     [self.view endEditing:YES];
     MSFSelectionViewModel *viewModel = [MSFSelectionViewModel selectKeyValuesViewModel:[MSFSelectKeyValues getSelectKeys:@"social_status"]];
     MSFSelectionViewController *selectionViewController = [[MSFSelectionViewController alloc] initWithViewModel:viewModel];
     selectionViewController.title = @"选择社会身份";
     [self.navigationController pushViewController:selectionViewController animated:YES];
     @weakify(selectionViewController)
     [selectionViewController.selectedSignal subscribeNext:^(MSFSelectKeyValues *selectValue) {
       @strongify(selectionViewController)
       [selectionViewController.navigationController popViewControllerAnimated:YES];
       self.viewModel.careerViewModel.profession = selectValue;
     }];
   }];
  
  self.nextPageButton.rac_command = self.viewModel.careerViewModel.executeRequest;
  [self.nextPageButton.rac_command.executionSignals subscribeNext:^(RACSignal *signal) {
    @strongify(self)
    [MSFProgressHUD showStatusMessage:@"正在提交..." inView:self.navigationController.view];
    [signal subscribeNext:^(id x) {
      self.applyCash = x;
      self.viewModel.applyInfoModel.loanId = self.applyCash.applyID;
      self.viewModel.applyInfoModel.personId = self.applyCash.personId;
      self.viewModel.applyInfoModel.applyNo = self.applyCash.applyNo;
      [MSFProgressHUD hidden];
      if ([self.viewModel.applyInfoModel.socialStatus isEqualToString:@"SI01"]) {
        [self performSegueWithIdentifier:@"student" sender:nil];
      }
      else if ([self.viewModel.applyInfoModel.socialStatus isEqualToString:@"SI02"]) {
        [self performSegueWithIdentifier:@"socal" sender:nil];
      }
      else if ([self.viewModel.applyInfoModel.socialStatus isEqualToString:@"SI03"]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Family" bundle:nil];
        UIViewController <MSFReactiveView> *vc = storyboard.instantiateInitialViewController;
        [vc bindViewModel:self.viewModel];
        [self.navigationController pushViewController:vc animated:YES];
      }
    }];
  }];
  
  [self.nextPageButton.rac_command.errors subscribeNext:^(NSError *error) {
    @strongify(self)
    [MSFProgressHUD showErrorMessage:error.userInfo[NSLocalizedFailureReasonErrorKey] inView:self.navigationController.view];
  }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  [segue.destinationViewController bindViewModel:self.viewModel];
}

@end
