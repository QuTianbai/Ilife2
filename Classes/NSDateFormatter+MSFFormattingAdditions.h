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

@end
