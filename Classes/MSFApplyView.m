//
//  MSFApplyView.m
//  Finance
//
//  Created by 赵勇 on 11/20/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFApplyView.h"
#import <Masonry/Masonry.h>
#import "UIColor+Utils.h"

@interface MSFApplyView ()<UIGestureRecognizerDelegate>

@property (nonatomic, assign, readwrite) MSFApplyViewType type;
@property (nonatomic, copy) void(^actionBlock)();

@end

@implementation MSFApplyView

- (instancetype)initWithStatus:(MSFApplyViewType)type actionBlock:(void (^)())action {
	self = [super init];
	if (self) {
		_actionBlock = action;
		_type = type;
		switch (type) {
			case MSFApplyViewTypeMS:
				[self setUpMS];
				break;
			case MSFApplyViewTypeLimitMS:
				[self setUpLimitMS];
				break;
			case MSFApplyViewTypeML:
				[self setUpML];
				break;
			case MSFApplyViewTypeMSFull:
				[self setUpMSFull];
				break;
		}
	}
	return self;
}

- (void)setUpMS {
	self.backgroundColor = UIColor.clearColor;
	UIImageView *adImageView = [[UIImageView alloc] init];
	adImageView.layer.cornerRadius = 10;
	adImageView.clipsToBounds = YES;
	adImageView.contentMode = UIViewContentModeScaleAspectFill;
	adImageView.image = [UIImage imageNamed:@"ad_msd"];
	adImageView.userInteractionEnabled = YES;
	[self addSubview:adImageView];
	
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.backgroundColor = [UIColor clearColor];
	[button setBackgroundImage:[UIImage imageNamed:@"ad_msd_bt"] forState:UIControlStateNormal];
	[button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:button];
	
	[adImageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self).offset(6);
		make.left.equalTo(self).offset(12);
		make.right.bottom.equalTo(self).offset(-12);
	}];
	[button mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.equalTo(self).offset(-20);
		make.centerX.equalTo(self);
		make.width.equalTo(self).multipliedBy(0.5);
		make.height.equalTo(button.mas_width).multipliedBy(0.224);
	}];
}

- (void)setUpLimitMS {
	self.backgroundColor = UIColor.clearColor;
	UIImageView *adImageView = [[UIImageView alloc] init];
	adImageView.clipsToBounds = YES;
	adImageView.contentMode = UIViewContentModeScaleAspectFill;
	adImageView.image = [UIImage imageNamed:@"ad_limit_ms"];
	adImageView.userInteractionEnabled = YES;
	[self addSubview:adImageView];
	
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.backgroundColor = UIColor.themeColorNew;
	button.layer.cornerRadius = 5;
	[button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
	[button setTitle:@"立即申请" forState:UIControlStateNormal];
	[button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:button];
	
	[adImageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self);
	}];
	[button mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self).offset(40);
		make.right.equalTo(self).offset(-40);
		make.bottom.equalTo(self).offset(-20);
		make.height.equalTo(@40);
	}];
}

- (void)setUpML {
	self.backgroundColor = UIColor.clearColor;
	UIImageView *adImageView = [[UIImageView alloc] init];
	adImageView.layer.cornerRadius = 10;
	adImageView.clipsToBounds = YES;
	adImageView.contentMode = UIViewContentModeScaleAspectFill;
	adImageView.image = [UIImage imageNamed:@"ad_mld"];
	adImageView.userInteractionEnabled  = YES;
	[self addSubview:adImageView];
	
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.backgroundColor = [UIColor clearColor];
	[button setBackgroundImage:[UIImage imageNamed:@"ad_mld_bt"] forState:UIControlStateNormal];
	[button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:button];
	
	[adImageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.left.equalTo(self).offset(12);
		make.right.equalTo(self).offset(-12);
		make.bottom.equalTo(self).offset(-6);
	}];
	[button mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.equalTo(self).offset(-40);
		make.centerX.equalTo(self);
		make.width.equalTo(self).multipliedBy(0.5);
		make.height.equalTo(button.mas_width).multipliedBy(0.224);
	}];
}

- (void)setUpMSFull {
	self.backgroundColor = UIColor.msdFullBackgroundColor;
	
	UIImageView *bottom = [[UIImageView alloc] init];
	bottom.contentMode = UIViewContentModeScaleAspectFill;
	bottom.image = [UIImage imageNamed:@"ad_msdFull_bottom"];
	[self addSubview:bottom];
	
	UIImageView *top = [[UIImageView alloc] init];
	top.contentMode = UIViewContentModeScaleAspectFill;
	top.image = [UIImage imageNamed:@"ad_msdFull_top"];
	[self addSubview:top];
	
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.backgroundColor = [UIColor clearColor];
	[button setBackgroundImage:[UIImage imageNamed:@"ad_msdFull_button"] forState:UIControlStateNormal];
	[button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:button];
	
	[top mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.left.right.equalTo(self);
		make.height.equalTo(self.mas_width).multipliedBy(0.737);
	}];
	[button mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(top.mas_bottom).offset(25);
		make.centerX.equalTo(self);
		make.width.equalTo(self.mas_width).multipliedBy(0.652);
		make.height.equalTo(button.mas_width).multipliedBy(0.179);
	}];
	[bottom mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.right.bottom.equalTo(self);
		make.height.equalTo(self.mas_width).multipliedBy(0.446);
	}];
}

- (void)onClick:(UIButton *)sender {
	if (_actionBlock) {
		_actionBlock();
	}
}

@end
