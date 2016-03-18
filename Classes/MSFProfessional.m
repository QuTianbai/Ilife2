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

+ (NSValueTransformer *)otherLoanJSONTransformer {
	return [MTLValueTransformer transformerWithBlock:^id(id object) {
		return [object isKindOfClass:NSNumber.class]?[object stringValue]:object;
	}];
}

+ (NSValueTransformer *)otherIncomeJSONTransformer {
	return [MTLValueTransformer transformerWithBlock:^id(id object) {
		return [object isKindOfClass:NSNumber.class]?[object stringValue]:object;
	}];
}

+ (NSValueTransformer *)monthIncomeJSONTransformer {
	return [MTLValueTransformer transformerWithBlock:^id(id object) {
		return [object isKindOfClass:NSNumber.class]?[object stringValue]:object;
	}];
}

+ (NSValueTransformer *)lengthOfSchoolingJSONTransformer {
	return [MTLValueTransformer transformerWithBlock:^id(id object) {
		return [object isKindOfClass:NSNumber.class]?[object stringValue]:object;
	}];
}

@end
