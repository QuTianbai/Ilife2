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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
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
    // Do any additional setup after loading the view.
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
