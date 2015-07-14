//
// MSFBlurButton.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFBlurButton.h"

@implementation MSFBlurButton

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	if (!(self = [super initWithCoder:aDecoder])) {
		return nil;
	}
	self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.200];
	self.tintColor = [UIColor whiteColor];
	
	return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
	if (!(self = [super initWithFrame:frame])) {
		return nil;
	}
	self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.200];
	self.tintColor = [UIColor whiteColor];
	
	return self;
}

@end
