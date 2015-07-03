//
// MSFLEvent.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFLEvent.h"
#import <libextobjc/extobjc.h>
#import "MSFUser.h"

@implementation MSFLEvent

- (instancetype)initWithEvent:(MSFEventType)event
  date:(NSDate *)date
  network:(MSFNetworkType)network
  user:(MSFUser *)user
  latitude:(double)latitude
  longitude:(double)longitude
  label:(NSString *)label
  value:(NSString *)value {
  long long interval = (long long)(date.timeIntervalSince1970 * 1000);
  return [super initWithDictionary:@{
    @keypath(self.event): [self.class eventWithType:event],
    @keypath(self.currentTime): [@(interval) stringValue],
    @keypath(self.networkType): [@(network) stringValue],
    @keypath(self.userId): user.objectID,
    @keypath(self.label): label,
    @keypath(self.value): value,
    @keypath(self.location): [NSString stringWithFormat:@"%@,%@",[@(latitude) stringValue],[@(longitude) stringValue]],
  } error:nil];
}

#pragma mark - Private

+ (NSString *)eventWithType:(MSFEventType)event {
  switch (event) {
    case MSFEventTypePage: {
      return @"page";
      break;
    }
    default: {
      return @"none";
      break;
    }
  }
}

#pragma mark - MTLFMDBSerializing

+ (NSString *)FMDBTableName {
  return @"events";
}

+ (NSDictionary *)FMDBColumnsByPropertyKey {
  return @{
    @keypath(MSFLEvent.new,event): @"event",
    @keypath(MSFLEvent.new,currentTime): @"currentTime",
    @keypath(MSFLEvent.new,networkType): @"networkType",
    @keypath(MSFLEvent.new,userId): @"userId",
    @keypath(MSFLEvent.new,label): @"label",
    @keypath(MSFLEvent.new,value): @"value",
    @keypath(MSFLEvent.new,location): @"location",
  };
}

+ (NSArray *)FMDBPrimaryKeys {
  return @[@"currentTime"];
}

@end
