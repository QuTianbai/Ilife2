//
// MSFTextField.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFTextField.h"
#import "UIColor+Utils.h"

@implementation MSFTextField

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
	self.borderStyle = UITextBorderStyleNone;
	self.clearButtonMode = UITextFieldViewModeWhileEditing;
	self.layer.cornerRadius = 2;
	self.layer.masksToBounds = YES;
	self.layer.borderColor = UIColor.borderColor.CGColor;
	self.layer.borderWidth = 1.0f;
	self.offsetBounds = 40;
	self.offsetBoundsRight = 100;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
	return CGRectMake(CGRectGetMinX(bounds) + self.offsetBounds,
		CGRectGetMinY(bounds),
		CGRectGetWidth(bounds) - self.offsetBoundsRight,
		CGRectGetHeight(bounds));
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
	return CGRectMake(CGRectGetMinX(bounds) + self.offsetBounds,
		CGRectGetMinY(bounds),
		CGRectGetWidth(bounds) - self.offsetBoundsRight,
		CGRectGetHeight(bounds));
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
	if (!self.disablePaste) {
		return [super canPerformAction:action withSender:sender];
	}
	
	return NO;
}

@end
