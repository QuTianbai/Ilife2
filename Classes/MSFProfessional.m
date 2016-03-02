//
// MSFProfessional.m
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFProfessional.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation MSFProfessional

+ (NSSet *)propertyKeys {
	NSMutableSet *keys = [super.propertyKeys mutableCopy];

	// This is a derived property.
	[keys removeObject:@keypath(MSFProfessional.new, server)];

	return keys;
}

@end
