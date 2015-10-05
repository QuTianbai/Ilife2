//
//  MSFGrayButton.m
//  Finance
//
//  Created by xbm on 15/10/1.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFGrayButton.h"
#import "UIColor+Utils.h"

@implementation MSFGrayButton

- (void)layoutSubviews {
	[super layoutSubviews];
	if (self.enabled) {
		self.layer.borderColor = UIColor.borderColor.CGColor;
		self.titleLabel.textColor = [UIColor grayColor];
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

@end
