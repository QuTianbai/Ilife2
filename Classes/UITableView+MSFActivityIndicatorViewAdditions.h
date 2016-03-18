//
// UITableView+MSFActivityIndicatorViewAdditions.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RACSignal;

@interface UITableView (MSFActivityIndicatorViewAdditions)

// 列表默认图
//
// signal - 列表数据下载新信号，信号执行
- (UIView *)viewWithSignal:(RACSignal *)signal message:(NSString *)message AndImage:(UIImage *)image;

@end
