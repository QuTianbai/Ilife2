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

@interface MSFApplyView ()

@property (nonatomic, assign) MSFApplyViewType type;

@end

@implementation MSFApplyView

- (instancetype)initWithStatus:(MSFApplyViewType)type {
	self = [super init];
	if (self) {
		_type = type;
		switch (type) {
			case MSFApplyViewTypeMS:
				[self setUpMS];
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
	adImageView.clipsToBounds = YES;
	adImageView.contentMode = UIViewContentModeScaleToFill;
	adImageView.image = [UIImage imageNamed:@"ad_msd"];
	[self addSubview:adImageView];
	[adImageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self).offset(8);
		make.bottom.equalTo(self).offset(-4);
		make.centerX.equalTo(self);
		make.width.equalTo(adImageView.mas_height).multipliedBy(1.379);
	}];
}

- (void)setUpML {
	self.backgroundColor = UIColor.clearColor;
	UIImageView *adImageView = [[UIImageView alloc] init];
	adImageView.clipsToBounds = YES;
	adImageView.contentMode = UIViewContentModeScaleToFill;
	adImageView.image = [UIImage imageNamed:@"ad_mld"];
	[self addSubview:adImageView];
	[adImageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self).offset(4);
		make.bottom.equalTo(self).offset(-8);
		make.centerX.equalTo(self);
		make.width.equalTo(adImageView.mas_height).multipliedBy(1.379);
	}];
}

- (void)setUpMSFull {
	self.backgroundColor = UIColor.msdFullBackgroundColor;
	
	UIImageView *top = [[UIImageView alloc] init];
	top.contentMode = UIViewContentModeScaleAspectFill;
	top.image = [UIImage imageNamed:@"ad_msdFull_top"];
	[self addSubview:top];
	
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.backgroundColor = [UIColor clearColor];
	[button setBackgroundImage:[UIImage imageNamed:@"ad_msdFull_button"] forState:UIControlStateNormal];
	[button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:button];
	
	UIImageView *bottom = [[UIImageView alloc] init];
	bottom.contentMode = UIViewContentModeScaleAspectFill;
	bottom.image = [UIImage imageNamed:@"ad_msdFull_bottom"];
	[self addSubview:bottom];
	
	[top mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self);
		make.left.equalTo(self);
		make.right.equalTo(self);
		make.height.equalTo(self.mas_width).multipliedBy(0.737);
	}];
	[button mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(top.mas_bottom).offset(25);
		make.centerX.equalTo(self);
		make.width.equalTo(self.mas_width).multipliedBy(0.652);
		make.height.equalTo(button.mas_width).multipliedBy(0.179);
	}];
	[bottom mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self);
		make.right.equalTo(self);
		make.bottom.equalTo(self);
		make.height.equalTo(self.mas_width).multipliedBy(0.446);
	}];
}

- (void)onClick:(UIButton *)sender {
	
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
