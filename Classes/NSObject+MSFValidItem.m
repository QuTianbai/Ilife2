//
//  NSObject+MSFValidItem.m
//  Finance
//
//  Created by 赵勇 on 10/20/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "NSObject+MSFValidItem.h"


@implementation NSObject(MSFValidItem)

- (NSString *)validString {
	if ([self isKindOfClass:NSString.class]) {
		return (NSString *)self;
	} else if ([self isKindOfClass:NSNumber.class]) {
		return ((NSNumber *)self).stringValue;
	} else {
		return @"";
	}
}

- (NSArray *)validArray {
	if ([self isKindOfClass:NSArray.class]) {
		return (NSArray *)self;
	} else {
		return @[];
	}
}

- (NSDictionary *)validDictionary {
	if ([self isKindOfClass:NSDictionary.class]) {
		return (NSDictionary *)self;
	} else {
		return @{};
	}
}

- (NSString *)trimmedString {
	if ([self isKindOfClass:NSString.class]) {
		return [(NSString *)self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	} else {
		return @"";
	}
}

@end
