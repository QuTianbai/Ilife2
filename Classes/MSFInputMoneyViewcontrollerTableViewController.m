//
//  MSFInputMoneyViewcontrollerTableViewController.m
//  Finance
//
//  Created by 胥佰淼 on 16/3/19.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFInputMoneyViewcontrollerTableViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "RVMViewModel.h"
#import "MSFDrawingsViewModel.h"

@interface MSFInputMoneyViewcontrollerTableViewController ()

@property (nonatomic, strong) RVMViewModel <MSFTransactionsViewModel> *viewModel;

@property (nonatomic, weak) IBOutlet UILabel *bankName;
@property (nonatomic, weak) IBOutlet UILabel *bankNo;
@property (nonatomic, weak) IBOutlet UIImageView *bankIco;
@property (nonatomic, weak) IBOutlet UILabel *payment;
@property (nonatomic, weak) IBOutlet UITextField *amount;
@property (nonatomic, weak) IBOutlet UITextField *authCode;
@property (nonatomic, weak) IBOutlet UILabel *supports;
@property (nonatomic, weak) IBOutlet UIButton *changeCard;
@property (nonatomic, weak) IBOutlet UIButton *checkOut;
@property (nonatomic, weak) IBOutlet UIButton *fetchAuthcode;
@property (weak, nonatomic) IBOutlet UILabel *repayLB;

@end

@implementation MSFInputMoneyViewcontrollerTableViewController

- (instancetype)initWithViewModel:(id)viewModel {
    self = [[UIStoryboard storyboardWithName:NSStringFromClass([MSFInputMoneyViewcontrollerTableViewController class]) bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([MSFInputMoneyViewcontrollerTableViewController class])];
    if (!self) {
        return nil;
    }
    _viewModel = viewModel;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewModel.active = YES;
    self.viewModel.active = NO;
    RAC(self, title) = RACObserve(self.viewModel, title);
    RAC(self.bankName, text) = RACObserve(self.viewModel, bankName);
    RAC(self.bankNo, text) = RACObserve(self.viewModel, bankNo);
    RAC(self.bankIco, image) = [RACObserve(self.viewModel, bankIco) map:^id(id value) {
        return [UIImage imageNamed:value];
    }];
    RAC(self.payment, text) = RACObserve(self.viewModel, summary);
    RAC(self.supports, text) = RACObserve(self.viewModel, supports);
    RAC(self.amount, userInteractionEnabled) = RACObserve(self.viewModel, editable);
    RAC(self, repayLB.text) = [RACObserve(self, viewModel.amounts) map:^id(id value) {
        return [NSString stringWithFormat:@"实际还款：%@", value];
    }];
    [RACObserve(self, viewModel) subscribeNext:^(RVMViewModel<MSFTransactionsViewModel> *x) {
        if (!x.isOutTime) {
            [self.checkOut setTitle:x.buttonTitle forState:UIControlStateDisabled];
        }
    }];
    
    RAC(self.viewModel, captcha) = self.authCode.rac_textSignal;
    
    RACChannelTerminal *modelTerminal = RACChannelTo(self.viewModel, amounts);
    RAC(self.amount, text) = modelTerminal;
    [self.amount.rac_textSignal subscribe:modelTerminal];
    
    self.fetchAuthcode.rac_command = self.viewModel.executeCaptchaCommand;
    
    @weakify(self)
    [RACObserve(self, viewModel.editable) subscribeNext:^(id x) {
        @strongify(self)
        if ([x boolValue]) [self.amount becomeFirstResponder];
    }];
    [RACObserve(self.viewModel, captchaTitle) subscribeNext:^(id x) {
        @strongify(self)
        [self.fetchAuthcode setTitle:x forState:UIControlStateNormal];
    }];
    
    [self.viewModel.executeCaptchaCommand.executionSignals subscribeNext:^(id x) {
        @strongify(self)
        [self.authCode becomeFirstResponder];
    }];
    [self.viewModel.executeCaptchaCommand.errors subscribeNext:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
    }];
    
    self.checkOut.rac_command = self.viewModel.executePaymentCommand;
    [self.viewModel.executePaymentCommand.errors subscribeNext:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
    }];
    [self.viewModel.executePaymentCommand.executionSignals subscribeNext:^(id x) {
        [x subscribeNext:^(id x) {
            [SVProgressHUD showSuccessWithStatus:@"交易成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }];
    
    self.changeCard.rac_command = self.viewModel.executeSwitchCommand;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.viewModel isKindOfClass:MSFDrawingsViewModel.class]) return 3;
    return [super tableView:tableView numberOfRowsInSection:section];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)viewDidLayoutSubviews {
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
}

@end
