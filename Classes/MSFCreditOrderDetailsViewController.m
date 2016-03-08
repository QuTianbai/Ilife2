//
//  MSFCreditOrderDetailsViewController.m
//  Finance
//
//  Created by Wyc on 16/3/4.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFCreditOrderDetailsViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFReactiveView.h"
#import "UIColor+Utils.h"

@interface MSFCreditOrderDetailsViewController ()

@property (nonatomic, weak) id<MSFViewModelServices>services;
@property (nonatomic, strong) NSString *orderId;

@property (nonatomic, strong) MSFCreditOrderDetailsViewController *viewModel;

@end

@implementation MSFCreditOrderDetailsViewController
- (instancetype)initWithViewModel:(id)viewModel {
    self = [super init];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.hidesBottomBarWhenPushed = YES;
        _viewModel = viewModel;
    }
    return self;
}

- (instancetype)initWithServices:(id<MSFViewModelServices>)services {
    self = [super init];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.hidesBottomBarWhenPushed = YES;
        _viewModel = [[MSFCreditOrderDetailsViewController alloc] initWithServices:services];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"订单详情";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"left_arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
   // [[UINavigationBar appearance] setBarTintColor:[UIColor orangeColor]];
    self.view.backgroundColor = UIColor.darkBackgroundColor;
    
  }

- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
