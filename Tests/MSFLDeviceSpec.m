//
// MSFLDeviceSpec.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFLDevice.h"
#import "UIDevice-Hardware.h"

QuickSpecBegin(MSFLDeviceSpec)

__block MSFLDevice *device;

beforeEach(^{
  UIDevice *mockDevice = mock([UIDevice class]);
  stubProperty(mockDevice, model, @"iPhone");
  stubProperty(mockDevice, modelName, @"iPhone 5");
  device = [[MSFLDevice alloc] initWithUDID:@"123" device:mockDevice];
  expect(device).notTo(beNil());
});

it(@"should initialize", ^{
  
  // then
  expect(device.manufacturer).to(equal(@"Apple"));
  expect(device.brand).to(equal(@"iPhone 5"));
  expect(device.model).to(equal(@"iPhone"));
  expect(device.deviceID).to(equal(@"123"));
});

it(@"should export JSON", ^{
  // given
  NSDictionary *myDictionary = @{
    @"manufacturer": @"Apple",
    @"brand": @"iPhone 5",
    @"model": @"iPhone",
    @"id": @"123"
  };
 
  // when
  NSDictionary *dictionaryValue = [MTLJSONAdapter JSONDictionaryFromModel:device];
  
  // then
  expect(dictionaryValue).to(equal(myDictionary));
});

it(@"should database table name", ^{
  // then
  expect(MSFLDevice.FMDBTableName).to(equal(@"device"));
});

it(@"should database has property keys", ^{
  // given
  NSDictionary *expectKey = @{
    @"manufacturer": @"manufacturer",
    @"brand": @"brand",
    @"model": @"model",
    @"deviceID": @"id",
  };
  
  // then
  expect(MSFLDevice.FMDBColumnsByPropertyKey).to(equal(expectKey));
});

it(@"should primary keys", ^{
  // then
  expect(MSFLDevice.FMDBPrimaryKeys).to(equal(@[@"id"]));
});

QuickSpecEnd
