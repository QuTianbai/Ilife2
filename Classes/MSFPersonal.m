//
// MSFPersonal.m
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFPersonal.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation MSFPersonal

+ (NSSet *)propertyKeys {
	NSMutableSet *keys = [super.propertyKeys mutableCopy];

	// This is a derived property.
	[keys removeObject:@keypath(MSFPersonal.new, server)];

	return keys;
}

@end
