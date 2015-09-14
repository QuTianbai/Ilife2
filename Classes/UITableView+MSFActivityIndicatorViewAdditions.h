//
// UITableView+MSFActivityIndicatorViewAdditions.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RACSignal;

@interface UITableView (MSFActivityIndicatorViewAdditions)

- (UIView *)viewWithSignal:(RACSignal *)signal message:(NSString *)message AndImage:(UIImage *)image;

@end
