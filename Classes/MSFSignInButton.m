//
//  MSFSignInButton.m
//  Finance
//
//  Created by xbm on 16/2/18.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFSignInButton.h"
#import "UIColor+Utils.h"

@implementation MSFSignInButton

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	if (!(self = [super initWithCoder:aDecoder])) {
		return nil;
	}
	self.backgroundColor = [UIColor signInBgClolr];
	self.tintColor = [UIColor fontColor];
	self.layer.cornerRadius = 5;
	
	return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
	if (!(self = [super initWithFrame:frame])) {
		return nil;
	}
	self.backgroundColor = [UIColor signInBgClolr];
	self.tintColor = [UIColor fontColor];
	self.layer.cornerRadius = 5;
	
	return self;
}


@end
