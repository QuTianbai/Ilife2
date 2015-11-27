//
// MSFUserSpec.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFUser.h"
#import "MSFServer.h"

QuickSpecBegin(MSFUserSpec)

NSDictionary *representation = @{
    @"uniqueId" : @"ds13dsaf21d",
		@"custType" : @"0",
	};

it(@"msfinance user", ^{
  // when
  MSFUser *user = [MTLJSONAdapter modelOfClass:MSFUser.class fromJSONDictionary:representation error:nil];
  
  // then
  expect(user.objectID).to(equal(@"ds13dsaf21d"));
	expect(@(user.isAuthenticated)).to(beTruthy());
});

it(@"should create user", ^{
  // given
  
  // when
  MSFUser *user = [MSFUser userWithServer:MSFServer.dotComServer];
  
  // then
  expect(user.server).to(equal(MSFServer.dotComServer));
});

QuickSpecEnd
