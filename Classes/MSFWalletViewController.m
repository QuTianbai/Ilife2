//
// MSFWalletViewController.m
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFWalletViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFReactiveView.h"
#import "MSFWalletViewModel.h"

@interface MSFWalletViewController ()

@property (nonatomic, strong) UIImage *shadowImage;
@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, strong) MSFWalletViewModel *viewModel;

@end

@implementation MSFWalletViewController

#pragma mark - NSObject

- (instancetype)initWithViewModel:(id)viewModel {
  self = [[UIStoryboard storyboardWithName:NSStringFromClass([MSFWalletViewController class]) bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([MSFWalletViewController class])];
  if (!self) {
    return nil;
  }
	_viewModel = viewModel;
  return self;
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"信用钱包";
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"账单"
	style:UIBarButtonItemStyleDone target:nil action:nil];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  UINavigationBar *navigationBar = self.navigationController.navigationBar;
  navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
  navigationBar.tintColor = UIColor.whiteColor;
  self.shadowImage = navigationBar.shadowImage;
  self.backgroundImage = [navigationBar backgroundImageForBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
  [navigationBar setBackgroundImage:[UIImage new]
                     forBarPosition:UIBarPositionAny
                         barMetrics:UIBarMetricsDefault];
  [navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  UINavigationBar *navigationBar = self.navigationController.navigationBar;
  navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor colorWithRed:0.770 green:0.258 blue:0.110 alpha:1.000]};
  [navigationBar setBackgroundImage:self.backgroundImage
                     forBarPosition:UIBarPositionAny
                         barMetrics:UIBarMetricsDefault];
  [navigationBar setShadowImage:self.shadowImage];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	[(id <MSFReactiveView>)segue.destinationViewController bindViewModel:self.viewModel];
}

@end
