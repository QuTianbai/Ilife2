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

@interface MSFUserInfomationViewController ()

@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) MSFUserInfoCircleView *circleView;

@end

@implementation MSFUserInfomationViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
	
	self.navigationItem.title = @"个人信息";
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"left_arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
	
	_headerImageView = [[UIImageView alloc] init];
	_headerImageView.image = [UIImage imageNamed:@"userInfo_header.png"];
	[self.view addSubview:_headerImageView];
	
	_circleView = [[MSFUserInfoCircleView alloc] init];
	[self.view addSubview:_circleView];
	_circleView.onClickBlock = ^(NSInteger index) {
		
	};
	
	UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
	button.titleLabel.textColor = [UIColor blueColor];
	[button setTitle:@"点我" forState:UIControlStateNormal];
	[self.view addSubview:button];
	
	@weakify(self)
	[[button rac_signalForControlEvents:UIControlEventTouchUpInside]
	 subscribeNext:^(id x) {
		 @strongify(self)
		[self testCircle];
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
	
	[button mas_makeConstraints:^(MASConstraintMaker *make) {
		@strongify(self)
		make.top.equalTo(self.circleView.mas_bottom).offset(20);
		make.centerX.equalTo(self.view);
		make.width.equalTo(@80);
		make.height.equalTo(@20);
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

@end
