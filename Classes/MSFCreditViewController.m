//
// MSFCreditViewController.m
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFCreditViewController.h"
#import <Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFReactiveView.h"
#import "MSFCreditOrderDetailsViewController.h"
//define this constant if you want to use Masonry without the 'mas_' prefix
#define MAS_SHORTHAND
//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS
#import "Masonry.h"
#import "MSFCreditViewModel.h"
#import "MSFApplyCashViewModel.h"
#import "MSFMSFApplyCashViewController.h"
#import "MSFLoanType.h"

@interface MSFCreditViewController ()
@property (nonatomic, strong) UIImage *shadowImage;
@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, strong) MSFCreditViewModel *viewModel;

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
	
	self.viewModel.active = YES;
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	[(id <MSFReactiveView>)segue.destinationViewController bindViewModel:self.viewModel];
}

//TODO: 加载马上贷申请界面方法，注意调用，在你的申请按钮点击后调用
- (void)apply {
	MSFApplyCashViewModel *viewModel = [[MSFApplyCashViewModel alloc] initWithLoanType:[[MSFLoanType alloc] initWithTypeID:@"4102"] services:self.viewModel.services];
	MSFMSFApplyCashViewController *vc = [[MSFMSFApplyCashViewController alloc] initWithViewModel:viewModel];
	vc.hidesBottomBarWhenPushed = YES;
	[self.navigationController pushViewController:vc animated:YES];
}

@end
