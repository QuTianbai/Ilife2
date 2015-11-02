//
// MSFIntergrant.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFIntergrant.h"

@implementation MSFIntergrant

#pragma mark - Lifecycle

- (instancetype)initWithUpgrade:(BOOL)upgrade HTMLURL:(NSURL *)URL {
  self = [super init];
  if (!self) {
    return nil;
  }
	_isUpgrade = upgrade;
	_HTMLURL = URL;
  
  return self;
}

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
		@"isUpgrade": @"status",
		@"bref": @"url",
	};
}

@end
