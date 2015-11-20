//
//  MSFApplyView.m
//  Finance
//
//  Created by 赵勇 on 11/20/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFApplyView.h"

@interface MSFApplyView ()

@property (nonatomic, assign) MSFApplyViewStatus status;

@end

@implementation MSFApplyView

- (instancetype)initWithStatus:(MSFApplyViewStatus)status {
	self = [super init];
	if (self) {
		_status = status;
	}
	return self;
}

- (void)setUpMS {
	
}

- (void)setUpML {
	
}

- (void)setUpMSFull {
	
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
