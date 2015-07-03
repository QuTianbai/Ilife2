//
// MSFUserSpec.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFUser.h"
#import "MSFServer.h"

QuickSpecBegin(MSFUserSpec)

__block NSDictionary *representation;

beforeEach(^{
  representation = @{
    @"user_id" : @"ds13dsaf21d",
    @"phone_number" : @"15222222222",
    @"username" : @"xxx",
    @"id_card" : @"123",
    @"bank_card_number" : @"888",
    @"avatar" : @{
        @"width" : @100,
        @"height" : @100,
        @"url" : @"http://avatar.com",
        @"type" : @""
        }
    };
});

it(@"msfinance user", ^{
  // when
  MSFUser *user = [MTLJSONAdapter modelOfClass:MSFUser.class fromJSONDictionary:representation error:nil];
  
  // then
  expect(user.objectID).to(equal(@"ds13dsaf21d"));
  expect(user.phone).to(equal(@"15222222222"));
  expect(user.name).to(equal(@"xxx"));
  expect(user.idcard).to(equal(@"123"));
  expect(user.passcard).to(equal(@"888"));
  expect(user.avatarURL).to(equal([NSURL URLWithString:@"http://avatar.com"]));
  expect(user.server).to(equal(MSFServer.dotComServer));
});

it(@"should create user", ^{
  // given
  
  // when
  MSFUser *user = [MSFUser userWithName:@"" phone:@"18696995689"];
  
  // then
  expect(user.phone).to(equal(@"18696995689"));
});

QuickSpecEnd
