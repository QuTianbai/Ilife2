//
// MSFElement.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFElement.h"
#import "MSFServer.h"
#import "MSFElement+Private.h"

@interface MSFElement ()

@property (nonatomic, strong) NSString *applicationNumberString;

@end

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

+ (NSValueTransformer *)requiredJSONTransformer {
	return [MTLValueTransformer reversibleTransformerWithBlock:^id(NSString *string) {
		return [string isEqualToString:@"M"] ? @YES: @NO;
	}];
}

- (BOOL)validateRequired:(id *)required error:(NSError **)error {
	id object  = *required;
	if ([object isKindOfClass:NSString.class]) {
		*required = @([*required isEqualToString:@"M"]);
		return YES;
	} else if ([object isKindOfClass:NSNumber.class]) {
		*required = @([*required boolValue]);
		return YES;
	}
	*required = @NO;
	return *required == nil;
}

#pragma mark - Custom Accessors

- (NSURL *)sampleURL {
	return [self.server.baseURL URLByAppendingPathComponent:self.relativeSamplePath];
}

- (NSURL *)thumbURL {
	return [self.server.baseURL URLByAppendingPathComponent:self.relativeThumbPath];
}

#pragma mark - Private

- (void)setApplicationNo:(NSString *)applicationNo {
	self.applicationNumberString = applicationNo;
}

- (NSString *)applicationNo {
	return self.applicationNumberString;
}

@end
