//
//  MSFAppliesIncomeTableViewController.m
//  Cash
//
//  Created by xbm on 15/5/23.
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFPersonalViewController.h"
#import <FMDB/FMDatabase.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/extobjc.h>
#import <ActionSheetPicker-3.0/ActionSheetPicker.h>
#import "NSDateFormatter+MSFFormattingAdditions.h"
#import <MTLFMDBAdapter/MTLFMDBAdapter.h>
#import <RMPickerViewController/RMPickerViewController.h>
#import "MSFAreas.h"
#import "MSFApplyStartViewModel.h"
#import "MSFApplyInfo.h"
#import "MSFApplyCash.h"
#import "MSFProgressHUD.h"
#import "MSFSelectionViewModel.h"
#import "MSFSelectionViewController.h"
#import "NSString+Matches.h"

@interface MSFPersonalViewController () <UITextFieldDelegate>

@property(weak,nonatomic) NSArray *adressArray;
@property(weak, nonatomic) IBOutlet UIButton *nextPageBT;
@property(weak, nonatomic) IBOutlet UISegmentedControl *selectQQorJDSegment;
@property(weak, nonatomic) IBOutlet UITableViewCell *userNameCell;
@property(weak, nonatomic) IBOutlet UILabel *userNameLB;
@property(weak, nonatomic) IBOutlet UILabel *userPasswordLB;
@property(nonatomic,strong) NSMutableArray *provinceArray;
@property(nonatomic,strong) NSMutableArray *cityArray;
@property(nonatomic,strong) NSMutableArray *countryArray;

@property(nonatomic,strong) FMDatabase *fmdb;

@property(nonatomic,strong) MSFApplyStartViewModel *viewModel;
@property(nonatomic,strong) MSFApplyCash *applyCash;

@end

@implementation MSFPersonalViewController

#pragma mark - MSFReactiveView

- (void)bindViewModel:(MSFApplyStartViewModel *)viewModel {
  self.viewModel = viewModel;
}

#pragma mark - Lifecycle

- (void)dealloc {
  NSLog(@"MSFAppliesIncomeTableViewController `-dealloc`");
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  [segue.destinationViewController bindViewModel:self.viewModel];
}

- (void)viewWillAppear:(BOOL)animated {
  self.viewModel.applyInfoModel.page = @"2";
  self.viewModel.applyInfoModel.applyStatus1 = @"0";
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"基本信息";
  self.edgesForExtendedLayout = UIRectEdgeNone;
  [self selectQQorJD];
  
  RACChannelTerminal *incomeChannel = RACChannelTo(self.viewModel, applyInfoModel.income);
  RAC(self.monthInComeTF, text) = incomeChannel;
  [self.monthInComeTF.rac_textSignal subscribe:incomeChannel];
  [[self.monthInComeTF rac_signalForControlEvents:UIControlEventEditingChanged]
   subscribeNext:^(UITextField *textField) {
     if (textField.text.intValue > 100000) {
       textField.text = [NSString stringWithFormat:@"%d",textField.text.intValue/10];
     }
   }];
  [[self.repayMonthTF rac_signalForControlEvents:UIControlEventEditingChanged]
   subscribeNext:^(UITextField *textField) {
     if (textField.text.intValue > 1000000) {
       textField.text = [NSString stringWithFormat:@"%d",textField.text.intValue/10];
     }
   }];
  [[self.familyOtherIncomeYF rac_signalForControlEvents:UIControlEventEditingChanged]
   subscribeNext:^(UITextField *textField) {
     if (textField.text.intValue > 100000) {
       textField.text = [NSString stringWithFormat:@"%d",textField.text.intValue/10];
     }
   }];
  
  RACChannelTerminal *familyExpenseChannel = RACChannelTo(self.viewModel,applyInfoModel.familyExpense);
  RAC(self.repayMonthTF,text) = familyExpenseChannel;
  [self.repayMonthTF.rac_textSignal subscribe:familyExpenseChannel];
  
  RACChannelTerminal *otherIncomeChannel = RACChannelTo(self.viewModel,applyInfoModel.otherIncome);
  RAC(self.familyOtherIncomeYF,text) = otherIncomeChannel;
  [self.familyOtherIncomeYF.rac_textSignal subscribe:otherIncomeChannel];
  
  RACChannelTerminal *homecodeChannel = RACChannelTo(self.viewModel,applyInfoModel.homeCode);
  RAC(self.homeLineCodeTF,text) = homecodeChannel;
  [self.homeLineCodeTF.rac_textSignal subscribe:homecodeChannel];
  
  RACChannelTerminal *hometelephoneChannel = RACChannelTo(self.viewModel,applyInfoModel.homeLine);
  RAC(self.homeTelTF,text) = hometelephoneChannel;
  [self.homeTelTF.rac_textSignal subscribe:hometelephoneChannel];
  
  RACChannelTerminal *emailChannel = RACChannelTo(self.viewModel,applyInfoModel.email);
  RAC(self.emailTF,text) = emailChannel;
  [self.emailTF.rac_textSignal subscribe:emailChannel];
  
  RACChannelTerminal *townChannel = RACChannelTo(self.viewModel,applyInfoModel.currentTown);
  RAC(self.townTF,text) = townChannel;
  [self.townTF.rac_textSignal subscribe:townChannel];
  
  RACChannelTerminal *streetChannel = RACChannelTo(self.viewModel,applyInfoModel.currentStreet);
  RAC(self.currentStreetTF,text) = streetChannel;
  [self.currentStreetTF.rac_textSignal subscribe:streetChannel];
  
  RACChannelTerminal *communityChannel = RACChannelTo(self.viewModel,applyInfoModel.currentCommunity);
  RAC(self.currentCommunityTF,text) = communityChannel;
  [self.currentCommunityTF.rac_textSignal subscribe:communityChannel];
  
  RACChannelTerminal *apartmentChannel = RACChannelTo(self.viewModel,applyInfoModel.currentApartment);
  RAC(self.currentApartmentTF,text) = apartmentChannel;
  [self.currentApartmentTF.rac_textSignal subscribe:apartmentChannel];
  
  RAC(self.provinceTF,text) = [RACSignal combineLatest:@[
    RACObserve(self.viewModel, province),
    RACObserve(self.viewModel, city),
    RACObserve(self.viewModel, area),
    ]
   reduce:^id(MSFAreas *province,MSFAreas *city ,MSFAreas *area) {
     return [NSString stringWithFormat:@"%@ %@ %@",province.name?:@"省/直辖市",city.name?:@"市",area.name?:@"区"];
  }];
  NSString *path = [[NSBundle mainBundle] pathForResource:@"dicareas" ofType:@"db"];
  self.fmdb = [FMDatabase databaseWithPath:path];
   @weakify(self)
  [[self.selectAreasBT rac_signalForControlEvents:UIControlEventTouchUpInside]
  subscribeNext:^(id x) {
    @strongify(self)
    [self.view endEditing:YES];
    [self showSelectedViewController];
  }];
  
  [[[self.viewModel.applyInfoModel rac_valuesForKeyPath:@"qq" observer:self.userNameCell] takeUntil:[self.userNameCell rac_prepareForReuseSignal]]
   subscribeNext:^(NSString *text) {
     @strongify(self);
     self.otherUserNameTF.text = text;
   }];
  [[[self.otherUserNameTF rac_textSignal] takeUntil:[self.userNameCell rac_prepareForReuseSignal]]
   subscribeNext:^(NSString *text) {
     @strongify(self);
     [self.viewModel.applyInfoModel setValue:text forKey:@"qq"];
   }];
  [RACChannelTo(self.provinceTF,text) subscribeNext:^(id x) {
    @strongify(self)
    for (int i = 0; i<self.adressArray.count; i++) {
      NSInteger row = [self.adressArray[i] integerValue];
      switch (i) {
        case 0:
          if (row<self.provinceArray.count) {
            self.viewModel.applyInfoModel.currentProvinceCode = ((MSFAreas *)self.provinceArray[row]).codeID;
            self.viewModel.applyInfoModel.currentProvince = ((MSFAreas *)self.provinceArray[row]).name;
          }
          break;
        case 1:
          if (row<self.cityArray.count) {
            self.viewModel.applyInfoModel.currentCityCode = ((MSFAreas *)self.cityArray[row]).codeID;
            self.viewModel.applyInfoModel.currentCity = ((MSFAreas *)self.cityArray[row]).name;
          }
          break;
        case 2:
          if (row<self.countryArray.count) {
            self.viewModel.applyInfoModel.currentCountryCode = ((MSFAreas *)self.countryArray[row]).codeID;
            self.viewModel.applyInfoModel.currentCountry = ((MSFAreas *)self.countryArray[row]).name;
            
          }
          break;
        default:
          break;
      }
    }
  }];
  
  self.nextPageBT.rac_command = self.viewModel.executeBasic;
  [self.viewModel.executeBasic.executionSignals subscribeNext:^(RACSignal *execution) {
    @strongify(self)
    [MSFProgressHUD showStatusMessage:@"正在提交..." inView:self.navigationController.view];
    [execution subscribeNext:^(id x) {
      [MSFProgressHUD hidden];
      self.applyCash = x;
      UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"professional" bundle:nil];
      UIViewController <MSFReactiveView> *vc = storyboard.instantiateInitialViewController;
      [vc bindViewModel:self.viewModel];
      [self.navigationController pushViewController:vc animated:YES];
    }];
  }];
  [self.viewModel.executeBasic.errors subscribeNext:^(NSError *error) {
    @strongify(self)
    [MSFProgressHUD showErrorMessage:error.userInfo[NSLocalizedFailureReasonErrorKey] inView:self.navigationController.view];
  }];
  
//  [[self.emailTF rac_signalForControlEvents:UIControlEventEditingDidBegin]
//   subscribeNext:^(UITextField *textField) {
//     textField.textColor = [UIColor blackColor];
//   }];
  [[self.emailTF rac_signalForControlEvents:UIControlEventEditingDidEnd]
   subscribeNext:^(UITextField *textField) {
     if (![textField.text isMail]) {
       textField.textColor = [UIColor redColor];
     }
     else {
       textField.textColor = [UIColor blackColor];
     }
   }];
  [[self.homeLineCodeTF rac_signalForControlEvents:UIControlEventEditingChanged]
   subscribeNext:^(UITextField *textField) {
     if (textField.text.length > 4 ) {
       textField.text = [textField.text substringToIndex:4];
     }
   }];
  [[self.homeLineCodeTF rac_signalForControlEvents:UIControlEventEditingDidBegin]
   subscribeNext:^(UITextField *textField) {
     @strongify(self)
     textField.textColor = [UIColor blackColor];
     self.homeLineCodeTF.textColor = [UIColor blackColor];
   }];
  [[self.homeTelTF rac_signalForControlEvents:UIControlEventEditingChanged]
   subscribeNext:^(UITextField *textField) {
     if (textField.text.length > 8) {
       textField.text = [textField.text substringToIndex:8];
     }
   }];
  [[self.homeTelTF rac_signalForControlEvents:UIControlEventEditingDidEnd]
   subscribeNext:^(UITextField *textField) {
     @strongify(self)
     if (![[self.homeLineCodeTF.text stringByAppendingString:textField.text] isTelephone]) {
       textField.textColor = [UIColor redColor];
       self.homeLineCodeTF.textColor = [UIColor redColor];
     }
     else {
       textField.textColor = [UIColor blackColor];
       self.homeLineCodeTF.textColor = [UIColor blackColor];
     }
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

#pragma mark - Private

- (void)selectQQorJD {
  @weakify(self)
  [[self.selectQQorJDSegment rac_newSelectedSegmentIndexChannelWithNilValue:nil]
  subscribeNext:^(id x) {
    @strongify(self)
    switch ([x integerValue]) {
      case 0:
      {
        self.taobaoOrJDPasswordCell.hidden = YES;
        self.userNameLB.text = @"QQ号";
        self.otherUserNameTF.placeholder = @"请输入QQ号";
        self.userPasswordLB.text = @"QQ密码";
        @weakify(self)
        [[[self.viewModel.applyInfoModel rac_valuesForKeyPath:@"qq" observer:self.userNameCell] takeUntil:[self.userNameCell rac_prepareForReuseSignal]]
         subscribeNext:^(NSString *text) {
           @strongify(self);
           self.otherUserNameTF.text = text;
         }];
        [[[self.otherUserNameTF rac_textSignal] takeUntil:[self.userNameCell rac_prepareForReuseSignal]]
         subscribeNext:^(NSString *text) {
           @strongify(self);
           [self.viewModel.applyInfoModel setValue:text forKey:@"qq"];
         }];
      }
        break;
      case 1:
      {
        self.taobaoOrJDPasswordCell.hidden = NO;
        self.userNameLB.text = @"淘宝账号";
        self.userPasswordLB.text = @"淘宝密码";
        self.otherUserNameTF.placeholder = @"请输入淘宝账号";
        self.otherPasswordTF.placeholder = @"请输入淘宝密码";
        @weakify(self)
        [[[self.viewModel.applyInfoModel rac_valuesForKeyPath:@"taobao" observer:self.userNameCell] takeUntil:[self.userNameCell rac_prepareForReuseSignal]]
         subscribeNext:^(NSString *text) {
           @strongify(self);
           self.otherUserNameTF.text = text;
         }];
        [[[self.otherUserNameTF rac_textSignal] takeUntil:[self.userNameCell rac_prepareForReuseSignal]]
         subscribeNext:^(NSString *text) {
           @strongify(self);
           [self.viewModel.applyInfoModel setValue:text forKey:@"taobao"];
         }];
        [[[self.viewModel.applyInfoModel rac_valuesForKeyPath:@"taobaoPassword" observer:self.taobaoOrJDPasswordCell] takeUntil:[self.taobaoOrJDPasswordCell rac_prepareForReuseSignal]]
         subscribeNext:^(NSString *text) {
           @strongify(self);
           self.otherPasswordTF.text = text;
         }];
        [[[self.otherPasswordTF rac_textSignal] takeUntil:[self.taobaoOrJDPasswordCell rac_prepareForReuseSignal]]
         subscribeNext:^(NSString *text) {
           @strongify(self);
           [self.viewModel.applyInfoModel setValue:text forKey:@"taobaoPassword"];
         }];
      }
        break;
      case 2:
      {
        self.taobaoOrJDPasswordCell.hidden = NO;
        self.userNameLB.text = @"京东账号";
        self.userPasswordLB.text = @"京东密码";
        self.otherUserNameTF.placeholder = @"请输入京东账号";
        self.otherPasswordTF.placeholder = @"请输入京东密码";
        @weakify(self)
        [[[self.viewModel.applyInfoModel rac_valuesForKeyPath:@"jdAccount" observer:self.userNameCell] takeUntil:[self.userNameCell rac_prepareForReuseSignal]]
         subscribeNext:^(NSString *text) {
           @strongify(self);
           self.otherUserNameTF.text = text;
         }];
        [[[self.otherUserNameTF rac_textSignal] takeUntil:[self.userNameCell rac_prepareForReuseSignal]]
         subscribeNext:^(NSString *text) {
           @strongify(self);
           [self.viewModel.applyInfoModel setValue:text forKey:@"jdAccount"];
         }];
        [[[self.viewModel.applyInfoModel rac_valuesForKeyPath:@"jdAccountPwd" observer:self.taobaoOrJDPasswordCell] takeUntil:[self.taobaoOrJDPasswordCell rac_prepareForReuseSignal]]
         subscribeNext:^(NSString *text) {
           @strongify(self);
           self.otherPasswordTF.text = text;
         }];
        [[[self.otherPasswordTF rac_textSignal] takeUntil:[self.taobaoOrJDPasswordCell rac_prepareForReuseSignal]]
         subscribeNext:^(NSString *text) {
           @strongify(self);
           [self.viewModel.applyInfoModel setValue:text forKey:@"jdAccountPwd"];
         }];
      }
        break;
        
      default:
        break;
    }
  }];
}

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
    self.viewModel.province = nil;
    self.viewModel.city = nil;
    self.viewModel.area = nil;
    self.viewModel.province = province;
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
      self.viewModel.city = city;
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
        self.viewModel.area = x;
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
  self.provinceArray = regions;
  for (MSFAreas *area in self.provinceArray) {
    
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
  [self.fmdb close];
  
  return self.provinceArray;
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
  self.cityArray = regions;
  [self.fmdb close];
  return self.cityArray;
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
  self.countryArray = regions;
  [self.fmdb close];
  
  return self.countryArray;
}

@end
