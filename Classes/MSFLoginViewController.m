//
// MSFLoginViewController.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFLoginViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/extobjc.h>
#import <Masonry/Masonry.h>
#import "MSFAuthorizeViewModel.h"
#import "UIColor+Utils.h"
#import "MSFReactiveView.h"

@interface MSFLoginViewController ()

@property (nonatomic, weak) MSFAuthorizeViewModel *viewModel;

@property (nonatomic, weak) IBOutlet UIButton *signInButton;
@property (nonatomic, weak) IBOutlet UIButton *signUpButton;
@property (nonatomic, weak) IBOutlet UIView *signInIndicatorView;
@property (nonatomic, weak) IBOutlet UIView *signUpIndicatorView;

@property (nonatomic, strong, readwrite) MSFLoginSwapController *loginSwapController;

@end

@implementation MSFLoginViewController

#pragma mark - Lifecycle

- (instancetype)initWithViewModel:(id)viewModel {
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"login" bundle:nil];
	self = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass(self.class)];
  if (!self) {
    return nil;
  }
	_viewModel = viewModel;
	
  return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self.signInButton setTitleColor:[UIColor fontHighlightedColor] forState:UIControlStateDisabled];
	[self.signInButton setTitleColor:[UIColor fontNormalColor] forState:UIControlStateNormal];
	[self.signUpButton setTitleColor:[UIColor fontHighlightedColor] forState:UIControlStateDisabled];
	[self.signUpButton setTitleColor:[UIColor fontNormalColor] forState:UIControlStateNormal];
	switch (self.viewModel.loginType) {
		case MSFLoginSignIn: {
			self.signInButton.enabled = NO;
			self.signUpButton.enabled = YES;
			self.signInIndicatorView.hidden = NO;
			self.signUpIndicatorView.hidden = YES;
			break;
		}
		case MSFLoginSignUp: {
			self.signInButton.enabled = YES;
			self.signUpButton.enabled = NO;
			self.signInIndicatorView.hidden = YES;
			self.signUpIndicatorView.hidden = NO;
			break;
		}
		default: {
			break;
		}
	}
	
	[self.loginSwapController swap:self.viewModel.loginType];
	[(id <MSFReactiveView>)self.loginSwapController.contentViewController bindViewModel:self.viewModel];
	
	@weakify(self)
	[[self.signInButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
		@strongify(self)
		self.signInButton.enabled = NO;
		self.signUpButton.enabled = YES;
		self.signInIndicatorView.hidden = NO;
		self.signUpIndicatorView.hidden = YES;
		[self.loginSwapController swap:MSFLoginSignIn];
		[(id <MSFReactiveView>)self.loginSwapController.contentViewController bindViewModel:self.viewModel];
	}];
	[[self.signUpButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
		@strongify(self)
		self.signInButton.enabled = YES;
		self.signUpButton.enabled = NO;
		self.signInIndicatorView.hidden = YES;
		self.signUpIndicatorView.hidden = NO;
		[self.loginSwapController swap:MSFLoginSignUp];
		[(id <MSFReactiveView>)self.loginSwapController.contentViewController bindViewModel:self.viewModel];
	}];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"swap"]) {
		self.loginSwapController = segue.destinationViewController;
	}
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	self.navigationController.navigationBarHidden = NO;
}

#pragma mark - Private

- (UIView *)indicatorView {
	return self.viewModel.loginType == MSFLoginSignIn ? self.signInIndicatorView : self.signUpIndicatorView;
}

@end
