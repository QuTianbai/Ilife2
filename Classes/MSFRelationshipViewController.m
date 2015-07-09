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
#import "MSFApplyStartViewModel.h"
#import "MSFRelationshipViewModel.h"
#import "MSFApplicationForms.h"
#import "MSFApplicationResponse.h"
#import "MSFProgressHUD.h"
#import "MSFCommandView.h"

#define SEPARATORCOLOR @"5787c0"
#define CELLBACKGROUNDCOLOR @"dce6f2"
#define TYPEFACECOLOR @"5787c0"

@interface MSFRelationshipViewController ()

@property(nonatomic,strong) MSFApplicationResponse *applyCash;
@property(nonatomic,strong) MSFApplyStartViewModel *viewModel;
@property(nonatomic,strong) NSMutableArray *pickerArray;
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
- (IBAction)isSameCurrent:(id)sender;
- (IBAction)addFamilyMember:(id)sender;

/**
 *  家庭联系人二
 */
@property(weak, nonatomic) IBOutlet UITextField *num2FamilyNameTF;
@property(weak, nonatomic) IBOutlet UIButton *num2RelationBT;
@property(weak, nonatomic) IBOutlet UITextField *num2RelationTF;
@property(weak, nonatomic) IBOutlet UITextField *num2TelTF;
@property(weak, nonatomic) IBOutlet UISwitch *num2IsSameCurrentSW;
@property(weak, nonatomic) IBOutlet UITextField *num2DiffCurrentTF;
- (IBAction)num2IsSameCurrent:(id)sender;
@property(weak, nonatomic) IBOutlet UILabel *num2FamilyLable;
@property(weak, nonatomic) IBOutlet UILabel *num2RelationLabel;
@property(weak, nonatomic) IBOutlet UILabel *num2FamilyPhone;
@property(weak, nonatomic) IBOutlet UILabel *num2IsSameAddressLabel;

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
- (IBAction)addOtherContact:(id)sender;
@property(weak, nonatomic) IBOutlet UILabel *num2OtherNameLabel;
@property(weak, nonatomic) IBOutlet UILabel *num2OtherRelationLabel;
@property(weak, nonatomic) IBOutlet UILabel *num2OtherPhoneLabel;

/**
 *  下一步
 */
@property(weak, nonatomic) IBOutlet UIButton *nextPageBT;

#define RELATION_VIEW_MODEL self.viewModel.relationViewModel

@end

@implementation MSFRelationshipViewController

- (void)bindViewModel:(id)viewModel {
  self.viewModel = viewModel;
}

- (void)viewWillAppear:(BOOL)animated {
  self.viewModel.applyInfoModel.page = @"4";
  self.viewModel.applyInfoModel.applyStatus1 = @"0";
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.title = @"家庭信息";
  self.edgesForExtendedLayout = UIRectEdgeNone;
  [_addFamilyBT setTitleColor:[MSFCommandView getColorWithString:TYPEFACECOLOR] forState:UIControlStateNormal];
  [_addOtherBT setTitleColor:[MSFCommandView getColorWithString:TYPEFACECOLOR] forState:UIControlStateNormal];
  //婚姻状况
  [self selectedViewController:_marriageBT andFileName:@"marital_status" andTitle:@"婚姻状况"
                        andKey:@"marryValues"];
  RAC(self.marriageTF,text) = [[RACObserve(RELATION_VIEW_MODEL, marryValues) ignore:nil]
                                    map:^id(MSFSelectKeyValues *value) {
                                      return value.text;
                                    }];
  //住房状况
  [self selectedViewController:_housesBT andFileName:@"housing_conditions" andTitle:@"住房状况"
                        andKey:@"houseValues"];
  RAC(self.houseTF,text) = [[RACObserve(RELATION_VIEW_MODEL, houseValues) ignore:nil]
                                    map:^id(MSFSelectKeyValues *value) {
                                      return value.text;
                                    }];
  //家庭成员一与申请人关系
  [self selectedViewController:_relationBT andFileName:@"familyMember_type" andTitle:@"与申请人关系"
                        andKey:@"familyOneValues"];
  RAC(self.relationTF,text) = [[RACObserve(RELATION_VIEW_MODEL, familyOneValues) ignore:nil]
                                    map:^id(MSFSelectKeyValues *value) {
                                      return value.text;
                                    }];
  //家庭成员二与申请人关系
  [self selectedViewController:_num2RelationBT andFileName:@"familyMember_type" andTitle:@"与申请人关系"
                        andKey:@"familyTwoValues"];
  RAC(self.num2RelationTF,text) = [[RACObserve(RELATION_VIEW_MODEL, familyTwoValues) ignore:nil]
                                    map:^id(MSFSelectKeyValues *value) {
                                      return value.text;
                                    }];
  //其他联系人一与申请人关系
  [self selectedViewController:_otherRelationBT andFileName:@"relationship" andTitle:@"与申请人关系"
                        andKey:@"otherOneValues"];
  RAC(self.otherRelationTF,text) = [[RACObserve(RELATION_VIEW_MODEL, otherOneValues) ignore:nil]
                                    map:^id(MSFSelectKeyValues *value) {
                                      return value.text;
                                    }];
  //其他联系人二与申请人关系
  [self selectedViewController:_num2_otherRelationBT andFileName:@"relationship" andTitle:@"与申请人关系"
                        andKey:@"otherTwoValues"];
  RAC(self.num2_otherRelationTF,text) = [[RACObserve(RELATION_VIEW_MODEL, otherTwoValues) ignore:nil]
                                   map:^id(MSFSelectKeyValues *value) {
                                     return value.text;
                                   }];
  
  RACChannelTerminal *familyNameChannel = RACChannelTo(self.viewModel,relationViewModel.familyOneNameValues);
  RAC(self.familyNameTF,text) = familyNameChannel;
  [self.familyNameTF.rac_textSignal subscribe:familyNameChannel];
  
  RACChannelTerminal *phoneOneChannel = RACChannelTo(self.viewModel,relationViewModel.phoneNumOneValues);
  RAC(self.telTF,text) = phoneOneChannel;
  [self.telTF.rac_textSignal subscribe:phoneOneChannel];
  
  RACChannelTerminal *addressOneChannel = RACChannelTo(self.viewModel,relationViewModel.addressOneValues);
  RAC(self.diffCurrentTF,text) = addressOneChannel;
  [self.diffCurrentTF.rac_textSignal subscribe:addressOneChannel];
  
  RACChannelTerminal *familyName2Channel = RACChannelTo(self.viewModel,relationViewModel.familyTwoNameValues);
  RAC(self.num2FamilyNameTF,text) = familyName2Channel;
  [self.num2FamilyNameTF.rac_textSignal subscribe:familyName2Channel];
  
  RACChannelTerminal *phoneTwoChannel = RACChannelTo(self.viewModel,relationViewModel.phoneNumTwoValues);
  RAC(self.num2TelTF,text) = phoneTwoChannel;
  [self.num2TelTF.rac_textSignal subscribe:phoneTwoChannel];
  
  RACChannelTerminal *addressTwoChannel = RACChannelTo(self.viewModel,relationViewModel.addressTwoValues);
  RAC(self.num2DiffCurrentTF,text) = addressTwoChannel;
  [self.num2DiffCurrentTF.rac_textSignal subscribe:addressTwoChannel];
  
  RACChannelTerminal *otherName1Channel = RACChannelTo(self.viewModel,relationViewModel.otherOneNameValues);
  RAC(self.otherNameTF,text) = otherName1Channel;
  [self.otherNameTF.rac_textSignal subscribe:otherName1Channel];
  
  RACChannelTerminal *otherPhone1Channel = RACChannelTo(self.viewModel,relationViewModel.otherPhoneOneValues);
  RAC(self.otherTelTF,text) = otherPhone1Channel;
  [self.otherTelTF.rac_textSignal subscribe:otherPhone1Channel];
  
  RACChannelTerminal *otherName2Channel = RACChannelTo(self.viewModel,relationViewModel.otherTwoNameValues);
  RAC(self.num2_otherNameTF,text) = otherName2Channel;
  [self.num2_otherNameTF.rac_textSignal subscribe:otherName2Channel];
  
  RACChannelTerminal *otherPhone2Channel = RACChannelTo(self.viewModel,relationViewModel.otherPhoneTwoValues);
  RAC(self.num2_otherTelTF,text) = otherPhone2Channel;
  [self.num2_otherTelTF.rac_textSignal subscribe:otherPhone2Channel];
  
  self.viewModel.applyInfoModel.page = @"4";
  self.viewModel.applyInfoModel.applyStatus1 = @"0";
  
  self.nextPageBT.rac_command = self.viewModel.relationViewModel.executeRequest;;
  @weakify(self)
  [self.viewModel.relationViewModel.executeRequest.executionSignals subscribeNext:^(RACSignal *execution) {
    @strongify(self)
    [execution subscribeNext:^(id x) {
      self.applyCash = x;
      self.viewModel.applyInfoModel.loanId = self.applyCash.applyID;
      self.viewModel.applyInfoModel.personId = self.applyCash.personId;
      self.viewModel.applyInfoModel.applyNo = self.applyCash.applyNo;
      UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"commit" bundle:nil];
      UIViewController <MSFReactiveView> *vc = storyboard.instantiateInitialViewController;
      [vc bindViewModel:self.viewModel];
      [self.navigationController pushViewController:vc animated:YES];
    }];
    
  }];
  [self.viewModel.relationViewModel.executeRequest.errors subscribeNext:^(NSError *error) {
    //NSLocalizedFailureReasonErrorKey
    @strongify(self)
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
}

#pragma mark - selected View Controller

- (void)selectedViewController:(UIButton *)btn andFileName:(NSString *)fileName andTitle:(NSString *)title andKey:(NSString *)key {
  
  @weakify(self)
  [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
    @strongify(self)
    [self.view endEditing:YES];
    MSFSelectionViewModel *viewModel = [MSFSelectionViewModel selectKeyValuesViewModel:[MSFSelectKeyValues getSelectKeys:fileName]];
    MSFSelectionViewController *selectionViewController = [[MSFSelectionViewController alloc] initWithViewModel:viewModel];
    selectionViewController.title = title;
    [self.navigationController pushViewController:selectionViewController animated:YES];
    @weakify(selectionViewController)
    [selectionViewController.selectedSignal subscribeNext:^(MSFSelectKeyValues *selectValue) {
      @strongify(selectionViewController)
      [selectionViewController.navigationController popViewControllerAnimated:YES];
      [self.viewModel.relationViewModel setValue:selectValue forKey:key];
    }];
  }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  [segue.destinationViewController bindViewModel:self.viewModel];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  if (section == 0) {
    return 0.1;
  }
  if (section == 2) {
    self.tableView.sectionHeaderHeight = _addFamilyBT.selected ? 30 : 0;
    [self hiddenFamilyView:!_addFamilyBT.selected];
    
    return _addFamilyBT.selected ? 30 : 0;
  }
  if (section == 4) {
    
    self.tableView.sectionHeaderHeight = _addOtherBT.selected ? 30 : 0;
    [self hiddenOtherView:!_addOtherBT.selected];
    
    return _addOtherBT.selected ? 30 : 0;
  }
  else {
    return 30;
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
  
  return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 1) {
    if (indexPath.row == 4) {
      if ([_isSameCurrentSW isOn] == YES) {
        self.diffCurrentTF.hidden = YES;
        return 0;
      }
      else {
        self.diffCurrentTF.hidden = NO;
        return 44;
      }
    }
    
  }
  if (indexPath.section == 2 ) {
    if (indexPath.row == 4) {
      if ([_num2IsSameCurrentSW isOn] == YES) {
        self.num2DiffCurrentTF.hidden = YES;
        return 0;
      }
      else {
        self.num2DiffCurrentTF.hidden = NO;
        return 44;
      }
    }
  }
  
  if (indexPath.section == 2) {
    [self hiddenFamilyView:!_addFamilyBT.selected];
    return _addFamilyBT.selected ? 44 : 0;
    
  }
  if (indexPath.section == 4) {
    [self hiddenOtherView:!_addOtherBT.selected];
    return _addOtherBT.selected ? 44 : 0;
  }
  else {
    return 44;
  }
  
}

//添加第二家庭成员
- (IBAction)addFamilyMember:(id)sender {
  
  _addFamilyBT.selected = !_addFamilyBT.selected;
  
  if (_addFamilyBT.selected) {
    self.tableView.sectionHeaderHeight = 30;
    [_addFamilyBT setTitle:@"-删除第二位家庭成员" forState:UIControlStateNormal];
  }
  else {
    self.tableView.sectionHeaderHeight = 0;
    [_addFamilyBT setTitle:@"✚增加第二位家庭成员" forState:UIControlStateNormal];
  }
  [self.tableView reloadData];
}

//添加第二其他联系人
- (IBAction)addOtherContact:(id)sender {
  
  _addOtherBT.selected = !_addOtherBT.selected;
  
  if (_addOtherBT.selected) {
    self.tableView.sectionHeaderHeight = 30;
    [_addOtherBT setTitle:@"-删除第二位其他联系人" forState:UIControlStateNormal];
  }
  else {
    self.tableView.sectionHeaderHeight = 0;
    [_addOtherBT setTitle:@"✚增加第二位其他联系人" forState:UIControlStateNormal];
  }
  
  [self.tableView reloadData];
}

//家庭成员同地址开关
- (IBAction)isSameCurrent:(id)sender {
  
  [self.tableView reloadData];
}

- (IBAction)num2IsSameCurrent:(id)sender {
  
  [self.tableView reloadData];
}

//隐藏第二家庭成员
- (void)hiddenFamilyView:(BOOL)isHidden {
  
  [_num2FamilyNameTF setHidden:isHidden];
  [_num2RelationBT setHidden:isHidden];
  [_num2RelationTF setHidden:isHidden];
  [_num2TelTF setHidden:isHidden];
  [_num2IsSameCurrentSW setHidden:isHidden];
  [_num2DiffCurrentTF setHidden:isHidden];
  [_num2FamilyLable setHidden:isHidden];
  [_num2RelationLabel setHidden:isHidden];
  [_num2FamilyPhone setHidden:isHidden];
  [_num2IsSameAddressLabel setHidden:isHidden];
}

//隐藏第二其他联系人
- (void)hiddenOtherView:(BOOL)isHidden {
  
  [_num2_otherNameTF setHidden:isHidden];
  [_num2_otherRelationBT setHidden:isHidden];
  [_num2_otherRelationTF setHidden:isHidden];
  [_num2_otherTelTF setHidden:isHidden];
  [_num2OtherNameLabel setHidden:isHidden];
  [_num2OtherRelationLabel setHidden:isHidden];
  [_num2OtherPhoneLabel setHidden:isHidden];
}

@end