//
// MSFIntergrant.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFIntergrant.h"

@implementation MSFIntergrant

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
		@"isUpgrade": @"status",
		@"bref": @"url",
	};
}

- (NSString *)relativeStringWithType:(NSString *)type {
	return [NSString stringWithFormat:@"%@?type=%@", self.bref, type];
}

@end
