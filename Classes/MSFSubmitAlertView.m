//
//  MSFSubmitAlertView.m
//  MSFAlertViewDemo
//
//  Created by tian.xu on 15/7/30.
//  Copyright (c) 2015年 xutian. All rights reserved.
//

#import "MSFSubmitAlertView.h"
#import "MSFCommandView.h"

@implementation MSFSubmitAlertView

- (void)drawRect:(CGRect)rect {
	[_loanConfirmAlertView setClipsToBounds:YES];
	[_loanConfirmAlertView.layer setCornerRadius:7];
	[_loanConfirmLabel setTextColor:[MSFCommandView getColorWithString:@"#007ee5"]];
	[self setBackgroundColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.2]];
	//self.backgroundColor = [UIColor clearColor];
	//self.backGroundView.alpha = 0.2;
	//self.alpha = 0.5;
//	NSArray *array = self.subviews;
//	for (UIView *view in array) {
//		view.alpha = 1;
//	}
}

@end
