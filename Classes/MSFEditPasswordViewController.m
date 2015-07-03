//
// MSFEditUserinfoViewController.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFEditPasswordViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/extobjc.h>
#import "MSFUserViewModel.h"
#import "MSFProgressHUD.h"
#import "MSFUtils.h"

@interface MSFEditPasswordViewController ()
@property(nonatomic,weak) IBOutlet UITextField *passoword1;
@property(nonatomic,weak) IBOutlet UITextField *passoword2;
@property(nonatomic,weak) IBOutlet UIButton *button;
@property(nonatomic,strong) MSFUserViewModel *viewModel;

@property(nonatomic,weak) IBOutlet UISwitch *password1Swith;
@property(nonatomic,weak) IBOutlet UISwitch *password2Swith;

@end

@implementation MSFEditPasswordViewController

#pragma mark - Lifecycle

- (void)dealloc {
  NSLog(@"`dealloc`");
}

- (instancetype)init {
  self = [[UIStoryboard storyboardWithName:@"login" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass(MSFEditPasswordViewController.class)];
  if (!self) {
    return nil;
  }
  
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"修改密码";
  self.viewModel = [[MSFUserViewModel alloc] initWithClient:MSFUtils.httpClient];
  RAC(self.viewModel,usedPassword) = self.passoword1.rac_textSignal;
  RAC(self.viewModel,updatePassword) = self.passoword2.rac_textSignal;
  self.button.rac_command = self.viewModel.executeUpdatePassword;
  
  @weakify(self)
  [self.viewModel.executeUpdatePassword.executionSignals subscribeNext:^(RACSignal *signal) {
    @strongify(self)
    [self.view endEditing:YES];
    [MSFProgressHUD showStatusMessage:@"正在提交..." inView:self.navigationController.view];
    [signal subscribeNext:^(id x) {
      [MSFProgressHUD showSuccessMessage:@"密码更新成功" inView:self.navigationController.view];
      [self.navigationController popViewControllerAnimated:YES];
    }];
  }];
  [self.viewModel.executeUpdatePassword.errors subscribeNext:^(NSError *error) {
    [self.view endEditing:YES];
    @strongify(self)
    [MSFProgressHUD showErrorMessage:error.userInfo[NSLocalizedFailureReasonErrorKey] inView:self.navigationController.view];
  }];
  
  self.passoword1.clearButtonMode = UITextFieldViewModeNever;
  self.passoword2.clearButtonMode = UITextFieldViewModeNever;
  
  [self.password1Swith.rac_newOnChannel subscribeNext:^(NSNumber *x) {
    @strongify(self)
    NSString *text = self.passoword1.text;
    self.passoword1.text = text;
    [self.passoword1 setSecureTextEntry:!x.boolValue];
  }];
  [self.password2Swith.rac_newOnChannel subscribeNext:^(NSNumber *x) {
    @strongify(self)
    NSString *text = self.passoword2.text;
    self.passoword2.text = text;
    [self.passoword2 setSecureTextEntry:!x.boolValue];
  }];
}

@end
