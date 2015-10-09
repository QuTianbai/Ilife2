//
// NSDateFormatter+MSFFormattingAdditions.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (MSFFormattingAdditions)

// 2015-08-01
+ (NSDate *)msf_dateFromString:(NSString *)str;
+ (NSString *)msf_fullStringFromDate:(NSDate *)date;
+ (NSString *)msf_stringFromDate:(NSDate *)date;
+ (NSString *)msf_stringFromDate2:(NSDate *)date;
+ (NSString *)msf_stringFromDate3:(NSDate *)date;
// 2015年08月01日
+ (NSString *)msf_Chinese_stringFromDateString:(NSString *)str;
+ (NSString *)msf_Chinese_stringFromDate:(NSDate *)date;

// 2015/08/01
+ (NSString *)msf_stringFromDateForDash:(NSDate *)date;

@end
