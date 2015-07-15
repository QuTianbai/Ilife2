//
// UITextField+RACKeyboardSupport.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RACSignal;

@interface UITextField (RACKeyboardSupport)

// https://gist.github.com/lukeredpath/9051769
- (RACSignal *)rac_keyboardReturnSignal;

@end
