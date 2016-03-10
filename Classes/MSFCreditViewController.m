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
    
    UIButton *butt = [[UIButton alloc]init];;
    butt.frame = CGRectMake(0, 0, 50, 20);
    butt.layer.cornerRadius = 10;
    [butt setTitle:@"账单" forState:UIControlStateNormal];
    [butt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    butt.titleLabel.font = [UIFont systemFontOfSize:17];
    butt.layer.masksToBounds = YES;
    butt.layer.borderWidth = 1;
    CGColorSpaceRef coloespace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(coloespace, (CGFloat[]){255,255,255,255});
    butt.layer.borderColor = colorref;
    [butt addTarget:self action:@selector(BackToPrevious) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barbutton = [[UIBarButtonItem alloc]initWithCustomView:butt];
    self.navigationItem.rightBarButtonItem = barbutton;
    
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

- (void)BackToPrevious {
	MSFCreditOrderDetailsViewController *OrderDetails = [[MSFCreditOrderDetailsViewController alloc]init];
	[self.navigationController pushViewController:OrderDetails animated:YES];
}

//TODO: 加载马上贷申请界面方法，注意调用，在你的申请按钮点击后调用
- (void)apply {
	MSFApplyCashViewModel *viewModel = [[MSFApplyCashViewModel alloc] initWithLoanType:[[MSFLoanType alloc] initWithTypeID:@"4102"] services:self.viewModel.services];
	MSFMSFApplyCashViewController *vc = [[MSFMSFApplyCashViewController alloc] initWithViewModel:viewModel];
	vc.hidesBottomBarWhenPushed = YES;
	[self.navigationController pushViewController:vc animated:YES];
}

@end
