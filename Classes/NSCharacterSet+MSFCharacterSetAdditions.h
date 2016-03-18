//
// NSCharacterSet+MSFCharacterSetAdditions.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSCharacterSet (MSFCharacterSetAdditions)

// 中文姓名编码字符集合
+ (NSCharacterSet *)chineseCharacterSet;

// 身份证号编码字符集合
+ (NSCharacterSet *)identifyCardCharacterSet;

// 数字编码字符集合
+ (NSCharacterSet *)numberCharacterSet;

@end
