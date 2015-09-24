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
#import "MSFLoginPageViewController.h"
#import "MSFUtils.h"

@interface MSFLoginViewController ()

@property (nonatomic, weak) MSFAuthorizeViewModel *viewModel;

@property (nonatomic, weak) IBOutlet UIButton *signInButton;
@property (nonatomic, weak) IBOutlet UIButton *signUpButton;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *leading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *width;

@property (nonatomic, strong, readwrite) MSFLoginPageViewController *loginPageController;

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
	[self didLoad];
	
	@weakify(self)
	id currentViewController = (id <MSFReactiveView>)[self.loginPageController viewControllerAtIndex:self.viewModel.loginType];
	[currentViewController bindViewModel:self.viewModel];
	[self.loginPageController setViewControllers:@[currentViewController] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
	
	[[self.signInButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
		@strongify(self)
		self.loginPageController.dragging = NO;
		id currentViewController = (id <MSFReactiveView>)[self.loginPageController viewControllerAtIndex:1];
		[MSFUtils setRegisterPhone:self.viewModel.username];
		[currentViewController bindViewModel:self.viewModel];
		[self.loginPageController setViewControllers:@[currentViewController] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
		[self updateButtons:MSFLoginSignIn];
	}];
	[[self.signUpButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
		@strongify(self)
		self.loginPageController.dragging = NO;
		id currentViewController = (id <MSFReactiveView>)[self.loginPageController viewControllerAtIndex:0];
		[currentViewController bindViewModel:self.viewModel];
		[self.loginPageController setViewControllers:@[currentViewController] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
		[self updateButtons:MSFLoginSignUp];
	}];
	
	[[self.loginPageController
		rac_signalForSelector:@selector(pageViewController:didFinishAnimating:previousViewControllers:transitionCompleted:)
		fromProtocol:@protocol(UIPageViewControllerDelegate)]
		subscribeNext:^(RACTuple *x) {
			@strongify(self)
			BOOL completed = [x.last boolValue];
			if (!completed) {
				return;
			}
			// Find index of current page
			id currentViewController = [self.loginPageController.viewControllers lastObject];
			NSInteger index = [self.loginPageController.pageIdentifiers indexOfObject:NSStringFromClass([currentViewController class])];
			[currentViewController bindViewModel:self.viewModel];
			[self updateButtons:index];
	}];
	
	[[self.loginPageController rac_signalForSelector:@selector(setUpViewController:atIndex:)] subscribeNext:^(RACTuple *x) {
		@strongify(self)
		[x.first bindViewModel:self.viewModel];
	}];
	
	[RACObserve(self.loginPageController, offset) subscribeNext:^(NSNumber *x) {
		@strongify(self)
		CGFloat offset = x.doubleValue - CGRectGetWidth([UIScreen mainScreen].bounds);
		if (self.currentLoginType == MSFLoginSignUp) {
			self.leading.constant = offset / 2.0;
		} else {
			self.leading.constant = CGRectGetWidth([UIScreen mainScreen].bounds) / 2 + offset / 2.0;
		}
	}];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"page"]) {
		self.loginPageController = segue.destinationViewController;
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

- (MSFLoginType)currentLoginType {
	return !self.signInButton.enabled ? MSFLoginSignIn : MSFLoginSignUp;
}

- (void)didLoad {
	[self.signInButton setTitleColor:[UIColor tintColor] forState:UIControlStateDisabled];
	[self.signInButton setTitleColor:[UIColor fontNormalColor] forState:UIControlStateNormal];
  [self.signUpButton setTitleColor:[UIColor tintColor] forState:UIControlStateDisabled];
	[self.signUpButton setTitleColor:[UIColor fontNormalColor] forState:UIControlStateNormal];
	self.width.constant = CGRectGetWidth([UIScreen mainScreen].bounds) / 2;
	switch (self.viewModel.loginType) {
		case MSFLoginSignIn: {
			self.signInButton.enabled = NO;
			self.signUpButton.enabled = YES;
			self.leading.constant = CGRectGetWidth([UIScreen mainScreen].bounds) / 2;
			break;
		}
		case MSFLoginSignUp: {
			self.signInButton.enabled = YES;
			self.signUpButton.enabled = NO;
			self.leading.constant =  0;
			break;
		}
	}
}

- (void)updateButtons:(NSInteger)type {
	switch (type) {
		case MSFLoginSignIn: {
			self.signInButton.enabled = NO;
			self.signUpButton.enabled = YES;
			[self updateIndicatorViewWithButton:self.signInButton];
			break;
		}
		case MSFLoginSignUp: {
			self.signInButton.enabled = YES;
			self.signUpButton.enabled = NO;
			[self updateIndicatorViewWithButton:self.signUpButton];
			break;
		}
	}
}

- (void)updateIndicatorViewWithButton:(UIButton *)button {
	self.leading.constant = [button isEqual:self.signUpButton] ? 0 : CGRectGetWidth([UIScreen mainScreen].bounds) / 2;
	[UIView animateWithDuration:.3 animations:^{
		[self.view layoutIfNeeded];
	}];
}

@end
