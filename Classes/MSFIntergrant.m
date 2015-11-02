//
// MSFIntergrant.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFIntergrant.h"

@implementation MSFIntergrant

- (instancetype)initWithUpgrade:(BOOL)upgrade HTMLURL:(NSURL *)URL {
  self = [super init];
  if (!self) {
    return nil;
  }
	_isUpgrade = upgrade;
	_HTMLURL = URL;
  
  return self;
}

@end
