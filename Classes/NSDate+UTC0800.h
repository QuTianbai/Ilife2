//
// NSDate+UTC0800.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (UTC0800)

+ (NSDate *)msf_date;
+ (NSDate *)msf_date:(NSDate *)date;
+ (NSDate *)max_date;

@end
