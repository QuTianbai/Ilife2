//
// MSFEntity.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFEntity.h"

@implementation MSFEntity

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
		@"objectID": @"user_id",
		@"phone": @"phone_number",
		@"name": @"username",
		@"idcard": @"id_card",
		@"passcard": @"bank_card_number",
		@"avatarURL": @"avatar",
		};
}

+ (NSValueTransformer *)avatarURLJSONTransformer {
	return [MTLValueTransformer transformerWithBlock:^id(id avatar) {
		return [NSURL URLWithString:avatar[@"url"]];
	}];
}

@end
