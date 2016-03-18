//
// MSFSocialProfile.m
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFSocialProfile.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation MSFSocialProfile

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
		@keypath(MSFSocialProfile.new, objectID): @"id"
	};
}

+ (NSSet *)propertyKeys {
	NSMutableSet *keys = [super.propertyKeys mutableCopy];

	// This is a derived property.
	[keys removeObject:@keypath(MSFSocialProfile.new, server)];

	return keys;
}

@end
