//
// MSFWebViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFWebViewModel.h"

@implementation MSFWebViewModel

- (instancetype)initWithURL:(NSURL *)URL {
  self = [super init];
  if (!self) {
    return nil;
  }
	_URL = URL;
  
  return self;
}

@end
