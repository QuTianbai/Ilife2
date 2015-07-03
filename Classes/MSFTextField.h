//
// MSFTextField.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface MSFTextField : UITextField

@property(IBInspectable) BOOL disablePaste;
@property(IBInspectable) CGFloat offsetBounds;

@end
