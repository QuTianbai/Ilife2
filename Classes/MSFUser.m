//
// MSFUser.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFUser.h"
#import <Mantle/EXTKeyPathCoding.h>

@implementation MSFUser

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
		@"objectID": @"userId",
		@"hasTransactionalCode": @"hasTransPwd"
	};
}

#pragma mark - Lifecycle

+ (instancetype)userWithServer:(MSFServer *)server {
	NSMutableDictionary *userDict = [NSMutableDictionary dictionary];
	if (server != nil) {
	 userDict[@keypath(MSFUser.new, server)] = server;
	}
	
	return [self modelWithDictionary:userDict error:NULL];
}

+ (NSValueTransformer *)hasTransactionalCodeJSONTransformer {
	return [MTLValueTransformer transformerWithBlock:^id(NSString *value) {
		return [value isEqualToString:@"NO"] ? @NO : @YES;
	}];
}

#pragma mark - Custom Accessors

- (BOOL)isAuthenticated {
	return self.objectID != nil;
}

@end
