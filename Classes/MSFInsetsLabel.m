//
//  MSFInsetsLabel.m
//  Finance
//
//  Created by 赵勇 on 12/17/15.
//  Copyright © 2015 MaShang Consumer Finance Co., Ltd. All rights reserved.
//

#import "MSFInsetsLabel.h"
#import <Masonry/Masonry.h>

@interface MSFInsetsLabel ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation MSFInsetsLabel

- (instancetype)init {
	self = [super init];
	if (self) {
		self.clipsToBounds = YES;
		self.layer.cornerRadius = 3;
		_label = [[UILabel alloc] init];
		_label.font = [UIFont systemFontOfSize:15];
		[self addSubview:_label];
		[_label mas_remakeConstraints:^(MASConstraintMaker *make) {
			make.edges.equalTo(self);
		}];
	}
	return self;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
	[super setBackgroundColor:backgroundColor];
	if (backgroundColor == UIColor.clearColor) {
		[_label mas_remakeConstraints:^(MASConstraintMaker *make) {
			make.edges.equalTo(self);
		}];
	} else {
		[_label mas_remakeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self).offset(10);
			make.right.equalTo(self).offset(-10);
			make.top.bottom.equalTo(self);
		}];
	}
}

- (void)setTextColor:(UIColor *)textColor {
	_textColor = textColor;
	_label.textColor = textColor;
}

- (void)setText:(NSString *)text {
	_text = text;
	_label.text = text;
}

- (void)setFont:(UIFont *)font {
	_font = font;
	_label.font = font;
}

@end
