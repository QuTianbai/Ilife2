//
// MSFLSystemSpec.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFLSystem.h"

QuickSpecBegin(MSFLSystemSpec)

__block MSFLSystem *system;

beforeEach(^{
  UIDevice *mockDevice = mock([UIDevice class]);
  stubProperty(mockDevice, systemVersion, @"7.1");
  stubProperty(mockDevice, systemName, @"ios");
  
  system = [[MSFLSystem alloc] initWithDeivce:mockDevice];
  expect(system).notTo(beNil());
});

it(@"should initialize", ^{
  // then
  expect(system.platform).to(equal(@"ios"));
  expect(system.version).to(equal(@"7.1"));
  expect(system.sdkVersion).to(equal(@"8.3"));
  expect(system.buildId).to(equal(@"1"));
});

it(@"should export for submit json", ^{
  // given
  NSDictionary *myDictionary = @{
    @"platform" : @"ios",
    @"sdkVersion" : @"8.3",
    @"version" : @"7.1",
    @"buildId" : @"1"
  };
 
  // then
  expect(system.dictionaryValue).to(equal(myDictionary));
});

it(@"should database table name", ^{
  // then
  expect(MSFLSystem.FMDBTableName).to(equal(@"sys"));
});

it(@"should database has property keys", ^{
  // given
  NSDictionary *expectKey = @{
    @"platform": @"platform",
    @"sdkVersion": @"sdkVersion",
    @"version": @"version",
    @"buildId": @"buildId",
  };
  
  // then
  expect(MSFLSystem.FMDBColumnsByPropertyKey).to(equal(expectKey));
});

it(@"should primary keys", ^{
  // then
  expect(MSFLSystem.FMDBPrimaryKeys).to(equal(@[@"version"]));
});

QuickSpecEnd
