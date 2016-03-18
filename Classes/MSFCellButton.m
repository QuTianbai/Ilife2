//
//	MSFCellButton.m
//	Cash
//
//	Created by xutian on 15/6/3.
//	Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFCellButton.h"
#import "UIColor+Utils.h"

@implementation MSFCellButton

- (void)layoutSubviews {
	[super layoutSubviews];
	if (self.enabled) {
		self.layer.borderColor = UIColor.borderColor.CGColor;
		self.titleLabel.textColor = UIColor.fontColor;
		self.layer.cornerRadius = 7.0f;
		self.layer.masksToBounds = YES;
		self.layer.borderWidth = 1.0f;
	} else {
		self.layer.borderColor = UIColor.lightGrayColor.CGColor;
		self.titleLabel.textColor = UIColor.lightGrayColor;
		self.layer.cornerRadius = 0.0f;
		self.layer.masksToBounds = NO;
		self.layer.borderWidth = 0.0f;
	}
}

- (void)setSelected:(BOOL)selected {
	[super setSelected:selected];
	if (selected) {
		[self setBackgroundColor:UIColor.themeColor];
	} else {
		[self setBackgroundColor:UIColor.whiteColor];
	}
}

@end
