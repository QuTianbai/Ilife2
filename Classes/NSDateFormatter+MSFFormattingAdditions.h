//
// NSDateFormatter+MSFFormattingAdditions.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (MSFFormattingAdditions)

+ (NSDate *)msf_dateFromString:(NSString *)str;

+ (NSString *)msf_stringFromDate:(NSDate *)date;

+ (NSString *)msf_Chinese_stringFromDate:(NSDate *)date;

@end
