//
//  MSFSubmitTableViewController.m
//  Cash
//
//  Created by xbm on 15/5/23.
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFSubmitTableViewController.h"
#import "MSFApplyStartViewModel.h"
#import "MSFApplyCash.h"
#import <libextobjc/extobjc.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFSelectKeyValues.h"
#import "MSFApplyInfo.h"
#import "MSFProgressHUD.h"
#import "MSFUtils.h"
#import "MSFSelectionViewModel.h"
#import "MSFSelectionViewController.h"
#import "MSFProductViewModel.h"
#import "MSFSubmitViewModel.h"
#import <CZPhotoPickerController/CZPhotoPickerController.h>
#import "MSFClient+MSFPhotoStatus.h"
#import "MSFPhotoStatus.h"
#import "MSFCheckEmployee.h"

@interface MSFSubmitTableViewController ()

@property(nonatomic,strong) MSFPhotoStatus *whitePhoto;
@property(nonatomic,copy) NSURL *handPhotoURL;
@property(nonatomic,copy) NSURL *ownerPhtoURL;
@property(nonatomic,strong) CZPhotoPickerController *photoPickerViewController;
@property(nonatomic,strong) MSFApplyCash *applyCash;
@property(nonatomic,strong) NSMutableArray *pickerArray;
@property(nonatomic,strong) MSFApplyStartViewModel *viewModel;
@property(weak,nonatomic) IBOutlet UITextField *bankNameTF;
@property(weak,nonatomic) IBOutlet UIButton *bankNameBT;
@property(weak,nonatomic) IBOutlet UITextField *bankCardNumTF;
@property(weak,nonatomic) IBOutlet UIButton *submitBT;
@property(weak,nonatomic) IBOutlet UIButton *handPhotoBT;
@property(weak,nonatomic) IBOutlet UIButton *cardPhotoBT;
@property(weak,nonatomic) IBOutlet NSLayoutConstraint *photoConstraint;
@property(weak,nonatomic) IBOutlet UITextField *bankAreaTF;
@property(weak,nonatomic) IBOutlet UIButton *bankAreaBT;

@end

@implementation MSFSubmitTableViewController

- (void)bindViewModel:(id)viewModel {
  self.viewModel = viewModel;
}

- (void)viewWillAppear:(BOOL)animated {
  self.viewModel.applyInfoModel.page = @"5";
  self.viewModel.applyInfoModel.applyStatus1 = @"1";
}

- (void)viewDidLoad {
    [super viewDidLoad];
  self.title = @"提交申请";
  self.tableView.backgroundColor = [UIColor whiteColor];
 // [self showPickers];
  RAC(self.bankNameTF,text) = [[RACObserve(self.viewModel.submitViewModel, bankName) ignore:nil]
      map:^id(MSFSelectKeyValues *value) {
         return value.text;
     }];
  [[self.bankNameBT rac_signalForControlEvents:UIControlEventTouchUpInside]
  subscribeNext:^(id x) {
    [self.view endEditing:YES];
    MSFSelectionViewModel *viewModel = [MSFSelectionViewModel selectKeyValuesViewModel:[MSFSelectKeyValues getSelectKeys:@"json_banks"]];
    MSFSelectionViewController *selectViewController = [[MSFSelectionViewController alloc] initWithViewModel:viewModel];
    selectViewController.title = @"选择银行";
    [self.navigationController pushViewController:selectViewController animated:YES];
    
    [selectViewController.selectedSignal subscribeNext:^(MSFSelectKeyValues *selectValue) {
      [selectViewController.navigationController popViewControllerAnimated:YES];
      self.viewModel.submitViewModel.bankName = selectValue;
    }];
  }];
  
  RACChannelTerminal *bankNumChannel = RACChannelTo(self.viewModel,submitViewModel.bankCardNum);
  RAC(self.bankCardNumTF,text) = bankNumChannel;
  [self.bankCardNumTF.rac_textSignal subscribe:bankNumChannel];
  @weakify(self)
  [[self.handPhotoBT rac_signalForControlEvents:UIControlEventTouchUpInside]
   subscribeNext:^(id x) {
     @strongify(self)
     self.photoPickerViewController = [[CZPhotoPickerController alloc] initWithPresentingViewController:self withCompletionBlock:^(UIImagePickerController *imagePickerController, NSDictionary *imageInfoDict) {
       [self.photoPickerViewController dismissAnimated:YES];
       UIImage *image = imageInfoDict[UIImagePickerControllerEditedImage];
       if (!image) {
         return ;
       }
       [self.handPhotoBT setImage:image forState:UIControlStateNormal];
       NSData *data = UIImageJPEGRepresentation(image, 0.8);
       NSString *file = [[@([[NSDate date] timeIntervalSince1970]) stringValue] stringByAppendingString:@".jpg"];
       NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:file];
       [data writeToFile:path atomically:YES];
       self.handPhotoURL = [NSURL fileURLWithPath:path];
       
      }];
     [self.photoPickerViewController showFromRect:CGRectZero];
  }];
  [[self.cardPhotoBT rac_signalForControlEvents:UIControlEventTouchUpInside]
   subscribeNext:^(id x) {
     @strongify(self)
     self.photoPickerViewController = [[CZPhotoPickerController alloc] initWithPresentingViewController:self withCompletionBlock:^(UIImagePickerController *imagePickerController, NSDictionary *imageInfoDict) {
       [self.photoPickerViewController dismissAnimated:YES];
       UIImage *image = imageInfoDict[UIImagePickerControllerEditedImage];
       if (!image) {
         return ;
       }
       [self.cardPhotoBT setImage:image forState:UIControlStateNormal];
       NSData *data = UIImageJPEGRepresentation(image, 0.8);
       NSString *file = [[@([[NSDate date] timeIntervalSince1970]) stringValue] stringByAppendingString:@".jpg"];
       NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:file];
       [data writeToFile:path atomically:YES];
       self.ownerPhtoURL = [NSURL fileURLWithPath:path];
       
     }];
     [self.photoPickerViewController showFromRect:CGRectZero];
   }];
  
  self.submitBT.rac_command = self.viewModel.submitViewModel.executeRequest;
  
  
  if (self.viewModel.checkEmployee.white) {
//    RAC(self,whitePhoto) = [[[[MSFUtils.httpClient updateBankCardAvatarWithFileURL:self.handPhotoURL ownURL:self.ownerPhtoURL] catch:^RACSignal *(NSError *error) {
//      @strongify(self)
//      [MSFProgressHUD showErrorMessage:error.userInfo[NSLocalizedFailureReasonErrorKey] inView:self.navigationController.view];
//      return [RACSignal return:nil];
//    }]
//                             ignore:nil]
//                            map:^id(id value) {
//                              return value;
//                            }];
    [[self.viewModel.submitViewModel.executeRequest.executionSignals doNext:^(id x) {
      
      self.submitBT.enabled = NO;
    }] subscribeNext:^(RACSignal *signal) {
      @strongify(self)
      if (self.handPhotoURL == nil && self.ownerPhtoURL == nil ) {
        return ;
      }
      [[[[[MSFUtils.httpClient updateBankCardAvatarWithFileURL:self.handPhotoURL ownURL:self.ownerPhtoURL] catch:^RACSignal *(NSError *error) {
        
        [MSFProgressHUD showErrorMessage:error.userInfo[NSLocalizedFailureReasonErrorKey] inView:self.navigationController.view];
        return [RACSignal return:nil];
      }]
         ignore:nil]
        flattenMap:^RACStream *(id value) {
          self.viewModel.applyInfoModel.whitePhoto = value;
          return signal;
        }] subscribeNext:^(id x) {
          self.applyCash = x;
          self.viewModel.applyInfoModel.loanId = self.applyCash.applyID;
          self.viewModel.applyInfoModel.personId = self.applyCash.personId;
          self.viewModel.applyInfoModel.applyNo = self.applyCash.applyNo;
         // NSLog(@"%@",x);
        }
       error:^(NSError *error) {
        [MSFProgressHUD showErrorMessage:error.userInfo[NSLocalizedFailureReasonErrorKey] inView:self.navigationController.view];
      }];
    }];
  }
  else {
    self.photoConstraint.constant = 0;
    [[self.viewModel.submitViewModel.executeRequest.executionSignals doNext:^(id x) {
      self.submitBT.enabled = NO;
    }] subscribeNext:^(RACSignal *execution) {
      @strongify(self)
      [execution subscribeNext:^(id x) {
        self.applyCash = x;
        self.viewModel.applyInfoModel.loanId = self.applyCash.applyID;
        self.viewModel.applyInfoModel.personId = self.applyCash.personId;
        self.viewModel.applyInfoModel.applyNo = self.applyCash.applyNo;
        NSLog(@"%@",x);
      }];
      //NSLog(@"hahahah");
    }];
    [self.viewModel.submitViewModel.executeRequest.errors subscribeNext:^(NSError *error) {
      //NSLocalizedFailureReasonErrorKey
      @strongify(self)
      [MSFProgressHUD showErrorMessage:error.userInfo[NSLocalizedFailureReasonErrorKey] inView:self.navigationController.view];
    }];
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return 0.1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  
}

@end
