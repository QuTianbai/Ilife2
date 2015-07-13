//
// MSFLoginViewController.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFLoginViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/extobjc.h>
#import "MSFAuthorizeViewModel.h"
#import "MSFSignInViewController.h"
#import "MSFProgressHUD.h"
#import "MSFUtils.h"

static NSString *const MSFAutoinputDebuggingEnvironmentKey = @"INPUT_AUTO_DEBUG";

@interface MSFLoginViewController ()

@property(nonatomic,strong) MSFSignInViewController *signInViewController;
@property(nonatomic,strong) MSFAuthorizeViewModel *viewModel;

@end

@implementation MSFLoginViewController

#pragma mark - Lifecycle

- (instancetype)init {
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"login" bundle:nil];
  self = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass(self.class)];
  if (!self) {
    return nil;
  }
  
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"登录";
  self.edgesForExtendedLayout = UIRectEdgeNone;
  self.signInViewController.username.text = MSFUtils.phone;
  
  if (NSProcessInfo.processInfo.environment[MSFAutoinputDebuggingEnvironmentKey] != nil) {
    self.signInViewController.username.text = @"18696995689";
    self.signInViewController.captcha.text = @"666666";
    self.signInViewController.password.text = @"123456qw";
  }
  
  self.viewModel = [[MSFAuthorizeViewModel alloc] init];
  RAC(self.viewModel,username) = self.signInViewController.username.rac_textSignal;
  RAC(self.viewModel,password) = self.signInViewController.password.rac_textSignal;
  RAC(self.viewModel,captcha) = self.signInViewController.captcha.rac_textSignal;
  
  @weakify(self)
  self.signInViewController.signInButton.rac_command = self.viewModel.executeSignIn;
  [self.viewModel.executeSignIn.executionSignals subscribeNext:^(RACSignal *execution) {
    @strongify(self)
    [MSFUtils setPhone:self.signInViewController.username.text];
    [self.view endEditing:YES];
    [MSFProgressHUD showStatusMessage:@"正在登录..."];
    [execution subscribeNext:^(id x) {
      [MSFProgressHUD hidden];
      [self dismissViewControllerAnimated:YES completion:nil];
    }];
  }];
  [self.viewModel.executeSignIn.errors subscribeNext:^(NSError *error) {
    @strongify(self)
    [self.view endEditing:YES];
    [MSFProgressHUD showErrorMessage:error.userInfo[NSLocalizedFailureReasonErrorKey] inView:self.navigationController.view];
  }];
  
  self.signInViewController.captchaButton.rac_command = self.viewModel.executeLoginCaptcha;
  [self.signInViewController.captchaButton.rac_command.executionSignals subscribeNext:^(RACSignal *captchaSignal) {
    @strongify(self)
    [self.view endEditing:YES];
    [MSFProgressHUD showStatusMessage:@"正在发送验证码..." inView:self.navigationController.view];
    [captchaSignal subscribeNext:^(id x) {
      [MSFProgressHUD hidden];
    }];
  }];
  [self.signInViewController.captchaButton.rac_command.errors subscribeNext:^(NSError *error) {
    @strongify(self)
    [MSFProgressHUD showErrorMessage:error.userInfo[NSLocalizedFailureReasonErrorKey] inView:self.navigationController.view];
  }];
  
  RAC(self.signInViewController.counterLabel,text) = RACObserve(self.viewModel, counter);
  
  RAC(self.signInViewController.counterLabel,textColor) =
  [self.viewModel.captchaRequestValidSignal
    map:^id(NSNumber *valid) {
      return valid.boolValue ? UIColor.whiteColor : UIColor.lightGrayColor;
  }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"signin"]) {
    self.signInViewController = segue.destinationViewController;
  }
}

@end
