//
// MSFAuthorization.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFAuthorization.h"

@implementation MSFAuthorization

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
		@"session": @"msfinance",
		@"token": @"finance"
		};
}

@end
