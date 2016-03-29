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
    
    UIButton *accountIconButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, 40, 40)];
    [accountIconButton setImage:[UIImage imageNamed:@"person.png"]forState:UIControlStateNormal];
    accountIconButton.enabled = NO;
    
    UITextField *accountTextFiled = [[UITextField alloc] init];
    accountTextFiled.placeholder = @"手机/会员好/邮箱";
    accountTextFiled.layer.borderWidth = 1;
    accountTextFiled.font = [UIFont systemFontOfSize:14];
    accountTextFiled.leftViewMode = UITextFieldViewModeAlways;
    accountTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    accountTextFiled.leftView = accountIconButton;
    accountTextFiled.layer.borderColor = [UIColor colorWithRed:236 / 255.0f green:238 / 255.0f blue:237 / 255.0f alpha:1].CGColor;
    accountTextFiled.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:accountTextFiled];
    [accountTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(upArrows.mas_bottom).offset(-1);
        make.height.equalTo(@40);
    }];
    [self.view bringSubviewToFront:upArrows];
    UIButton *passwordIconButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, 40, 40)];
    [passwordIconButton setImage:[UIImage imageNamed:@"lock.png"]forState:UIControlStateNormal];
    passwordIconButton.enabled = NO;
    UIButton *showPasswordButton = [[UIButton alloc] init];
    [showPasswordButton setImage:[UIImage imageNamed:@"showpassword.png"]forState:UIControlStateNormal];
    [self.view addSubview:showPasswordButton];
    UITextField *passwordTextFiled = [[UITextField alloc] init];
    passwordTextFiled.placeholder = @"请输入密码";
    passwordTextFiled.font = [UIFont systemFontOfSize:14];
    passwordTextFiled.leftViewMode = UITextFieldViewModeAlways;
    passwordTextFiled.clearButtonMode = UITextFieldViewModeAlways;
    passwordTextFiled.leftView = passwordIconButton;
    passwordTextFiled.secureTextEntry = YES;
    passwordTextFiled.tag = 100;
    passwordTextFiled.autocapitalizationType = UITextAutocapitalizationTypeNone;
    passwordTextFiled.autocorrectionType = UITextAutocorrectionTypeNo;
    passwordTextFiled.layer.borderColor = [UIColor colorWithRed:236 / 255.0f green:238 / 255.0f blue:237 / 255.0f alpha:1].CGColor;
    passwordTextFiled.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:passwordTextFiled];
    [passwordTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(accountTextFiled.mas_bottom);
        make.height.equalTo(@40);
        make.right.equalTo(self.view).offset(-60);
    }];
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithRed:231 / 255.0f green:234 / 255.0f blue:232 / 255.0f alpha:1];
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(passwordTextFiled.mas_bottom);
        make.height.equalTo(@1);
    }];
    
    [showPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(passwordTextFiled.mas_right);
        make.right.equalTo(self.view);
        make.top.bottom.equalTo(passwordTextFiled);
    }];
    [showPasswordButton addTarget:self action:@selector(showPassword) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *authorizationButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [authorizationButton setTitle:@"授权认证" forState:UIControlStateNormal];
    [authorizationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [authorizationButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    authorizationButton.backgroundColor = [UIColor colorWithRed:22 / 255.0f green:146 / 255.0f blue:250 / 255.0f alpha:1];
    authorizationButton.layer.cornerRadius = 5;
    authorizationButton.layer.masksToBounds = YES;
    [self.view addSubview:authorizationButton];
    [authorizationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(passwordTextFiled.mas_bottom).offset(20);
        make.height.equalTo(@40);
    }];
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.text = @"银行最高级别加密,保障用户安全";
    tipLabel.font = [UIFont systemFontOfSize:14];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.textColor = [UIColor colorWithRed:248 / 255.0f green:166 / 255.0f blue:85 / 255.0f alpha:1];
    [self.view addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(authorizationButton);
        make.height.equalTo(@15);
        make.top.equalTo(authorizationButton.mas_bottom).offset(20);
    }];
    
}

- (void)showPassword {
    UITextField *textFiled = (UITextField *)[self.view viewWithTag:100];
    textFiled.secureTextEntry = !textFiled.secureTextEntry;
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
