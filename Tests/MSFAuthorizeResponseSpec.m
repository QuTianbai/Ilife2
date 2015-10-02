//
// MSFAuthorizeResponseSpec.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFAuthorizeResponse.h"

QuickSpecBegin(MSFAuthorizeResponseSpec)

__block MSFAuthorizeResponse *response;

beforeEach(^{
	response = [MTLJSONAdapter modelOfClass:MSFAuthorizeResponse.class fromJSONDictionary:@{
		@"uniqueId": @"1",
		@"custType": @"0"
	} error:nil];
});

it(@"should initialize", ^{
  // then
	expect(response).notTo(beNil());
	expect(response.uniqueId).to(equal(@"1"));
	expect(@(response.clientType)).to(equal(@(MSFClientTypeNomal)));
});

QuickSpecEnd
