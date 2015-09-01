//
// MSFElement.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFElement.h"

@implementation MSFElement

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
		@"type": @"code",
		@"plain": @"name",
		@"comment": @"comment",
		@"exampleURL": @"exampleUrl",
		@"thumbURL": @"iconUrl",
		@"required": @"must",
		@"maximum": @"maxNum",
	};
}

+ (NSValueTransformer *)exampleURLJSONTransformer {
	return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)thumbURLJSONTransformer {
	return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
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
	return *required == nil;
}

@end
