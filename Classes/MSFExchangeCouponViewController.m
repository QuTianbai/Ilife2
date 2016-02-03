//
// MSFExchangeCouponViewController.m
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFExchangeCouponViewController.h"

@implementation MSFExchangeCouponViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.textField.layer.cornerRadius = 3.0f;
	self.textField.layer.masksToBounds = YES;
	self.textField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
	self.textField.layer.borderWidth = 1.0f;
}

@end
