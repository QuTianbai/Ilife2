//
// MSFAuxiliaryViewController.m
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFAuxiliaryViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFAuxiliaryViewModel.h"

@interface MSFAuxiliaryViewController ()

@property (nonatomic, strong) MSFAuxiliaryViewModel *viewModel;

@property (nonatomic, weak) UITextField *qqTextField;
@property (nonatomic, weak) UITextField *qqpwdTextField;

@property (nonatomic, weak) UITextField *taobaoTextField;
@property (nonatomic, weak) UITextField *taobaopwdTextField;

@property (nonatomic, weak) UITextField *jdTextField;
@property (nonatomic, weak) UITextField *jdpwdTextField;

@end

@implementation MSFAuxiliaryViewController

#pragma mark - NSObject

- (instancetype)initWithViewModel:(id)viewModel {
  self = [[UIStoryboard storyboardWithName:NSStringFromClass([MSFAuxiliaryViewController class]) bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([MSFAuxiliaryViewController class])];
  if (!self) {
    return nil;
  }
	_viewModel = viewModel;
	
  return self;
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	RACChannelTerminal *channel;
	channel = RACChannelTo(self.viewModel, qq);
	RAC(self.qqTextField, text) = channel;
	[self.qqTextField.rac_textSignal subscribe:channel];
	
	channel = RACChannelTo(self.viewModel, qqpwd);
	RAC(self.qqpwdTextField, text) = channel;
	[self.qqpwdTextField.rac_textSignal subscribe:channel];
	
	channel = RACChannelTo(self.viewModel, taobao);
	RAC(self.taobaoTextField, text) = channel;
	[self.taobaoTextField.rac_textSignal subscribe:channel];
	
	channel = RACChannelTo(self.viewModel, taobaopwd);
	RAC(self.taobaopwdTextField, text) = channel;
	[self.taobaopwdTextField.rac_textSignal subscribe:channel];
	
	channel = RACChannelTo(self.viewModel, jd);
	RAC(self.jdTextField, text) = channel;
	[self.jdTextField.rac_textSignal subscribe:channel];
	
	channel = RACChannelTo(self.viewModel, jdpwd);
	RAC(self.jdpwdTextField, text) = channel;
	[self.jdpwdTextField.rac_textSignal subscribe:channel];
}

@end
