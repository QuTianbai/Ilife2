//
//  MSFBPTextField.m
//  Finance
//
//  Created by tian.xu on 15/8/13.
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFBPTextField.h"

@implementation MSFBPTextField

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
	self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder
	attributes:@{NSForegroundColorAttributeName: [UIColor grayColor]}];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
	return NO;
	
}

@end
