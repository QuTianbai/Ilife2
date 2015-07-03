//
// MSFLSystem.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFLSystem.h"
#import <UIKit/UIKit.h>
#import <libextobjc/extobjc.h>

@interface MSFLSystem ()

@end

@implementation MSFLSystem

#pragma mark - Lifecycle

- (instancetype)initWithDeivce:(UIDevice *)device {
  return [super initWithDictionary:@{
    @keypath(self.platform): device.systemName,
    @keypath(self.version): device.systemVersion,
    @keypath(self.sdkVersion): @"8.3",
    @keypath(self.buildId): @"1",
  } error:nil];
}

+ (instancetype)currentSystem {
  return [[self alloc] initWithDeivce:UIDevice.currentDevice];
}

#pragma mark - MTLFMDBSerializing

+ (NSString *)FMDBTableName {
  return @"sys";
}

+ (NSDictionary *)FMDBColumnsByPropertyKey {
  return @{
    @keypath(MSFLSystem.new,platform): @"platform",
    @keypath(MSFLSystem.new,version): @"version",
    @keypath(MSFLSystem.new,sdkVersion): @"sdkVersion",
    @keypath(MSFLSystem.new,buildId): @"buildId",
  };
}

+ (NSArray *)FMDBPrimaryKeys {
  return @[@"version"];
}

@end
