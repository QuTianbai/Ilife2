//
// MSFEncrpytionSpec.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFCipher.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <OHHTTPStubs/OHHTTPStubs.h>
#import "MSFResponse.h"
#import "MSFClient.h"
#import "MSFServer.h"
#import "MSFClient+Cipher.h"
#import "MSFTestCipher.h"
#import "NSURL+QueryDictionary.h"
#import "MSFSignature.h"

QuickSpecBegin(MSFCipherSpec)

__block MSFTestCipher *encrpytion;

beforeEach(^{
  encrpytion = [[MSFTestCipher alloc] initWithTimestamp:1432733616221];
});

it(@"should initialize", ^{
  // then
  expect(encrpytion).notTo(beNil());
});

it(@"should has response local timestamp", ^{
  // then
  expect(@(encrpytion.client)).to(equal(@1432733599564));
});

it(@"should has server timestamp", ^{
  // then
  expect(@(encrpytion.internet)).to(equal(@1432733616221));
});

it(@"should has timestamp", ^{
  // then
  expect(@(encrpytion.bumpstamp)).to(equal(@1432733600610));
});

it(@"should encrypt with request parameters", ^{
  // given
  NSDictionary *params = @{
		@"versionCode": @"10004",
		@"channel": @"msfinance"
	};
	
  MSFSignature *signature = [encrpytion signatureWithPath:@"/msfinanceapi/v1/app/check_version" parameters:params];
	
  NSDictionary *parameters = [@{
		@"sign": signature.sign,
		@"timestamp": signature.timestamp
	} mtl_dictionaryByAddingEntriesFromDictionary:params];
	
  MSFClient *client = mock(MSFClient.class);
	
  [given([client requestWithMethod:@"GET" path:@"msfinanceapi/v1/app/check_version" parameters:parameters])
   willDo:^id(NSInvocation *invocation) {
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    NSString *URLString = [[NSURL URLWithString:@"msfinanceapi/v1/app/check_version"
     relativeToURL:[NSURL URLWithString:@"http://192.168.2.41:9898"]] absoluteString];
    return [serializer requestWithMethod:@"GET" URLString:URLString parameters:parameters error:nil];
  }];
  
  // when
  NSURLRequest *request = [client requestWithMethod:@"GET" path:@"msfinanceapi/v1/app/check_version" parameters:parameters];

  // then
  NSURL *expectURL = [NSURL URLWithString:@"http://192.168.2.41:9898/msfinanceapi/v1/app/check_version?versionCode=10004&channel=msfinance&sign=8462D6E0F4016B2484559BC14580CA22&timestamp=2015-05-27%2021:33:37"];
  
  expect(request.URL.uq_queryDictionary).to(equal(expectURL.uq_queryDictionary));
});
QuickSpecEnd
