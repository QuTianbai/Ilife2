//
// NSDate+UTC0800.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (UTC0800)

// Get current Timezone date
+ (NSDate *)msf_date;

// Translate date to Timezone date
+ (NSDate *)msf_date:(NSDate *)date;

// The app max date 2019-12-31
+ (NSDate *)max_date;

@end
