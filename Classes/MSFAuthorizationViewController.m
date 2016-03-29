//
//  MSFAuthorizationViewController.m
//  Finance
//
//  Created by administrator on 16/3/28.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFAuthorizationViewController.h"
#import "MSFAuthorizationViewModel.h"
#import "UINavigationBar+BackgroundColor.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Masonry/Masonry.h>

@interface MSFAuthorizationViewController ()

@property (nonatomic, strong) MSFAuthorizationViewModel *viewModel;

@end

@implementation MSFAuthorizationViewController

- (instancetype)initWithViewModel:(id)viewModel {
    if (self = [super init]) {
        self.viewModel = viewModel;
    }
    return self;
}

- (void)updateNavAppearance {
    [self.navigationController.navigationBar msf_setBackgroundColor:[UIColor whiteColor]];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
    RAC(titleLabel, text) = [RACObserve(self.viewModel, channel) map:^id(id value) {
        if ([value integerValue] == 0) {
            return @"淘宝授信";
        } else if ([value integerValue] == 1) {
            return @"手机授信";
        } else {
            return @"京东授信";
        }
    }];
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

- (void)createSubViews {
    UIImageView *iconImageView = [[UIImageView alloc] init];
    RAC(iconImageView, image) = [RACObserve(self.viewModel, channel) map:^id(id value) {
        if ([value integerValue] == 0) {
            return [UIImage imageNamed:@"淘宝1.png"];
        } else if ([value integerValue] == 1) {
            return [UIImage imageNamed:@"手机1.png"];
        } else {
            return [UIImage imageNamed:@"京东1.png"];
        }
    }];
    [self.view addSubview:iconImageView];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(84);
        make.width.height.equalTo(@70);
    }];
    
    UIImageView *upArrows = [[UIImageView alloc] init];
    upArrows.image = [UIImage imageNamed:@"up_arrow.png"];
    [self.view addSubview:upArrows];
    [upArrows mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(iconImageView.mas_bottom).offset(20);
        make.width.equalTo(@30);
        make.height.equalTo(@14);
    }];
    
    UITextField *accountTextFiled = [[UITextField alloc] init];
    accountTextFiled.placeholder = @"手机/会员好/邮箱";
    accountTextFiled.layer.borderWidth = 1;
    accountTextFiled.layer.borderColor = [UIColor colorWithRed:236 / 255.0f green:238 / 255.0f blue:237 / 255.0f alpha:1].CGColor;
    accountTextFiled.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:accountTextFiled];
    [accountTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(upArrows.mas_bottom).offset(-1);
        make.height.equalTo(@40);
    }];
    [self.view bringSubviewToFront:upArrows];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateNavAppearance];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createSubViews];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
