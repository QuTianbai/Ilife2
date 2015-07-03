//
// MSFLChannel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFLChannel.h"
#import <libextobjc/extobjc.h>

@implementation MSFLChannel

- (instancetype)initWithBundle:(NSBundle *)bundle {
  NSString *version = [bundle.infoDictionary[@"CFBundleShortVersionString"]
    stringByReplacingOccurrencesOfString:@"." withString:@""];
  
  return [super initWithDictionary:@{
    @keypath(self,channel): @"msfinance",
    @keypath(self,appVersion): version,
  } error:nil];
}

+ (instancetype)currentChannel {
  return [[self alloc] initWithBundle:NSBundle.mainBundle];
}

#pragma mark - MTLFMDBSerializing

+ (NSString *)FMDBTableName {
  return @"channel";
}

+ (NSDictionary *)FMDBColumnsByPropertyKey {
  return @{
    @keypath(MSFLChannel.new,channel): @"channel",
    @keypath(MSFLChannel.new,appVersion): @"appVersion",
  };
}

+ (NSArray *)FMDBPrimaryKeys {
  return @[@"appVersion"];
}

@end
