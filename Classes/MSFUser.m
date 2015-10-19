//
// MSFUser.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFUser.h"
#import <Mantle/EXTScope.h>
#import <Mantle/EXTKeyPathCoding.h>

@implementation MSFUser

#pragma mark - MTLJSONSerializing

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

#pragma mark - Lifecycle

+ (instancetype)userWithName:(NSString *)name phone:(NSString *)phone {
	NSMutableDictionary *userDict = [NSMutableDictionary dictionary];
	if (name != nil) {
		userDict[@keypath(MSFUser.new, name)] = name;
	}
	if (phone != nil) {
	 userDict[@keypath(MSFUser.new, phone)] = phone;
	}
	
	return [self modelWithDictionary:userDict error:NULL];
}

+ (instancetype)userWithServer:(MSFServer *)server {
	NSMutableDictionary *userDict = [NSMutableDictionary dictionary];
	if (server != nil) {
	 userDict[@keypath(MSFUser.new, server)] = server;
	}
	
	return [self modelWithDictionary:userDict error:NULL];
}

#pragma mark - Custom Accessors

- (BOOL)isAuthenticated {
	return [self.idcard isKindOfClass:NSString.class] && self.idcard.length == 18 && self.passcard.length > 0;
}

@end
