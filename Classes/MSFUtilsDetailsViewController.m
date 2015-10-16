//
// MSFUtilsDetailsViewController.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFUtilsDetailsViewController.h"
#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <SVProgressHUD/SVProgressHUD.h>

@implementation MSFUtilsDetailsViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = UIColor.whiteColor;
	UITextField *textField = [[UITextField alloc] initWithFrame:CGRectZero];
	textField.borderStyle = UITextBorderStyleRoundedRect;
	[self.view addSubview:textField];
	
	UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
	[button setTitle:@"保存" forState:UIControlStateNormal];
	[self.view addSubview:button];
	
	
	[textField mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.equalTo(@300);
		make.height.equalTo(@37);
		make.centerX.equalTo(self.view.mas_centerX);
		make.top.offset(100);
	}];
	
	[button mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.equalTo(@280);
		make.height.equalTo(@37);
		make.centerX.equalTo(self.view.mas_centerX);
		make.top.equalTo(textField).offset(100);
	}];
	
	@weakify(self)
	[[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
		@strongify(self)
		if (![textField.text hasPrefix:@"http"]) {
			[SVProgressHUD showErrorWithStatus:@"您输入的地址不正确"];
			return;
		}
		NSMutableArray *URLs = [[NSUserDefaults.standardUserDefaults objectForKey:@"test_urls"] mutableCopy] ?: NSMutableArray.new;
		[URLs addObject:textField.text];
		[NSUserDefaults.standardUserDefaults setObject:URLs forKey:@"test_urls"];
		[NSUserDefaults.standardUserDefaults synchronize];
		[self.navigationController popViewControllerAnimated:YES];
	}];
}

@end
