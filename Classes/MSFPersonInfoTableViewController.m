//
//  MSFPersonInfoTableViewController.m
//  Cash
//
//  Created by xbm on 15/5/23.
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFPersonInfoTableViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <RMPickerViewController/RMPickerViewController.h>
#import <ActionSheetPicker-3.0/ActionSheetDatePicker.h>
#import "MSFSelectKeyValues.h"
#import "MSFApplyStartViewModel.h"
#import "MSFApplyInfo.h"
#import <libextobjc/extobjc.h>
#import "NSDateFormatter+MSFFormattingAdditions.h"
#import "MSFAreas.h"
#import <FMDB/FMDatabase.h>
#import "MSFApplyCash.h"
#import "MSFProgressHUD.h"
#import "MSFAFCareerViewModel.h"
#import "MSFSelectionViewModel.h"
#import "MSFSelectionViewController.h"

@interface MSFPersonInfoTableViewController () {
  NSArray *_dataArray;
  RMPickerViewController *_edutePickerViewController;
  RMPickerViewController *_socailStatusPickerViewController;
  RMPickerViewController *_workYearsPickerViewController;
  RMPickerViewController *_jodTypePickerViewController;
  RMPickerViewController *_zhiweiPickerViewController;
  RMPickerViewController *_workDatePickerViewController;
  RMPickerViewController *_workAdressPickerViewController;
}

@property(strong,nonatomic) NSArray *adressArray;
@property(strong,nonatomic) NSMutableArray *pickerArray;
@property(strong,nonatomic) FMDatabase *fmdb;
@property(nonatomic,strong) NSMutableArray *provinceArray;
@property(nonatomic,strong) NSMutableArray *cityArray;
@property(nonatomic,strong) NSMutableArray *countryArray;

@property(weak,nonatomic) IBOutlet UIButton *educationBT;
@property(weak,nonatomic) IBOutlet UITextField *educationTF;
@property(weak,nonatomic) IBOutlet UIButton *cardTypeBT;
@property(weak,nonatomic) IBOutlet UITextField *cardTypeTF;
@property(weak,nonatomic) IBOutlet UIButton *jobYearsBT;
@property(weak,nonatomic) IBOutlet UITextField *jobYeasTF;
@property(weak,nonatomic) IBOutlet UITextField *companyNameTF;
@property(weak,nonatomic) IBOutlet UIButton *industryTypeBT;
@property(weak,nonatomic) IBOutlet UITextField *industryTypeTF;
@property(weak,nonatomic) IBOutlet UIButton *positionBT;
@property(weak,nonatomic) IBOutlet UITextField *posiotionTF;
@property(weak,nonatomic) IBOutlet UITextField *jobTimeTF;
@property(weak,nonatomic) IBOutlet UIButton *jobTimeBT;
@property(weak,nonatomic) IBOutlet UITextField *areaCodeTF;
@property(weak,nonatomic) IBOutlet UITextField *telTF;
@property(weak,nonatomic) IBOutlet UITextField *extensionTF;
@property(weak,nonatomic) IBOutlet UITextField *compneyAreasTF;
@property(weak,nonatomic) IBOutlet UITextField *companyAdressTF;//公司详细地址
@property(weak,nonatomic) IBOutlet UIButton *companyProvinceBT;
@property(weak,nonatomic) IBOutlet UITableViewCell *positionCell;
@property(weak, nonatomic) IBOutlet UIButton *nextPageBT;
@property(strong,nonatomic) MSFApplyStartViewModel *viewModel;
@property(copy,nonatomic) NSString *educate;
@property(copy,nonatomic) NSString *socal;
@property(strong,nonatomic) MSFApplyCash *applyCash;
@property(weak,nonatomic) IBOutlet UIButton *natureBT;
@property(weak,nonatomic) IBOutlet UITextField *natureTF;
@property(weak,nonatomic) IBOutlet UIButton *compneyAreasBT;

@end

@implementation MSFPersonInfoTableViewController

#pragma mark - MSFReactiveView

- (void)bindViewModel:(id)viewModel {
  self.viewModel = viewModel;
}

#pragma mark - Lifecycle

- (void)viewWillAppear:(BOOL)animated {
  self.viewModel.applyInfoModel.page = @"3";
  self.viewModel.applyInfoModel.applyStatus1 = @"0";
}

- (void)bindTitle:(id)titleDict {
  self.educate = [titleDict objectForKey:@"eduacte"];
  self.socal = [titleDict objectForKey:@"socal"];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"在职人员";
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
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  [segue.destinationViewController bindViewModel:self.viewModel];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - Private

- (void)showSelectedViewController {
  MSFSelectionViewModel *provinceViewModel = [MSFSelectionViewModel areaViewModel:self.provinces];
  MSFSelectionViewController *provinceViewController = [[MSFSelectionViewController alloc] initWithViewModel:provinceViewModel];
  provinceViewController.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  provinceViewController.title = @"中国";
  [self.navigationController pushViewController:provinceViewController animated:YES];
  
  @weakify(self)
  @weakify(provinceViewController)
  [provinceViewController.selectedSignal subscribeNext:^(MSFAreas *province) {
    @strongify(self)
    self.viewModel.careerViewModel.province = nil;
    self.viewModel.careerViewModel.city = nil;
    self.viewModel.careerViewModel.area = nil;
    self.viewModel.careerViewModel.province = province;
    NSArray *items = [self citiesWithProvince:province];
    if (items.count == 0) {
      @strongify(provinceViewController)
      [provinceViewController.navigationController popToViewController:self animated:YES];
      return;
    }
    MSFSelectionViewModel *citiesViewModel = [MSFSelectionViewModel areaViewModel:items];
    MSFSelectionViewController *citiesViewController = [[MSFSelectionViewController alloc] initWithViewModel:citiesViewModel];
    citiesViewController.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    citiesViewController.title = province.name;
    [self.navigationController pushViewController:citiesViewController animated:YES];
    
    @weakify(citiesViewController)
    [citiesViewController.selectedSignal subscribeNext:^(MSFAreas *city) {
      self.viewModel.careerViewModel.city = city;
      NSArray *items = [self areasWitchCity:city];
      if (items.count == 0) {
        @strongify(citiesViewController)
        [citiesViewController.navigationController popToViewController:self animated:YES];
        return;
      }
      MSFSelectionViewModel *areasViewModel = [MSFSelectionViewModel areaViewModel:[self areasWitchCity:city]];
      MSFSelectionViewController *areasViewController = [[MSFSelectionViewController alloc] initWithViewModel:areasViewModel];
      areasViewController.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
      areasViewController.title = city.name;
      [self.navigationController pushViewController:areasViewController animated:YES];
      
      @weakify(areasViewController)
      [areasViewController.selectedSignal subscribeNext:^(id x) {
        self.viewModel.careerViewModel.area = x;
        @strongify(areasViewController)
        [areasViewController.navigationController popToViewController:self animated:YES];
      }];
    }];
  }];
}

#pragma mark - Custom Accessors

- (NSArray *)provinces {
  if (![self.fmdb open]) {
    return nil;
  }
  NSError *error;
  NSMutableArray *regions = [NSMutableArray array];
  FMResultSet *s = [self.fmdb executeQuery:@"select * from basic_dic_area where parent_area_code='000000'"];
  while ([s next]) {
    MSFAreas *areas = [MTLFMDBAdapter modelOfClass:MSFAreas.class fromFMResultSet:s error:&error];
    [regions addObject:areas];
    
  }
  [self.fmdb close];
  for (MSFAreas *area in regions) {
    if ([area.codeID isEqualToString:@"500000"]) {
      MSFAreas *tempArea = [[MSFAreas alloc] init];
      tempArea.name = area.name;
      tempArea.codeID = area.codeID;
      tempArea.parentCodeID = area.parentCodeID;
      [self.provinceArray removeObject:area];
      [self.provinceArray insertObject:tempArea atIndex:1];
      break;
    }
  }
  return regions;
}

- (NSArray *)citiesWithProvince:(MSFAreas *)province {
  [self.fmdb open];
  NSError *error;
  NSMutableArray *regions = [NSMutableArray array];
  FMResultSet *rs = [self.fmdb executeQuery:[NSString stringWithFormat:@"select * from basic_dic_area where parent_area_code='%@'",province.codeID]];
  while ([rs next]) {
    MSFAreas *areas = [MTLFMDBAdapter modelOfClass:MSFAreas.class fromFMResultSet:rs error:&error];
    [regions addObject:areas];
  }
  [self.fmdb close];
  return regions;
}

- (NSArray *)areasWitchCity:(MSFAreas *)city {
  [self.fmdb open];
  NSError *error;
  NSMutableArray *regions = [NSMutableArray array];
  FMResultSet *rs = [self.fmdb executeQuery:[NSString stringWithFormat:@"select * from basic_dic_area where parent_area_code='%@'",city.codeID]];
  while ([rs next]) {
    MSFAreas *areas = [MTLFMDBAdapter modelOfClass:MSFAreas.class fromFMResultSet:rs error:&error];
    [regions addObject:areas];
  }
  [self.fmdb close];
  
  return regions;
}

@end
