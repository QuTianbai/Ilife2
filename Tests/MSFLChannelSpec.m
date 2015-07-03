//
// MSFLChannelSpec.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFLChannel.h"

QuickSpecBegin(MSFLChannelSpec)

__block MSFLChannel *channel;

beforeEach(^{
  NSBundle *mockBundle = mock([NSBundle class]);
  stubProperty(mockBundle, infoDictionary, @{@"CFBundleShortVersionString": @"1.0"});
  channel = [[MSFLChannel alloc] initWithBundle:mockBundle];
});

it(@"should initialize", ^{
  // then
  expect(channel).notTo(beNil());
  expect(channel.channel).to(equal(@"msfinance"));
  expect(channel.appVersion).to(equal(@"10"));
});

it(@"should database table name", ^{
  // then
  expect(MSFLChannel.FMDBTableName).to(equal(@"channel"));
});

it(@"should database has property keys", ^{
  // given
  NSDictionary *expectKey = @{
    @"channel": @"channel",
    @"appVersion": @"appVersion",
  };
  
  // then
  expect(MSFLChannel.FMDBColumnsByPropertyKey).to(equal(expectKey));
});

it(@"should primary keys", ^{
  // then
  expect(MSFLChannel.FMDBPrimaryKeys).to(equal(@[@"appVersion"]));
});

QuickSpecEnd
