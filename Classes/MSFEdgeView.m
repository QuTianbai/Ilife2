//
// MSFEdgeView.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFEdgeView.h"
#import "UIColor+Utils.h"

@implementation MSFEdgeView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	if (!(self = [super initWithCoder:aDecoder])) {
		return nil;
	}
	[self commonInit];
	return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
	if (!(self = [super initWithFrame:frame])) {
		return nil;
	}
	[self commonInit];
	return self;
}

- (void)commonInit {
	self.layer.cornerRadius = 2;
	self.layer.masksToBounds = YES;
	self.layer.borderColor = UIColor.borderColor.CGColor;
	self.layer.borderWidth = 1.0f;
	self.offsetBounds = 40;
}

@end
