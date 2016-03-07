//
// MSFSocialInsurance.m
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFSocialInsurance.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation MSFSocialInsurance

+ (NSSet *)propertyKeys {
	NSMutableSet *keys = [super.propertyKeys mutableCopy];

	// This is a derived property.
	[keys removeObject:@keypath(MSFSocialInsurance.new, server)];

	return keys;
}

@end
