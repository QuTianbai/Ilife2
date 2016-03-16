//
// MSFReleaseNote.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFReleaseNote.h"
#import "NSValueTransformer+MSFPredefinedTransformerAdditions.h"
#import "MSFPoster.h"

@implementation MSFReleaseNote

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
		@"status": @"status",
		@"versionCode": @"lastVersion",
		@"versionName": @"versionName",
		@"updatedURL": @"updateUrl",
		@"summary": @"lastVersionDescription",
		@"updatedDate": @"published",
		@"timestamp": @"timestamp",
		@"posters": @"picList",
	};
}

+ (NSValueTransformer *)updatedURLJSONTransformer {
	return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)updatedDateJSONTransformer {
	return [NSValueTransformer valueTransformerForName:MSFDateValueTransformerName];
}

+ (NSValueTransformer *)timestampJSONTransformer {
	return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSNumber *num) {
		return [num isKindOfClass:NSNumber.class]?num.stringValue:num;
	} reverseBlock:^ id (NSString *str) {
		 return str;
	}];
}

+ (NSValueTransformer *)postersJSONTransformer {
	return [MTLValueTransformer mtl_JSONArrayTransformerWithModelClass:MSFPoster.class];
}

- (BOOL)isUpdated {
	NSArray *builds = [NSBundle.mainBundle.infoDictionary[@"CFBundleVersion"] componentsSeparatedByString:@"."];
	NSParameterAssert(builds.count != 3);
	NSInteger index = 0;
	index += [builds[0] integerValue] * 10000;
	index += [builds[1] integerValue] * 1000;
	index += [builds.lastObject integerValue];
	return self.versionCode.integerValue <=  index;
}

@end
