//
// MSFLoanType.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFLoanType.h"
#import <Mantle/EXTKeyPathCoding.h>

@implementation MSFLoanType

#pragma mark - Lifecycle

- (instancetype)initWithTypeID:(NSString *)typeID {
	return [super initWithDictionary:@{
		@keypath(MSFLoanType.new, objectID): typeID,
		@keypath(MSFLoanType.new, typeID): typeID,
	} error:nil];
}

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
		@"objectID": @"productId",
		@"typeID": @"productId"
	};
}

@end
