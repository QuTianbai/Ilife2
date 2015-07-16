//
// MSFAuthorizationView.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFAuthorizationView.h"
#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFTabBarViewModel.h"
#import "UIColor+Utils.h"

@implementation MSFAuthorizationView

- (instancetype)initWithFrame:(CGRect)frame {
  if (!(self = [super initWithFrame:frame])) {
    return nil;
  }
	UIView *container = [[UIView alloc] init];
	container.backgroundColor = [UIColor whiteColor];
	UIImageView *imageView = [[UIImageView alloc] init];
	imageView.image = [UIImage imageNamed:@"bk-iphone6plus.jpg"];
	
	[self addSubview:container];
	[self addSubview:imageView];
	
	[imageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.mas_top);
		make.left.equalTo(self.mas_left);
		make.right.equalTo(self.mas_right);
		make.bottom.equalTo(container.mas_top);
	}];
	
	[container mas_makeConstraints:^(MASConstraintMaker *make) {
		make.height.equalTo(@50);
		make.bottom.equalTo(self.mas_bottom);
		make.left.equalTo(self.mas_left);
		make.right.equalTo(self.mas_right);
	}];
	
	_signInButton = [UIButton buttonWithType:UIButtonTypeCustom];
	_signUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[_signInButton setTitle:@"登录" forState:UIControlStateNormal];
	[_signInButton setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
	[_signUpButton setTitle:@"注册" forState:UIControlStateNormal];
	[_signUpButton setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
	[container addSubview:_signInButton];
	[container addSubview:_signUpButton];
	[_signInButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.height.equalTo(container.mas_height);
		make.top.equalTo(container.mas_top);
		make.bottom.equalTo(container.mas_bottom);
		make.left.equalTo(container.mas_left);
		make.right.equalTo(_signUpButton.mas_left).offset(-2);
	}];
	[_signUpButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(container.mas_top);
		make.bottom.equalTo(container.mas_bottom);
		make.right.equalTo(container.mas_right);
		make.height.equalTo(_signInButton);
		make.width.equalTo(_signInButton);
	}];
	
	UIView *line = [[UIView alloc] init];
	line.backgroundColor = [UIColor themeColor];
	[container addSubview:line];
	[line mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(container.mas_top).offset(10);
		make.bottom.equalTo(container.mas_bottom).offset(-10);
		make.left.equalTo(_signInButton.mas_right);
		make.right.equalTo(_signUpButton.mas_left);
	}];
	
  return self;
}

- (void)bindViewModel:(MSFTabBarViewModel *)viewModel {
	self.signInButton.rac_command = viewModel.signInCommand;
	self.signUpButton.rac_command = viewModel.signUpCommand;
}

@end
