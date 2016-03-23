//
// MSFBlurView.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFBlurView.h"

@implementation MSFBlurView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	if (!(self = [super initWithCoder:aDecoder])) {
		return nil;
	}
	self.backgroundColor = [UIColor lightGrayColor];
	self.alpha = 0.2;
	self.layer.cornerRadius = 5;
	self.layer.masksToBounds = YES;
	
	return self;
}

@end
