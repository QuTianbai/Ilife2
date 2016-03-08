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
-(void)viewWillAppear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"订单详情";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"left_arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
   // [[UINavigationBar appearance] setBarTintColor:[UIColor orangeColor]];
    self.view.backgroundColor = UIColor.darkBackgroundColor;
    
  }
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
