//
// MSFContact.m
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFContact.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation MSFContact

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
		@keypath(MSFContact.new, objectID): @"id"
	};
}

+ (NSSet *)propertyKeys {
	NSMutableSet *keys = [super.propertyKeys mutableCopy];

	// This is a derived property.
	[keys removeObject:@keypath(MSFContact.new, server)];

	return keys;
}

@end
