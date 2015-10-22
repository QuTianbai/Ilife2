//
// NSDate+UTC0800.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "NSDate+UTC0800.h"

@implementation NSDate (UTC0800)

+ (NSDate *)msf_date {
	return [NSDate msf_date:[NSDate date]];
}

+ (NSDate *)msf_date:(NSDate *)date {
	NSDate *anyDate = date;
 //设置源日期时区
	NSTimeZone *sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
	//设置转换后的目标日期时区
	NSTimeZone *destinationTimeZone = [NSTimeZone localTimeZone];
	//得到源日期与世界标准时间的偏移量
	NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
	//目标日期与本地时区的偏移量
	NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
	//得到时间偏移量的差值
	NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
	//转为现在时间
	NSDate *destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
	
	return destinationDateNow;
}

+ (NSDate *)max_date {
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDate *currentDate = [NSDate msf_date];
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	comps.year = 20;
	comps.month = 12;
	comps.day = 31;
	NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
	return maxDate;
}

@end
