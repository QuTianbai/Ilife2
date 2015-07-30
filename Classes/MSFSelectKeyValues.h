//
//	MSFSelectKeyValues.h
//	Cash
//
//	Created by xbm on 15/5/25.
//	Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFObject.h"
#import "MSFSelectionItem.h"

// 本地JSON文件提供的选取内容
//
// 成员关系
// 贷款目的等
@interface MSFSelectKeyValues : MSFObject <MSFSelectionItem>

@property (nonatomic, copy, readonly) NSString *typeId;
@property (nonatomic, copy, readonly) NSString *code;
@property (nonatomic, copy, readonly) NSString *text;

// 获取选取对象数组
//
// fileName - 本地json文件名，不需要json后缀
//
// Return 用于选取的对象数组，每一个数组元素是MSFSelectKeyValues实例
+ (NSArray *)getSelectKeys:(NSString *)fileName;

@end
