//
// MSFAuthorizeRequestSpec.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFAuthorizeRequest.h"

QuickSpecBegin(MSFAuthorizeRequestSpec)

__block MSFAuthorizeRequest *request;

beforeEach(^{
	request = [[MSFAuthorizeRequest alloc] init];
});

it(@"should initialize", ^{
  // then
	expect(request).notTo(beNil());
});

it(@"should authorize with type mobile", ^{
	// when
	request.requestType = MSFAuthorizeRequestSignInMobile;
	request.mobile = @"18696995689";
	request.password = @"foo";
	request.imei = @"bar";
	
	// then
	expect(@(request.requestType)).to(equal(@(MSFAuthorizeRequestSignInMobile)));
	expect(request.mobile).to(equal(@"18696995689"));
	expect(request.password).to(equal(@"foo"));
	expect(request.imei).to(equal(@"bar"));
});

it(@"should authorize with identifer", ^{
	// when
	request.requestType = MSFAuthorizeRequestSignInIdentifier;
	request.name = @"foo";
	request.password = @"foo";
	request.imei = @"bar";
	request.identifier = @"50";
	
	// then
	expect(@(request.requestType)).to(equal(@(MSFAuthorizeRequestSignInIdentifier)));
	expect(request.name).to(equal(@"foo"));
	expect(request.password).to(equal(@"foo"));
	expect(request.imei).to(equal(@"bar"));
	expect(request.identifier).to(equal(@"50"));
});

it(@"should need verify user sms code", ^{
	// when
	request.smscode = @"2000";
	
	// then
	expect(request.smscode).to(equal(@"2000"));
});

it(@"should has identifier expired Date", ^{
	// given
	NSDate *date = mock([NSDate class]);
	
	// when
	request.identifierExpiredDate = date;
	
	// then
	expect(request.identifierExpiredDate).to(equal(date));
});

it(@"should get request body", ^{
	// when
	NSDictionary *body = @{
		@"logType": @"",
		@"imei": @"",
		@"mobile": @"",
		@"password": @"",
		@"name": @"",
		@"ident": @"",
		@"smsCode": @"",
		@"idLastDate": @"",
		@"newPassword": @"",
		@"uniqueId": @"",
		@"transPassword": @"",
		@"oldTransPassword": @"",
		@"newTransPassword": @"",
		@"idCard": @"",
		@"oldMobile": @"",
	};
	
	NSArray *expectedBody = [body.allKeys sortedArrayUsingSelector:@selector(compare:)];
	NSArray *result = [request.requestBody.allKeys sortedArrayUsingSelector:@selector(compare:)];
	
	// then
	expect(result).to(equal(expectedBody));
});


QuickSpecEnd
