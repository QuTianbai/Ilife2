//
// MSFUtilsSpec.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFUtils.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <OHHTTPStubs/OHHTTPStubs.h>
#import "MSFServer.h"
#import "MSFUser.h"
#import "MSFAuthorization.h"
#import "MSFClient.h"

QuickSpecBegin(MSFUtilsSpec)

it(@"should archive client", ^{
  // given
	BOOL success = NO;
	NSError *error = nil;
  NSURL *URL = [NSURL URLWithString:@"http://sample.com"];
  MSFServer *server = [MSFServer serverWithBaseURL:URL];
  MSFUser *user = [MSFUser userWithServer:server];
  
  [OHHTTPStubs addRequestHandler:^OHHTTPStubsResponse *(NSURLRequest *request, BOOL onlyCheck) {
    NSURL *fileURL = [[NSBundle bundleForClass:self.class] URLForResource:@"authorizations" withExtension:@"json"];
    return [OHHTTPStubsResponse responseWithFileURL:fileURL statusCode:200 responseTime:0 headers:@{
       @"Content-Type": @"application/json",
       @"finance": @"token",
       @"msfinance": @"objectid",
       }];
  }];
  
  RACSignal *request = [MSFClient signInAsUser:user password:@"" phone:@"" captcha:@""];
  MSFClient *client = [request asynchronousFirstOrDefault:nil success:&success error:&error];
	
	expect(client.user.name).to(equal(@"xxx"));
  expect(client.user.server.baseURL).to(equal(URL));
	
  // when
  [MSFUtils archiveClient:client];
	//TODO: Rename expectClient to result
  MSFClient *expectClient = [MSFUtils unArchiveClient];
  
  // then
  expect(expectClient.user.name).to(equal(@"xxx"));
  expect(expectClient.user.server.baseURL).to(equal(URL));
	expect(@(success)).to(beTruthy());
	expect(error).to(beNil());
});

QuickSpecEnd
