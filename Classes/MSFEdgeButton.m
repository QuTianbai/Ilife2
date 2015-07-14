//
// MSFButton.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFEdgeButton.h"
#import "UIColor+Utils.h"

@implementation MSFEdgeButton

- (instancetype)initWithFrame:(CGRect)frame {
	if (!(self = [super initWithFrame:frame])) {
		return nil;
	}
	self.layer.cornerRadius = 5.0f;
	self.layer.masksToBounds = YES;
	//self.titleLabel.font = [UIFont systemFontOfSize:[UIFont buttonFontSize]];
	self.backgroundColor = [UIColor themeColor];
	
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	if (!(self = [super initWithCoder:aDecoder])) {
		return nil;
	}
	self.layer.cornerRadius = 5.0f;
	self.layer.masksToBounds = YES;
	//self.titleLabel.font = [UIFont systemFontOfSize:[UIFont buttonFontSize]];
	self.backgroundColor = [UIColor themeColor];
	
	return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	if (self.enabled) {
		self.layer.borderColor = UIColor.borderColor.CGColor;
		self.titleLabel.textColor = UIColor.fontColor;
	}
	else {
		self.layer.borderColor = UIColor.lightGrayColor.CGColor;
		self.titleLabel.textColor = UIColor.lightGrayColor;
	}
}

@end
