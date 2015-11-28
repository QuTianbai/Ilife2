//
//  MSFHomePageContentView.m
//  Finance
//
//  Created by 赵勇 on 11/28/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFHomePageContentView.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "UIColor+Utils.h"

@interface MSFHomePageCellContentView ()

@end

@implementation MSFHomePageCellContentView

- (instancetype)init {
	self = [super init];
	if (self) {
		
		UILabel *title = [[UILabel alloc] init];
		title.font = [UIFont boldSystemFontOfSize:20];
		title.textColor = UIColor.themeColorNew;
		
		UIButton *status = [UIButton buttonWithType:UIButtonTypeCustom];
		status.layer.cornerRadius = 5;
		status.layer.borderColor = UIColor.themeColorNew.CGColor;
		status.layer.borderWidth = 1;
		status.titleLabel.font = [UIFont systemFontOfSize:15];
		[status setTitleColor:UIColor.themeColor forState:UIControlStateNormal];
		
		UILabel *unit = [[UILabel alloc] init];
		unit.font = [UIFont boldSystemFontOfSize:25];
		unit.textColor = UIColor.themeColorNew;
		
		UILabel *amount = [[UILabel alloc] init];
		amount.font = [UIFont boldSystemFontOfSize:40];
		amount.textColor = UIColor.themeColorNew;
		
		UILabel *info = [[UILabel alloc] init];
		info.font = [UIFont systemFontOfSize:14];
		info.textColor = UIColor.lightGrayColor;
		
		[self addSubview:title];
		
	}
	return self;
}

@end
