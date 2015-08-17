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
	formatter.dateFormat = @"yyyy/MM/dd";
	formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
	
	return [formatter stringFromDate:date];
}

+ (NSString *)msf_stringFromDateForDash:(NSDate *)date {
	NSParameterAssert(date != nil);
	
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
	formatter.dateFormat = @"yyyy-MM-dd";
	formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
	
	return [formatter stringFromDate:date];
}

+ (NSString *)msf_Chinese_stringFromDateString:(NSString *)str {
	NSParameterAssert(str != nil);
	
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
	formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
	formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
	NSDate *date = [formatter dateFromString:str];
	formatter.dateFormat = @"yyyy年MM月dd日";
	return [formatter stringFromDate:date];
}

+ (NSString *)msf_Chinese_stringFromDate:(NSDate *)str {
	NSParameterAssert(str != nil);
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
	formatter.dateFormat = @"yyyy年MM月dd日";
	formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
	
	return [formatter stringFromDate:str];
}

@end
