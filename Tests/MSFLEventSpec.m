//
// MSFLEventSpec.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFLEvent.h"
#import "MSFUser.h"

QuickSpecBegin(MSFLEventSpec)

__block MSFLEvent *event;

beforeEach(^{
  NSDate *date = [NSDate dateWithTimeIntervalSince1970:1434091377.642];
  MSFUser *user = mock(MSFUser.class);
  stubProperty(user, objectID, @"15215070333");
  event = [[MSFLEvent alloc] initWithEvent:MSFEventTypePage
    date:date
    network:MSFNetworkTypeWiFi
    user:user
    latitude:10
    longitude:102
    label:@"activity,fragment"
    value:@"1; 3; 42000"];
});

it(@"should initialize", ^{
  // then
  expect(event).notTo(beNil());
  expect(event.event).to(equal(@"page"));
  expect(event.currentTime).to(equal(@"1434091377642"));
  expect(event.networkType).to(equal(@"1030"));
  expect(event.userId).to(equal(@"15215070333"));
  expect(event.location).to(equal(@"10,102"));
  expect(event.label).to(equal(@"activity,fragment"));
  expect(event.value).to(equal(@"1; 3; 42000"));
});

it(@"should export json", ^{
  // when
  NSDictionary *myDictionary = @{
    @"event": @"page",
    @"currentTime": @"1434091377642",
    @"networkType": @"1030",
    @"userId": @"15215070333",
    @"location": @"10,102",
    @"label": @"activity,fragment",
    @"value": @"1; 3; 42000"
  };
  
  // then
  expect(event.dictionaryValue).to(equal(myDictionary));
});

it(@"should database table name", ^{
  // then
  expect(MSFLEvent.FMDBTableName).to(equal(@"events"));
});

it(@"should database has property keys", ^{
  // given
  NSDictionary *expectKey = @{
    @"event": @"event",
    @"currentTime": @"currentTime",
    @"networkType": @"networkType",
    @"userId": @"userId",
    @"location": @"location",
    @"label": @"label",
    @"value": @"value",
  };
  
  // then
  expect(MSFLEvent.FMDBColumnsByPropertyKey).to(equal(expectKey));
});

it(@"should primary keys", ^{
  // then
  expect(MSFLEvent.FMDBPrimaryKeys).to(equal(@[@"currentTime"]));
});

QuickSpecEnd
