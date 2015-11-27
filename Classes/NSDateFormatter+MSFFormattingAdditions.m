//
// NSDateFormatter+MSFFormattingAdditions.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "NSDateFormatter+MSFFormattingAdditions.h"
#import <ISO8601DateFormatter/ISO8601DateFormatter.h>

@implementation NSDateFormatter (MSFFormattingAdditions)

+ (NSDate *)msf_dateFromString:(NSString *)str {
	NSParameterAssert(str != nil);
	
	// ISO8601DateFormatter isn't thread-safe, because all instances share some
	// unsynchronized global state, so we want to always access it from the same
	// GCD queue and avoid any race conditions.
	static ISO8601DateFormatter *dateParsingFormatter;
	static dispatch_queue_t dateParsingQueue;
	static dispatch_once_t pred;
	
	dispatch_once(&pred, ^{
		dateParsingFormatter = [[ISO8601DateFormatter alloc] init];
		[dateParsingFormatter setIncludeTime:YES];
		[dateParsingFormatter setDefaultTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]]; // UTC
		dateParsingQueue = dispatch_queue_create("com.msfinance.NSDateFormatter", DISPATCH_QUEUE_SERIAL);
	});
	
	__block NSDate *date;
	dispatch_sync(dateParsingQueue, ^{
		date = [dateParsingFormatter dateFromString:str];
	});
	
	return date;
}

+ (NSString *)msf_stringFromDate:(NSDate *)date {
	NSParameterAssert(date != nil);
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
	formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
	formatter.dateFormat = @"yyyy-MM-dd";
	return [formatter stringFromDate:date];
}

+ (NSString *)professional_stringFromDate:(NSDate *)date {
	NSParameterAssert(date != nil);
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	formatter.dateFormat = @"yyyy-MM";
	return [formatter stringFromDate:date];
}

+ (NSString *)insurance_stringFromDate:(NSDate *)date {
	NSParameterAssert(date != nil);
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	formatter.dateFormat = @"yyyyMM";
	return [formatter stringFromDate:date];
}

+ (NSDate *)gmt_dateFromString:(NSString *)str {
	NSParameterAssert(str != nil);
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	formatter.dateFormat = @"EE, dd MM yyyy HH:mm:ss 'GMT'";
	formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
	formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
	return [formatter dateFromString:str];
}

+ (NSDate *)msf_dateFromString2:(NSString *)str {
	return [NSDate date];
}

+ (NSString *)msf_stringFromDate2:(NSDate *)date {
	return @"";
}

+ (NSString *)msf_stringFromDate3:(NSDate *)date {
	return @"";
}

+ (NSString *)msf_stringFromDate4:(NSDate *)date {
	return @"";
}

+ (NSString *)msf_stringFromDateForDash:(NSDate *)date {
	return @"";
}

+ (NSString *)msf_Chinese_stringFromDateString:(NSString *)str {
	return @"";
}

+ (NSString *)msf_Chinese_stringFromDate:(NSDate *)str {
	return @"";
}

@end
