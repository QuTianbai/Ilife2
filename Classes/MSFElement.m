//
// MSFElement.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFElement.h"
#import "MSFServer.h"

@implementation MSFElement

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
		@"type": @"code",
		@"name": @"name",
		@"title": @"title",
		@"comment": @"comment",
		@"relativeSamplePath": @"exampleUrl",
		@"relativeThumbPath": @"iconUrl",
		@"required": @"status",
		@"maximum": @"maxNum",
		@"sort": @"sort",
	};
}

- (NSURL *)sampleURL {
	return [self.server.baseURL URLByAppendingPathComponent:self.relativeSamplePath];
}

- (NSURL *)thumbURL {
	return [self.server.baseURL URLByAppendingPathComponent:self.relativeThumbPath];
}

+ (NSValueTransformer *)requiredJSONTransformer {
	return [MTLValueTransformer reversibleTransformerWithBlock:^id(NSString *string) {
		return [string isEqualToString:@"M"] ? @YES: @NO;
	}];
}

- (BOOL)validateRequired:(id *)required error:(NSError **)error {
	id object  = *required;
	if ([object isKindOfClass:NSString.class]) {
		*required = @([*required isEqualToString:@"true"]);
		return YES;
	} else if ([object isKindOfClass:NSNumber.class]) {
		*required = @([*required boolValue]);
		return YES;
	}
	*required = @NO;
	return *required == nil;
}

@end
