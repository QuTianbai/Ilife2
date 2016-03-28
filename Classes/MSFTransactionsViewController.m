//
// MSFPaymentViewController.m
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFTransactionsViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "RVMViewModel.h"
#import "MSFDrawingsViewModel.h"
#import "UIColor+Utils.h"

@interface MSFTransactionsViewController ()

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

@property (nonatomic, weak) IBOutlet UIButton *sendCaptchaButton;
@property (nonatomic, weak) IBOutlet UILabel *counterLabel;
@property (nonatomic, weak) IBOutlet UIImageView *sendCaptchaView;

@end

@implementation MSFTransactionsViewController

- (instancetype)initWithViewModel:(id)viewModel {
  self = [[UIStoryboard storyboardWithName:NSStringFromClass([MSFTransactionsViewController class]) bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([MSFTransactionsViewController class])];
  if (!self) {
    return nil;
  }
	_viewModel = viewModel;
	
  return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
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
    if ([self.viewModel.summary rangeOfString:@"¥"].location != NSNotFound) {
        if ([[self.viewModel.summary substringFromIndex:1] floatValue] > 100) {
            self.amount.userInteractionEnabled = YES;
        } else {
            self.amount.userInteractionEnabled = NO;
        }
    } else {
        if ([self.viewModel.summary floatValue] > 100) {
            self.amount.userInteractionEnabled = YES;
        } else {
            self.amount.userInteractionEnabled = NO;
        }
    }
    
//    self.amount.text = self.viewModel.debtAmounts;
    [RACObserve(self, viewModel) subscribeNext:^(RVMViewModel<MSFTransactionsViewModel> *x) {
        if (!x.isOutTime) {
            [self.checkOut setTitle:x.buttonTitle forState:UIControlStateDisabled];
        }
    }];
	@weakify(self)
	RAC(self.viewModel, captcha) = self.authCode.rac_textSignal;
	
	RACChannelTerminal *modelTerminal = RACChannelTo(self.viewModel, amounts);
	RAC(self.amount, text) = modelTerminal;
	[self.amount.rac_textSignal subscribe:modelTerminal];
	
    // 验证码
    [RACObserve(self.viewModel, captchaTitle) subscribeNext:^(id x) {
        @strongify(self)
        self.counterLabel.text = x;
    }];
    
    [self.viewModel.captchaValidSignal subscribeNext:^(NSNumber *value) {
        @strongify(self)
        self.counterLabel.textColor = value.boolValue ? UIColor.whiteColor: [UIColor blackColor];
        self.sendCaptchaView.backgroundColor = value.boolValue ? [UIColor navigationBgColor] : [UIColor lightGrayColor];
    }];
    
	self.sendCaptchaButton.rac_command = self.viewModel.executeCaptchaCommand;
    [self.sendCaptchaButton.rac_command.executionSignals subscribeNext:^(RACSignal *captchaSignal) {
        @strongify(self)
        [self.view endEditing:YES];
        [SVProgressHUD showWithStatus:@"正在获取验证码" maskType:SVProgressHUDMaskTypeClear];
        [captchaSignal subscribeNext:^(id x) {
            [SVProgressHUD dismiss];
        }];
    }];
    
    [self.sendCaptchaButton.rac_command.errors subscribeNext:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
    }];
	
	[RACObserve(self, viewModel.editable) subscribeNext:^(id x) {
		@strongify(self)
		if ([x boolValue]) [self.amount becomeFirstResponder];
	}];
//	[RACObserve(self.viewModel, captchaTitle) subscribeNext:^(id x) {
//		@strongify(self)
//		[self.fetchAuthcode setTitle:x forState:UIControlStateNormal];
//	}];
	
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
    self.viewModel.active = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
    self.viewModel.active = NO;
	
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if ([self.viewModel isKindOfClass:MSFDrawingsViewModel.class]) return 3;
	return [super tableView:tableView numberOfRowsInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.viewModel.editable) {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            return 0;
        }
        if (!self.viewModel.isOutTime && indexPath.row == 4) {
            return 0;
        }
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
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
