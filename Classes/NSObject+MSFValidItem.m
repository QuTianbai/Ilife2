//
//  NSObject+MSFValidItem.m
//  Finance
//
//  Created by 赵勇 on 10/20/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "NSObject+MSFValidItem.h"

@implementation NSObject(MSFValidItem)

- (NSString *)stringForKey:(NSString *)key {
	if (![self isKindOfClass:NSDictionary.class]) {
		return @"";
	}
	id obj = [((NSDictionary *)self) objectForKey:key];
	if ([obj isKindOfClass:NSString.class]) {
		return obj;
	} else if	([obj isKindOfClass:NSNumber.class]) {
		return [obj stringValue];
	} else {
		return @"";
	}
}

- (NSArray *)arrayForKey:(NSString *)key {
	if (![self isKindOfClass:NSDictionary.class]) {
		return @[];
	}
	id obj = [((NSDictionary *)self) objectForKey:key];
	if ([obj isKindOfClass:NSArray.class]) {
		return obj;
	} else {
		return @[];
	}
}

- (NSDictionary *)dictionaryForKey:(NSString *)key {
	if (![self isKindOfClass:NSDictionary.class]) {
		return @{};
	}
	id obj = [((NSDictionary *)self) objectForKey:key];
	if ([obj isKindOfClass:NSDictionary.class]) {
		return obj;
	} else {
		return @{};
	}
}


- (NSString *)trimString:(NSString *)aString {
	if ([aString isKindOfClass:NSString.class]) {
		return [aString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	} else {
		return @"";
	}
}

@end
