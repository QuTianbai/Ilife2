//
// UITextField+RACKeyboardSupport.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "UITextField+RACKeyboardSupport.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation UITextField (RACKeyboardSupport)

- (RACSignal *)rac_keyboardReturnSignal {
	@weakify(self);
	return [[[[[RACSignal
		defer:^{
			@strongify(self);
			return [RACSignal return:self];
		}]
		skip:1]
		concat:[self rac_signalForControlEvents:UIControlEventEditingDidEndOnExit]]
		takeUntil:self.rac_willDeallocSignal]
		setNameWithFormat:@"%@ -rac_keyboardReturnSignal", self.class];
}

@end
