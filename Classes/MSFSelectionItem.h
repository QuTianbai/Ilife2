//
// MSFSelectionItem.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <Foundation/Foundation.h>

// 选取列表兼容对象协议
//
// 对象数组，如果需要提供选取功能，则数组中的每一个的对象需要支持此协议
// 此协议内容用于列表中标题/详细的显示
@protocol MSFSelectionItem <NSObject>

// 选取列表中的标题
- (NSString *)title;

// 选取列表中的详细
- (NSString *)subtitle;

@end
