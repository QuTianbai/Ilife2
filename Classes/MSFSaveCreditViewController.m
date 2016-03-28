//
//  MSFSaveCreditViewController.m
//  Finance
//
//  Created by administrator on 16/3/28.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFSaveCreditViewController.h"
#import "MSFSaveCreditViewModel.h"
#import "UINavigationBar+BackgroundColor.h"
#import "MSFHeaderView.h"
#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFBaseLineButton.h"

@interface MSFSaveCreditViewController ()

@property (nonatomic, strong) MSFSaveCreditViewModel *viewModel;
@property (nonatomic, strong) MSFHeaderView *headerView;

@end

@implementation MSFSaveCreditViewController

- (instancetype)initWithViewModel:(id)viewModel {
    if (self = [super init]) {
        self.viewModel = viewModel;
    }
    return self;
}

- (void)updateNavAppearance {
    [self.navigationController.navigationBar msf_setBackgroundColor:[UIColor whiteColor]];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
    titleLabel.text = @"攒信用";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor blackColor];
    self.navigationItem.titleView = titleLabel;
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    backButton.frame = CGRectMake(0, 7, 30, 30);
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [backButton setImage:[[UIImage imageNamed:@"btn-back-nav.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateNavAppearance];
}

- (void)createSubViews {
    self.headerView = [MSFHeaderView headerViewWithIndex:2];
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(64);
        make.height.equalTo(@90);
    }];
    UIView *headerViewBottomLine = [[UIView alloc] init];
    [self.view addSubview:headerViewBottomLine];
    headerViewBottomLine.backgroundColor = [UIColor colorWithRed:236 / 255.0f green:238 / 255.0f blue:237 / 255.0f alpha:1];
    [headerViewBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.headerView.mas_bottom);
        make.height.equalTo(@1);
    }];
    UILabel *creditLabel = [[UILabel alloc] init];
    [self.view addSubview:creditLabel];
    creditLabel.text = @"马上激活受信";
    creditLabel.textColor = [UIColor colorWithRed:32 / 255.0f green:150 / 255.0f blue:251 / 255.0f alpha:1];
    creditLabel.font = [UIFont boldSystemFontOfSize:16];
    creditLabel.textAlignment = NSTextAlignmentCenter;
    [creditLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(headerViewBottomLine.mas_bottom).offset(10);
        make.width.equalTo(@120);
        make.height.equalTo(@18);
    }];
    UILabel *tipLabel = [[UILabel alloc] init];
    [self.view addSubview:tipLabel];
    tipLabel.text = @"提高贷款成功率和增加贷款资金";
    tipLabel.textColor = [UIColor colorWithRed:147 / 255.0f green:147 / 255.0f blue:147 / 255.0f alpha:1];
    tipLabel.font = [UIFont systemFontOfSize:14];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(creditLabel.mas_bottom).offset(10);
        make.width.equalTo(self.view);
        make.height.equalTo(@16);
    }];
    UIButton *taoBaoButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [taoBaoButton setImage:[[UIImage imageNamed:@"淘宝1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [taoBaoButton setImage:[[UIImage imageNamed:@"淘宝2.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
    [self.view addSubview:taoBaoButton];
    [taoBaoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(60);
        make.width.equalTo(@70);
        make.height.equalTo(@70);
        make.top.equalTo(tipLabel.mas_bottom).offset(10);
    }];
    
    UIButton *messageButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [messageButton setImage:[[UIImage imageNamed:@"手机1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [messageButton setImage:[[UIImage imageNamed:@"手机2.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
    [self.view addSubview:messageButton];
    [messageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-60);
        make.width.equalTo(@70);
        make.height.equalTo(@70);
        make.top.equalTo(tipLabel.mas_bottom).offset(10);
    }];
    UILabel *taoBaoLabel = [[UILabel alloc] init];
    taoBaoLabel.textAlignment = NSTextAlignmentCenter;
    taoBaoLabel.text = @"淘宝信用";
    taoBaoLabel.font = [UIFont systemFontOfSize:14];
    taoBaoLabel.textColor = [UIColor colorWithRed:128 / 255.0f green:128 / 255.0f blue:128 / 255.0f alpha:1];
    [self.view addSubview:taoBaoLabel];
    [taoBaoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(taoBaoButton);
        make.width.equalTo(taoBaoButton);
        make.top.equalTo(taoBaoButton.mas_bottom).offset(10);
        make.height.equalTo(@16);
    }];
    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.text = @"手机信用";
    messageLabel.font = [UIFont systemFontOfSize:14];
    messageLabel.textColor = [UIColor colorWithRed:128 / 255.0f green:128 / 255.0f blue:128 / 255.0f alpha:1];
    [self.view addSubview:messageLabel];
    [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(messageButton);
        make.width.equalTo(messageButton);
        make.top.equalTo(messageButton.mas_bottom).offset(10);
        make.height.equalTo(messageLabel);
    }];
    UIButton *jinDongButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [jinDongButton setImage:[[UIImage imageNamed:@"京东1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [jinDongButton setImage:[[UIImage imageNamed:@"京东2.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
    [self.view addSubview:jinDongButton];
    [jinDongButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.equalTo(@70);
        make.height.equalTo(@70);
        make.top.equalTo(messageLabel.mas_bottom);
    }];
    UILabel *jinDongLabel = [[UILabel alloc] init];
    jinDongLabel.textAlignment = NSTextAlignmentCenter;
    jinDongLabel.text = @"京东信用";
    jinDongLabel.font = [UIFont systemFontOfSize:14];
    jinDongLabel.textColor = [UIColor colorWithRed:128 / 255.0f green:128 / 255.0f blue:128 / 255.0f alpha:1];
    [self.view addSubview:jinDongLabel];
    [jinDongLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(jinDongButton);
        make.width.equalTo(jinDongButton);
        make.top.equalTo(jinDongButton.mas_bottom).offset(10);
        make.height.equalTo(messageLabel);
    }];
    MSFBaseLineButton *nextButton = [MSFBaseLineButton buttonWithType:UIButtonTypeSystem];
    [nextButton setTitle:@"授信将提高贷款通过率，跳过>>" forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor colorWithRed:53 / 255.0f green:144 / 255.0f blue:234 / 255.0f alpha:1] forState:UIControlStateNormal];
    [nextButton setBaseLineColor:[UIColor colorWithRed:53 / 255.0f green:144 / 255.0f blue:234 / 255.0f alpha:1]];
    [self.view addSubview:nextButton];
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@30);
        make.bottom.equalTo(self.view).offset(- 20);
        make.width.equalTo(@240);
        make.centerX.equalTo(self.view);
    }];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createSubViews];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar msf_reset];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
