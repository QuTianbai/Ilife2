//
//  MSFSignUpButton.m
//  Finance
//
//  Created by xbm on 16/2/18.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFSignUpButton.h"
#import "UIColor+Utils.h"
#import <UIColor-Hex/UIColor+Hex.h>

@implementation MSFSignUpButton

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	if (!(self = [super initWithCoder:aDecoder])) {
		return nil;
	}
	self.backgroundColor = [UIColor colorWithHex:0x0ea5fb];
	self.tintColor = [UIColor fontColor];
	self.layer.cornerRadius = 5;
	self.layer.borderWidth = 1.5;
	self.layer.borderColor = [UIColor buttonBorderColor].CGColor;
	
	return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
	if (!(self = [super initWithFrame:frame])) {
		return nil;
	}
	self.backgroundColor = [UIColor colorWithHex:0x0ea5fb];
	self.tintColor = [UIColor fontColor];
	self.layer.cornerRadius = 5;
	self.layer.borderWidth = 1.5;
	self.layer.borderColor = [UIColor buttonBorderColor].CGColor;
	
	return self;
}

@end
