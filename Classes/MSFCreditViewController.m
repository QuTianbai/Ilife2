//
// MSFCreditViewController.m
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFCreditViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFReactiveView.h"
#import "MSFCreditOrderDetailsViewController.h"
#import "MSFCreditViewModel.h"
#import "MSFApplyCashViewModel.h"
#import "MSFApplyCashViewController.h"
#import "MSFLoanType.h"

@interface MSFCreditViewController ()
@property (nonatomic, strong) UIImage *shadowImage;
@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, strong) MSFCreditViewModel *viewModel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *middleHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;

@end

@implementation MSFCreditViewController

- (instancetype)initWithViewModel:(id)viewModel {
	self = [[UIStoryboard storyboardWithName:NSStringFromClass([MSFCreditViewController class]) bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([MSFCreditViewController class])];
  if (!self) {
    return nil;
  }
	_viewModel = viewModel;
  return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.title = @"马上贷";
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"账单" style:UIBarButtonItemStyleDone target:nil action:nil];
	self.navigationItem.rightBarButtonItem.rac_command = self.viewModel.executeBillCommand;
	
	@weakify(self)
	[RACObserve(self, viewModel.status) subscribeNext:^(NSNumber *status) {
		@strongify(self)
		self.topHeight.constant = (status.integerValue == MSFApplicationNone) ? 200 : 250;
		self.middleHeight.constant = (status.integerValue == MSFApplicationNone) ? 200 : 150;
		[self updateViewConstraints];
	}];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	UINavigationBar *navigationBar = self.navigationController.navigationBar;
	navigationBar.tintColor = UIColor.whiteColor;
	self.shadowImage = navigationBar.shadowImage;
	self.backgroundImage = [navigationBar backgroundImageForBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
	[navigationBar setBackgroundImage:[UIImage new]
										 forBarPosition:UIBarPositionAny
												 barMetrics:UIBarMetricsDefault];
	[navigationBar setShadowImage:[UIImage new]];
  self.viewModel.active = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	UINavigationBar *navigationBar = self.navigationController.navigationBar;
	[navigationBar setBackgroundImage:self.backgroundImage
										 forBarPosition:UIBarPositionAny
												 barMetrics:UIBarMetricsDefault];
	[navigationBar setShadowImage:self.shadowImage];
	self.viewModel.active = NO;
}

#pragma mark - MSFReactiveView

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.destinationViewController conformsToProtocol:@protocol(MSFReactiveView)]) {
		[(id <MSFReactiveView>)segue.destinationViewController bindViewModel:self.viewModel];
	}
}

@end
