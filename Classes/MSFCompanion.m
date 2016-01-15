//
// MSFCompanion.m
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFCompanion.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation MSFCompanion

+ (NSSet *)propertyKeys {
	NSMutableSet *keys = [super.propertyKeys mutableCopy];

	// This is a derived property.
	[keys removeObject:@keypath(MSFCompanion.new, objectID)];
	[keys removeObject:@keypath(MSFCompanion.new, server)];

	return keys;
}

@end
