//
// MSFCard.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFCard.h"
#import <Mantle/EXTKeyPathCoding.h>

@implementation MSFCard

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
		@"cardID": @"bankCardId",
		@"number": @"bankCardNo",
		@"type": @"bankCardType",
		@"code": @"bank_code",
		@"city": @"bankBranchCityCode",
		@"province": @"bankBranchProvinceCode",
		@"master": @"master",
	};
}

+ (NSSet *)propertyKeys {
	NSMutableSet *keys = [super.propertyKeys mutableCopy];

	// This is a derived property.
	[keys removeObject:@keypath(MSFCard.new, server)];
	[keys removeObject:@keypath(MSFCard.new, objectID)];

	return keys;
}

@end
