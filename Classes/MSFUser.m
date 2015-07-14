//
// MSFUser.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFUser.h"
#import <libextobjc/extobjc.h>

@implementation MSFUser

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

- (BOOL)isAuthenticated {
	//TODO: 服务器接口未通过验证
	return [self.idcard isKindOfClass:NSString.class] && self.idcard.length == 18;
	//return [self.idcard isKindOfClass:NSString.class] && self.idcard.length == 18 && self.passcard.length > 0;
}

@end
