//
// NSDateFormatter+MSFFormattingAdditions.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (MSFFormattingAdditions)

// Translate string to NSDate instance
//
// str - The parameter will fit UTC time style
+ (NSDate *)msf_dateFromString:(NSString *)str;

// Translate NSDate into `yyyy-MM-dd` style string
+ (NSString *)msf_stringFromDate:(NSDate *)date;

// 用户职业信息中使用到的时间字符串格式: `yyyy-MM`
+ (NSString *)professional_stringFromDate:(NSDate *)date;

// 用户社保信息中使用到的时间字符串个是: `yyyyMM`
+ (NSString *)insurance_stringFromDate:(NSDate *)date;

// GMT 时间字符串转时间，接口头信息中用于解析服务器返回的时间字符串
+ (NSDate *)gmt_dateFromString:(NSString *)str;

+ (NSDate *)gmt1_dateFromString:(NSString *)str;

@end
