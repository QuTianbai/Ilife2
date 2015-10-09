//
//  MSFUserInfomationViewController.m
//  Finance
//
//  Created by 赵勇 on 9/29/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFUserInfomationViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Masonry/Masonry.h>

#import "MSFUserInfoCircleView.h"

#import "MSFPersonalViewModel.h"
#import "MSFRelationshipViewModel.h"
#import "MSFProfessionalViewModel.h"
#import "MSFApplyCashVIewModel.h"
#import "MSFFormsViewModel.h"
#import "MSFAddressViewModel.h"

#import "MSFClient+MSFApplyInfo.h"
#import "UIColor+Utils.h"

#import "MSFUtils.h"
#import "MSFUser.h"
#import "MSFInventoryViewModel.h"
#import "MSFInventoryViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "AppDelegate.h"
#import "MSFSetTradePasswordTableViewController.h"
#import "MSFAddBankCardTableViewController.h"

@interface MSFUserInfomationViewController ()

@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UIButton *nextStepButton;
@property (nonatomic, strong) MSFUserInfoCircleView *circleView;
@property (nonatomic, weak) id<MSFViewModelServices>services;
@property (nonatomic, strong) MSFApplyCashVIewModel *viewModel;

@end

@implementation MSFUserInfomationViewController

- (instancetype)initWithViewModel:(id)viewModel services:(id<MSFViewModelServices>)services {
	self = [super init];
	if (self) {
		self.hidesBottomBarWhenPushed = YES;
		_services = services;
		_viewModel = viewModel;
	}
	return self;
}

- (void)dealloc {
	NSLog(@"MSFUserInfomationViewController `-dealloc`");
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
	
	self.navigationItem.title = @"个人信息";
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"left_arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
	
	_headerImageView = [[UIImageView alloc] init];
	_headerImageView.image = [UIImage imageNamed:@"home-banner-pl.png"];
	[self.view addSubview:_headerImageView];
	
	@weakify(self)
	_circleView = [[MSFUserInfoCircleView alloc] init];
	[self.view addSubview:_circleView];
	[[_circleView.clickCommand.executionSignals
		switchToLatest]
	 subscribeNext:^(NSNumber *x) {
		 @strongify(self)
		 [self onClickCircle:x.integerValue];
	}];
	
	[RACObserve(self.services.httpClient.user, complateCustInfo) subscribeNext:^(id x) {
		@strongify(self)
		[self.circleView setCompeltionStatus:x];
	}];
	
	_nextStepButton = [UIButton buttonWithType:UIButtonTypeSystem];
	_nextStepButton.backgroundColor = [UIColor themeColorNew];
	[_nextStepButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[_nextStepButton setTitle:@"下一步" forState:UIControlStateNormal];
	_nextStepButton.hidden = !_showNextStep;
	_nextStepButton.layer.cornerRadius = 5;
	[self.view addSubview:_nextStepButton];
	//_nextStepButton.rac_command = self.viewModel.executeNextCommand;
	[[self.nextStepButton rac_signalForControlEvents:UIControlEventTouchUpInside]
	subscribeNext:^(id x) {
		@strongify(self)
		if ([MSFUtils.isSetTradePassword isEqualToString:@"NO"]) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
																											message:@"请先设置交易密码" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
			[alert show];
			[alert.rac_buttonClickedSignal subscribeNext:^(NSNumber *index) {
				if (index.intValue == 1) {
					AppDelegate *delegate = [UIApplication sharedApplication].delegate;
					MSFAuthorizeViewModel *viewModel = delegate.authorizeVewModel;
					MSFSetTradePasswordTableViewController *setTradePasswordVC = [[MSFSetTradePasswordTableViewController alloc] initWithViewModel:viewModel];
					
					[self.navigationController pushViewController:setTradePasswordVC animated:YES];
									}
				
			}];
			return ;
		}
		if (!self.viewModel.formViewModel.master) {
			[SVProgressHUD showErrorWithStatus:@"请先添加银行卡"];
			MSFAddBankCardTableViewController *vc =  [UIStoryboard storyboardWithName:@"AddBankCard" bundle:nil].instantiateInitialViewController;
			BOOL isFirstBankCard = YES;
			
			vc.viewModel =  [[MSFAddBankCardVIewModel alloc] initWithServices:self.services andIsFirstBankCard:isFirstBankCard];
			[self.navigationController pushViewController:vc animated:YES];
			
			return ;
		}
		if ([MSFUtils.complateCustInfo isEqualToString:@"111"]) {
			MSFInventoryViewModel *viewModel = [[MSFInventoryViewModel alloc] initWithCashViewModel:self.viewModel];
			MSFInventoryViewController *certifivatesVC = [[MSFInventoryViewController alloc] initWithViewModel:viewModel];
			[self.navigationController pushViewController:certifivatesVC animated:YES];
		} else {
			[SVProgressHUD showErrorWithStatus:@"请先完善资料"];
		}
	}];
	
	[_headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
		@strongify(self)
		make.top.equalTo(self.view).offset(64);
		make.left.equalTo(self.view);
		make.right.equalTo(self.view);
		make.height.equalTo(self.headerImageView.mas_width).multipliedBy(0.463);
	}];
	
	[_circleView mas_makeConstraints:^(MASConstraintMaker *make) {
		@strongify(self)
		make.top.equalTo(self.headerImageView.mas_bottom).offset(30);
		make.centerX.equalTo(self.view);
		make.width.equalTo(self.view.mas_width).multipliedBy(0.8);
		make.height.equalTo(self.circleView.mas_width);
	}];
	
	[_nextStepButton mas_makeConstraints:^(MASConstraintMaker *make) {
		@strongify(self)
		make.bottom.equalTo(self.view).offset(-20);
		make.left.equalTo(self.view).offset(20);
		make.right.equalTo(self.view).offset(-20);
		make.height.equalTo(@40);
	}];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.viewModel.formViewModel.active = NO;
	self.viewModel.formViewModel.active = YES;
}

- (void)back {
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)onClickCircle:(NSInteger)index {
	switch (index) {
		case 0: {
			MSFPersonalViewModel *viewModel = [[MSFPersonalViewModel alloc] initWithFormsViewModel:self.viewModel.formViewModel];
			[self.services pushViewModel:viewModel];
			break;
		}
		case 1: {
			MSFRelationshipViewModel *viewModel = [[MSFRelationshipViewModel alloc] initWithFormsViewModel:self.viewModel.formViewModel];
			[self.services pushViewModel:viewModel];
			break;
		}
		case 2: {
			MSFProfessionalViewModel *viewModel = [[MSFProfessionalViewModel alloc] initWithFormsViewModel:self.viewModel.formViewModel];
			[self.services pushViewModel:viewModel];
			break;
		}
	}
}

#pragma mark - Setter

- (void)setShowNextStep:(BOOL)showNextStep {
	_showNextStep = showNextStep;
	_nextStepButton.hidden = !showNextStep;
}

@end
