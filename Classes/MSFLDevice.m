//
// MSFLDevice.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFLDevice.h"
#import "UIDevice-Hardware.h"
#import <UIKit/UIKit.h>
#import <OpenUDID/OpenUDID.h>
#import <libextobjc/extobjc.h>

@implementation MSFLDevice

#pragma mark - Lifecycle

- (instancetype)initWithUDID:(NSString *)udid device:(UIDevice *)device {
  return [super initWithDictionary:@{
    @"manufacturer": @"Apple",
    @"brand": device.modelName,
    @"model": device.model,
    @"deviceID": udid,
  } error:nil];
}

+ (instancetype)currentDevice {
  return [[self alloc] initWithUDID:OpenUDID.value device:UIDevice.currentDevice];
}

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
  return @{
    @"manufacturer": @"manufacturer",
    @"brand": @"brand",
    @"model": @"model",
    @"deviceID": @"id",
  };
}

#pragma mark - MTLFMDBSerializing

+ (NSString *)FMDBTableName {
  return @"device";
}

+ (NSDictionary *)FMDBColumnsByPropertyKey {
  return @{
    @keypath(MSFLDevice.new,manufacturer): @"manufacturer",
    @keypath(MSFLDevice.new,brand): @"brand",
    @keypath(MSFLDevice.new,model): @"model",
    @keypath(MSFLDevice.new,deviceID): @"id",
  };
}

+ (NSArray *)FMDBPrimaryKeys {
  return @[@"id"];
}

@end
