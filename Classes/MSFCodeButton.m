//
// MSFCodeButton.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFCodeButton.h"

@implementation MSFCodeButton

- (instancetype)initWithFrame:(CGRect)frame {
	if (!(self = [super initWithFrame:frame])) {
		return nil;
	}
	self.layer.cornerRadius = 7.0f;
	self.layer.masksToBounds = YES;
	self.layer.borderColor = [[UIColor clearColor]CGColor];
	self.layer.borderWidth = 1.0f;
	self.backgroundColor = [UIColor colorWithRed:0.141 green:0.514 blue:0.886 alpha:1.000];
	
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	if (!(self = [super initWithCoder:aDecoder])) {
		return nil;
	}
	self.layer.cornerRadius = 7.0f;
	self.layer.masksToBounds = YES;
	self.layer.borderColor = [[UIColor clearColor]CGColor];
	self.layer.borderWidth = 1.0f;
	self.backgroundColor = [UIColor colorWithRed:0.141 green:0.514 blue:0.886 alpha:1.000];
	
	return self;
}

@end
