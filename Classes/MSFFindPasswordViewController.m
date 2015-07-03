//
// MSFFindPasswordViewController.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFFindPasswordViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/extobjc.h>
#import "MSFAuthorizeViewModel.h"
#import "MSFUtils.h"
#import "MSFProgressHUD.h"

@interface MSFFindPasswordViewController ()

@property(nonatomic,weak) IBOutlet UITextField *username;
@property(nonatomic,weak) IBOutlet UITextField *captcha;
@property(nonatomic,weak) IBOutlet UITextField *password;
@property(nonatomic,weak) IBOutlet UIButton *captchaButton;
@property(nonatomic,weak) IBOutlet UIButton *commitButton;
@property(nonatomic,weak) IBOutlet UILabel *counterLabel;
@property(nonatomic,weak) IBOutlet UISwitch *passwordSwith;

@property(nonatomic,strong) MSFAuthorizeViewModel *viewModel;

@end

@implementation MSFFindPasswordViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.username.text = MSFUtils.phone;
  self.viewModel = [[MSFAuthorizeViewModel alloc] init];
  RAC(self.viewModel,username) = self.username.rac_textSignal;
  RAC(self.viewModel,captcha) = self.captcha.rac_textSignal;
  RAC(self.viewModel,password) = self.password.rac_textSignal;
  RAC(self.counterLabel,text) = RACObserve(self.viewModel, counter);
  RAC(self.counterLabel,textColor) =
  [self.viewModel.captchaRequestValidSignal
    map:^id(NSNumber *valid) {
      return valid.boolValue ? UIColor.whiteColor : UIColor.lightGrayColor;
  }];
  @weakify(self)
  self.captchaButton.rac_command = self.viewModel.executeFindPasswordCaptcha;
  [self.captchaButton.rac_command.executionSignals subscribeNext:^(RACSignal *captchaSignal) {
    @strongify(self)
    [self.view endEditing:YES];
    [MSFProgressHUD showStatusMessage:@"正在发送验证码..." inView:self.navigationController.view];
    [captchaSignal subscribeNext:^(id x) {
      [MSFProgressHUD hidden];
    }];
  }];
  [self.captchaButton.rac_command.errors subscribeNext:^(NSError *error) {
    @strongify(self)
    [MSFProgressHUD showErrorMessage:error.userInfo[NSLocalizedFailureReasonErrorKey] inView:self.navigationController.view];
  }];
  self.commitButton.rac_command = self.viewModel.executeFindPassword;
  [self.commitButton.rac_command.executionSignals subscribeNext:^(RACSignal *signUpSignal) {
    @strongify(self)
    [MSFUtils setPhone:self.username.text];
    [self.view endEditing:YES];
    [MSFProgressHUD showStatusMessage:@"正在发送..." inView:self.navigationController.view];
    [signUpSignal subscribeNext:^(id x) {
      [MSFProgressHUD hidden];
      [self.navigationController popViewControllerAnimated:YES];
    }];
  }];
  
  [self.commitButton.rac_command.errors subscribeNext:^(NSError *error) {
    @strongify(self)
    [MSFProgressHUD showErrorMessage:error.userInfo[NSLocalizedFailureReasonErrorKey] inView:self.navigationController.view];
  }];
  
  [[self.passwordSwith rac_newOnChannel] subscribeNext:^(NSNumber *x) {
    @strongify(self)
    [self.password setSecureTextEntry:!x.boolValue];
  }];
}

@end