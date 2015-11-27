//
// NSDateFormatter+MSFFormattingAdditions.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (MSFFormattingAdditions)

+ (NSDate *)msf_dateFromString:(NSString *)str;
+ (NSString *)msf_stringFromDate:(NSDate *)date;


+ (NSString *)professional_stringFromDate:(NSDate *)date;
+ (NSString *)insurance_stringFromDate:(NSDate *)date;

+ (NSDate *)gmt_dateFromString:(NSString *)str;

// 2015/08/01
+ (NSString *)msf_stringFromDateForDash:(NSDate *)date __deprecated;
+ (NSString *)msf_Chinese_stringFromDateString:(NSString *)str __deprecated;
+ (NSString *)msf_Chinese_stringFromDate:(NSDate *)date __deprecated;
+ (NSDate *)msf_dateFromString2:(NSString *)str __deprecated;
+ (NSString *)msf_stringFromDate3:(NSDate *)date __deprecated;
+ (NSString *)msf_stringFromDate2:(NSDate *)date __deprecated_msg("Use professional_stringFromDate:");
+ (NSString *)msf_stringFromDate4:(NSDate *)date __deprecated_msg("Use insurance_stringFromDate:");

@end
