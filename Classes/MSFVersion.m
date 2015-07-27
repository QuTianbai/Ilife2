//
// MSFVersion.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFVersion.h"

@implementation MSFVersion

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
		@"code": @"version_code",
		@"name": @"version_name",
		@"channel": @"channel",
		@"updateURL": @"update_url",
		@"summary": @"whats_version",
		@"date": @"published",
		@"iconURL": @"icon",
		};
}

+ (NSValueTransformer *)iconURLJSONTransformer {
	return [MTLValueTransformer transformerWithBlock:^id(NSDictionary *icon) {
		return [NSURL URLWithString:icon[@"url"]];
	}];
}

+ (NSValueTransformer *)updateURLJSONTransformer {
	return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)codeJSONTransformer {
	return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSNumber *num) {
		return num.stringValue;
	} reverseBlock:^ id (NSString *str) {
		if (str == nil) {
			return nil;
		}
		
		return [NSDecimalNumber decimalNumberWithString:str];
	}];
}

- (BOOL)validateCode:(id *)code error:(NSError **)error {
	id codeid = *code;
	if ([codeid isKindOfClass:NSString.class]) {
		return YES;
	} else if ([codeid isKindOfClass:NSNumber.class]) {
		*code = [codeid stringValue];
		return YES;
	}
	
	return *code == nil;
}

@end
