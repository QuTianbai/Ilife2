//
// MSFBlurButton.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFBlurButton.h"
#import "UIColor+Utils.h"

@implementation MSFBlurButton

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	if (!(self = [super initWithCoder:aDecoder])) {
		return nil;
	}
	self.backgroundColor = [UIColor navigationBgColor];
	self.tintColor = [UIColor fontColor];
	self.layer.cornerRadius = 5;
	
	return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
	if (!(self = [super initWithFrame:frame])) {
		return nil;
	}
	self.backgroundColor = [UIColor navigationBgColor];
	self.tintColor = [UIColor fontColor];
	self.layer.cornerRadius = 5;
	
	return self;
}

@end
