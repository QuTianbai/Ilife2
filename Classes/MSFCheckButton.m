//
// MSFCheckButton.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFCheckButton.h"

@implementation MSFCheckButton

#pragma mark - Lifecycle

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	if (!(self = [super initWithCoder:aDecoder])) {
		return nil;
	}
	[self initialize];
	
	return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
	if (!(self = [super initWithFrame:frame])) {
		return nil;
	}
	[self initialize];
	
	return nil;
}

#pragma mark - Private

- (void)initialize {
	[self setImage:[UIImage imageNamed:@"btn_uncheck"] forState:UIControlStateNormal];
	[self setImage:[UIImage imageNamed:@"btn_checked"] forState:UIControlStateSelected];
}

@end
