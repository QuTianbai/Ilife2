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
#import <libextobjc/extobjc.h>

#import "MSFUserInfoCircleView.h"

#import "MSFPersonalViewModel.h"
#import "MSFProfessionalViewModel.h"
#import "MSFRelationshipViewModel.h"
#import "MSFApplyCashVIewModel.h"

#import "MSFClient+MSFApplyInfo.h"
#import "MSFApplicationForms.h"
#import "MSFFormsViewModel.h"
#import "MSFAddressViewModel.h"

#import "UIColor+Utils.h"

#import "MSFUtils.h"
#import "MSFInventoryViewModel.h"
#import "MSFCertificatesCollectionViewController.h"

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

- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
	
	self.navigationItem.title = @"个人信息";
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"left_arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
	
	_headerImageView = [[UIImageView alloc] init];
	_headerImageView.image = [UIImage imageNamed:@"userInfo_header.png"];
	[self.view addSubview:_headerImageView];
	
	@weakify(self)
	_circleView = [[MSFUserInfoCircleView alloc] init];
	[self.view addSubview:_circleView];
	_circleView.onClickBlock = ^(NSInteger index) {
		@strongify(self)
		[self onClickCircle:index];
	};
	
	_nextStepButton = [UIButton buttonWithType:UIButtonTypeSystem];
	_nextStepButton.backgroundColor = [UIColor themeColorNew];
	[_nextStepButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[_nextStepButton setTitle:@"下一步" forState:UIControlStateNormal];
	_nextStepButton.hidden = _showNextStep;
	_nextStepButton.layer.cornerRadius = 5;
	[self.view addSubview:_nextStepButton];
	//_nextStepButton.rac_command = self.viewModel.executeNextCommand;
	[[self.nextStepButton rac_signalForControlEvents:UIControlEventTouchUpInside]
	subscribeNext:^(id x) {
		if ([MSFUtils.complateCustInfo isEqualToString:@"111"]) {
			MSFInventoryViewModel *viewModel = [[MSFInventoryViewModel alloc] initWithFormsViewModel:self.viewModel];
			MSFCertificatesCollectionViewController *certifivatesVC = [[MSFCertificatesCollectionViewController alloc] initWithViewModel:viewModel];
			[self.navigationController pushViewController:certifivatesVC animated:YES];
		}
	}];
	
	[_headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
		@strongify(self)
		make.top.equalTo(self.view).offset(64);
		make.left.equalTo(self.view);
		make.right.equalTo(self.view);
		make.height.equalTo(self.headerImageView.mas_width).multipliedBy(0.267);
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

- (void)testCircle {
	BOOL b1 = arc4random() % 2 == 1;
	BOOL b2 = arc4random() % 2 == 1;
	BOOL b3 = arc4random() % 2 == 1;
	NSArray *testArray = @[@(b1), @(b2), @(b3)];
	[_circleView setCompeltionStatus:testArray];
}

- (void)back {
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)onClickCircle:(NSInteger)index {
	switch (index) {
		case 0: {
			MSFAddressViewModel *addrViewModel = [[MSFAddressViewModel alloc] initWithAddress:self.viewModel.formViewModel.currentAddress services:self.services];
			MSFPersonalViewModel *viewModel = [[MSFPersonalViewModel alloc] initWithFormsViewModel:self.viewModel.formViewModel addressViewModel:addrViewModel];
			[self.services pushViewModel:viewModel];
			break;
		}
		case 1: {
			MSFRelationshipViewModel *viewModel = [[MSFRelationshipViewModel alloc] initWithFormsViewModel:self.viewModel.formViewModel];
			[self.services pushViewModel:viewModel];
			break;
		}
		case 2: {
			MSFAddressViewModel *addrViewModel = [[MSFAddressViewModel alloc] initWithAddress:self.viewModel.formViewModel.currentAddress services:self.services];
			MSFProfessionalViewModel *viewModel = [[MSFProfessionalViewModel alloc] initWithFormsViewModel:self.viewModel.formViewModel addressViewModel:addrViewModel];
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
