//
// MSFClientSpec.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFClient.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <OHHTTPStubs/OHHTTPStubs.h>
#import <Mantle/Mantle.h>

#import "MSFServer.h"
#import "MSFResponse.h"

#import "MSFUser.h"
#import "MSFClient+Users.h"

#import "MSFReleaseNote.h"
#import "MSFClient+ReleaseNote.h"

#import "MSFClient+Cipher.h"

QuickSpecBegin(MSFClientSpec)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"

void (^stubResponseWithHeaders)(NSString *, NSString *, int, NSDictionary *) = ^(NSString *path, NSString *responseFilename, int statusCode, NSDictionary *headers) {
  if (responseFilename != nil) {
    headers = [headers mtl_dictionaryByAddingEntriesFromDictionary:@{@"Content-Type": @"application/json"}];
  }
  
  [OHHTTPStubs addRequestHandler:^ id (NSURLRequest *request, BOOL onlyCheck) {
    if (![request.URL.path isEqual:path]) return nil;
    
    if (responseFilename == nil) {
      return [OHHTTPStubsResponse responseWithData:[NSData data] statusCode:statusCode responseTime:0 headers:headers];
    } else {
      NSURL *fileURL = [[NSBundle bundleForClass:self.class] URLForResource:responseFilename.stringByDeletingPathExtension withExtension:responseFilename.pathExtension];
      return [OHHTTPStubsResponse responseWithFileURL:fileURL statusCode:statusCode responseTime:0 headers:headers];
    }
  }];
};

void (^stubResponse)(NSString *, id) = ^(NSString *path, id response) {
  if ([response isKindOfClass:[NSDictionary class]] || [response isKindOfClass:[NSArray class]]) {
    [OHHTTPStubs addRequestHandler:^OHHTTPStubsResponse *(NSURLRequest *request, BOOL onlyCheck) {
      if (![request.URL.path isEqual:path]) return nil;
      NSData *data = [NSJSONSerialization dataWithJSONObject:response options:NSJSONWritingPrettyPrinted error:nil];
      return [OHHTTPStubsResponse responseWithData:data statusCode:200 responseTime:0 headers:@{@"Content-Type": @"application/json"}];
    }];
    return;
  }
	if (!response) {
    [OHHTTPStubs addRequestHandler:^OHHTTPStubsResponse *(NSURLRequest *request, BOOL onlyCheck) {
      return [OHHTTPStubsResponse responseWithData:nil statusCode:200 responseTime:0 headers:@{@"Content-Type": @"application/json"}];
		}];
    return;
	}
  stubResponseWithHeaders(path, response, 200, @{});
};

void (^stubRedirectResponseURL)(NSURL *, int, NSURL *) = ^(NSURL *URL, int statusCode, NSURL *redirectURL) {
  [OHHTTPStubs addRequestHandler:^ id (NSURLRequest *request, BOOL onlyCheck) {
    if (!([request.URL.scheme isEqual:URL.scheme] && [request.URL.path isEqual:URL.path])) return nil;
    
    return [OHHTTPStubsResponse responseWithData:[NSData data] statusCode:statusCode responseTime:0 headers:@{@"Location": redirectURL.absoluteString}];
  }];
};

void (^stubResponseURL)(NSURL *, NSString *, int, NSDictionary *) = ^(NSURL *URL, NSString *responseFilename, int statusCode, NSDictionary *headers) {
  headers = [headers mtl_dictionaryByAddingEntriesFromDictionary:@{@"Content-Type": @"application/json"}];
  
  [OHHTTPStubs addRequestHandler:^ id (NSURLRequest *request, BOOL onlyCheck) {
    if (![request.URL isEqual:URL]) return nil;
    
    NSURL *fileURL = [[NSBundle bundleForClass:self.class] URLForResource:responseFilename.stringByDeletingPathExtension withExtension:responseFilename.pathExtension];
    return [OHHTTPStubsResponse responseWithFileURL:fileURL statusCode:statusCode responseTime:0 headers:headers];
  }];
};

#pragma clang diagnostic pop

__block MSFClient *client;
__block BOOL success;
__block NSError *error;
__block MSFUser *user;

beforeEach(^{
  success = NO;
  error = nil;
  NSDictionary *userDictionary = @{
    @keypath(MSFUser.new, objectID): @"1",
    @keypath(MSFUser.new, server): MSFServer.dotComServer,
	};
  user = [MSFUser modelWithDictionary:userDictionary error:nil];
});

describe(@"without a user", ^{
  beforeEach(^{
    client = [[MSFClient alloc] initWithServer:MSFServer.dotComServer];
    success = NO;
    error = nil;
  });
  
  it(@"should initialize", ^{
    // then
    expect(client).notTo(beNil());
  });
  
  it(@"should has right base URL", ^{
    // then
    expect(client.baseURL).to(equal([NSURL URLWithString:@"https://api.msfinance.cn"]));
  });
  
  it(@"should create a GET request whith default paramters", ^{
    // when
    NSURLRequest *request = [client requestWithMethod:@"GET" path:@"get" parameters:nil];
    
    // then
    expect(request).notTo(beNil());
    expect(request.HTTPMethod).to(equal(@"GET"));
    expect(request.URL.path).to(equal(@"/get"));
  });
  
  it(@"should GET a JSON Dictionary", ^{
    // given
    stubResponse(@"/get",@{@"id": @1});
    NSURLRequest *request = [client requestWithMethod:@"GET" path:@"get" parameters:nil];
    
    // when
    RACSignal *result = [client enqueueRequest:request resultClass:nil];
    MSFResponse *response = [result asynchronousFirstOrDefault:nil success:&success error:&error];
    
    // then
    expect(@(success)).to(beTruthy());
    expect(error).to(beNil());
    expect(response).to(beAKindOf(MSFResponse.class));
    expect(response.parsedResult).to(equal(@{@"id": @1}));
  });
  
  it(@"should GET a error response", ^{
    // given
    stubResponseWithHeaders(@"/path", @"error.json", 301, @{});
    NSURLRequest *request = [client requestWithMethod:@"GET" path:@"path" parameters:nil];
    
    // when
    RACSignal *result = [client enqueueRequest:request resultClass:nil];
    MSFResponse *response = [result asynchronousFirstOrDefault:nil success:&success error:&error];
    
    // then
    expect(response).to(beNil());
    expect(@(success)).to(beFalsy());
    expect(@(error.code)).to(equal(@301));
    expect(error.domain).to(equal(MSFClientErrorDomain));
    expect(error.userInfo[NSLocalizedFailureReasonErrorKey]).to(equal(@"Not Found"));
  });
  
  it(@"should fetch releasenote", ^{
    // given
    stubResponse(@"/checkVersion",@"releasenote.json");
    
    // when
    RACSignal *request = [client fetchReleaseNote];
    MSFReleaseNote *releasenote = [request asynchronousFirstOrDefault:nil success:nil error:nil];
    
    // then
    expect(releasenote).to(beAKindOf(MSFReleaseNote.class));
    expect(@(releasenote.status)).to(equal(@1));
  });
  
  it(@"should fetch empty releasenote", ^{
    // given
    stubResponse(@"/checkVersion",@{});
    
    // when
    RACSignal *request = [client fetchReleaseNote];
    MSFReleaseNote *releasenote = [request asynchronousFirstOrDefault:nil success:&success error:&error];
    
    // then
    expect(@(success)).to(beTruthy());
    expect(error).to(beNil());
		expect(releasenote).notTo(beNil());
  });
  
  it(@"should user forget password", ^{
    // given
    stubResponse(@"/users/forget_password", nil);
    
    // when
    RACSignal *request = [client resetSignInPassword:@"" phone:@"" captcha:@"" name:@"" citizenID:@""];
    MSFResponse *response = [request asynchronousFirstOrDefault:nil success:&success error:&error];
    
    // then
		expect(@(success)).to(beTruthy());
		expect(error).to(beNil());
		expect(response).notTo(beNil());
  });
  
  it(@"should fetch timestamp", ^{
    // given
    stubResponse(@"/app/server_time",@"timestamp.json");
    
    // when
    RACSignal *request = [client fetchServerInterval];
    MSFResponse *response = [request asynchronousFirstOrDefault:nil success:nil error:nil];
    
    // then
    expect(response.parsedResult[@"time"]).to(equal(@"1432733616221"));
  });
	
	it(@"should get parameters authenticated error", ^{
		// given
		NSDictionary *myDictionary = @{
			@"message" : @"Request entity validate faild.",
			@"fields" : @{
				@"password" : @"000",
				@"logType" : @"000"
			}
		};
		[OHHTTPStubs addRequestHandler:^OHHTTPStubsResponse *(NSURLRequest *request, BOOL onlyCheck) {
			NSData *data = [NSJSONSerialization dataWithJSONObject:myDictionary options:NSJSONWritingPrettyPrinted error:nil];
			return [OHHTTPStubsResponse responseWithData:data statusCode:422 responseTime:0 headers:@{
				@"Content-Type": @"application/json"
			}];
		}];
		
		// when
		NSURLRequest *request = [client requestWithMethod:@"POST" path:@"post" parameters:nil];
		RACSignal *signal = [client enqueueRequest:request resultClass:nil];
		[signal asynchronousFirstOrDefault:nil success:&success error:&error];
		
		// then
		expect(@(success)).to(beFalsy());
		expect(@(error.code)).to(equal(@(MSFClientErrorUnprocessableEntry)));
		expect(error.userInfo[MSFClientErrorFieldKey]).to(equal(myDictionary[@"fields"]));
		expect(error.userInfo[NSLocalizedFailureReasonErrorKey]).to(equal(@"Request entity validate faild."));
		expect(error.userInfo[MSFClientErrorMessageKey]).to(equal(@"Request entity validate faild."));
	});
	
	it(@"should get operation error", ^{
		// given
		[OHHTTPStubs addRequestHandler:^OHHTTPStubsResponse *(NSURLRequest *request, BOOL onlyCheck) {
			NSData *data = [NSJSONSerialization dataWithJSONObject:@{
				@"message": @"foo",
				@"code": @4000
			} options:NSJSONWritingPrettyPrinted error:nil];
			return [OHHTTPStubsResponse responseWithData:data statusCode:400 responseTime:0 headers:@{
				@"Content-Type": @"application/json",
			}];
		}];
		
		// when
		// when
		NSURLRequest *request = [client requestWithMethod:@"POST" path:@"post" parameters:nil];
		RACSignal *signal = [client enqueueRequest:request resultClass:nil];
		[signal asynchronousFirstOrDefault:nil success:&success error:&error];
		
		// then
		expect(@(success)).to(beFalsy());
		expect(@(error.code)).to(equal(@(MSFClientErrorBadRequest)));
		expect(error.userInfo[MSFClientErrorMessageCodeKey]).to(equal(@4000));
		expect(error.userInfo[MSFClientErrorMessageKey]).to(equal(@"foo"));
	});
});

describe(@"authenticated", ^{
  beforeEach(^{
    client = [MSFClient authenticatedClientWithUser:user token:@""];
    expect(client).notTo(beNil());
  });
  
  it(@"should authorization client", ^{
    // then
    expect(@(client.isAuthenticated)).to(beTruthy());
  });
  
  it(@"should fetch userinfo", ^{
    // given
    stubResponse(@"/users/1/profile",@"profile.json");
    
    // when
    RACSignal *request = [client fetchUserInfo];
    MSFUser *user = [request asynchronousFirstOrDefault:nil success:&success error:&error];
    
    // then
    expect(user).to(beAKindOf(MSFUser.class));
  });
  
  it(@"should update user password", ^{
    stubResponse(@"/password/updatePassword", nil);
		
    // when
    RACSignal *request = [client updateSignInPassword:@"" password:@""];
    MSFResponse *response = [request asynchronousFirstOrDefault:nil success:&success error:&error];
    
    // then
		expect(@(success)).to(beTruthy());
		expect(error).to(beNil());
		expect(@(response.statusCode)).to(equal(@200));
  });
  
  it(@"should checking user has credit", ^{
    // given
    stubResponse(@"/users/1/processing",@{@"processing": @YES});
    
    // when
    RACSignal *request = [client checkUserHasCredit];
    MSFResponse *resposne = [request asynchronousFirstOrDefault:nil success:nil error:nil];
    
    // then
    expect(resposne.parsedResult[@"processing"]).to(beTruthy());
  });
  
  it(@"should check user is employee", ^{
    // given
    stubResponse(@"/users/1/check_employee",@{@"employee": @YES});
    
    // when
    RACSignal *request = [client checkUserIsEmployee];
    MSFResponse *resposne = [request asynchronousFirstOrDefault:nil success:nil error:nil];
    
    // then
    expect(resposne.parsedResult[@"employee"]).to(beTruthy());
  });
});

describe(@"sign in", ^{
  it(@"should sigin with user mobile", ^{
    // given
    [OHHTTPStubs addRequestHandler:^OHHTTPStubsResponse *(NSURLRequest *request, BOOL onlyCheck) {
      NSURL *fileURL = [[NSBundle bundleForClass:self.class] URLForResource:@"authorizations" withExtension:@"json"];
      return [OHHTTPStubsResponse responseWithFileURL:fileURL statusCode:200 responseTime:0 headers:@{
         @"Content-Type": @"application/json",
         @"finance": @"token",
         @"msfinance": @"objectid",
				 @"token": @"foo",
         }];
    }];
    
    // when
    RACSignal *request = [MSFClient signInAsUser:user password:@"123456" phone:@"" captcha:@""];
    MSFClient *client = [request asynchronousFirstOrDefault:nil success:&success error:nil];
    
    // then
    expect(error).to(beNil());
    expect(client).to(beAKindOf(MSFClient.class));
    expect(@(client.authenticated)).to(beTruthy());
    expect(client.token).to(equal(@"foo"));
		expect(client.user).notTo(beNil());
		expect(client.user.objectID).to(equal(@"foo"));
		expect(client.user.type).to(equal(@"bar"));
  });
	
	it(@"should sigin with user citizen id number", ^{
    // given
    [OHHTTPStubs addRequestHandler:^OHHTTPStubsResponse *(NSURLRequest *request, BOOL onlyCheck) {
      NSURL *fileURL = [[NSBundle bundleForClass:self.class] URLForResource:@"authorizations" withExtension:@"json"];
      return [OHHTTPStubsResponse responseWithFileURL:fileURL statusCode:200 responseTime:0 headers:@{
         @"Content-Type": @"application/json",
         @"finance": @"token",
         @"msfinance": @"objectid",
				 @"token": @"foo",
         }];
    }];
    
    // when
    RACSignal *request = [MSFClient signInAsUser:user username:@"foo" password:@"bar" citizenID:@"500"];
    MSFClient *client = [request asynchronousFirstOrDefault:nil success:&success error:nil];
    
    // then
    expect(error).to(beNil());
    expect(client).to(beAKindOf(MSFClient.class));
    expect(@(client.authenticated)).to(beTruthy());
    expect(client.token).to(equal(@"foo"));
		expect(client.user).notTo(beNil());
		expect(client.user.objectID).to(equal(@"foo"));
		expect(client.user.type).to(equal(@"bar"));
	});
  
  it(@"should sign up a user", ^{
    // given
    [OHHTTPStubs addRequestHandler:^OHHTTPStubsResponse *(NSURLRequest *request, BOOL onlyCheck) {
      NSURL *fileURL = [[NSBundle bundleForClass:self.class] URLForResource:@"authorizations" withExtension:@"json"];
      return [OHHTTPStubsResponse responseWithFileURL:fileURL statusCode:200 responseTime:0 headers:@{
         @"Content-Type": @"application/json",
         @"finance": @"token",
         @"msfinance": @"objectid",
				 @"token": @"foo"
         }];
    }];
    
    // when
    RACSignal *request = [MSFClient signUpAsUser:user password:@"foo" phone:@"159" captcha:@"1234" realname:@"name" citizenID:@"500" citizenIDExpiredDate:[NSDate distantFuture]];
    MSFClient *client = [request asynchronousFirstOrDefault:nil success:&success error:nil];
    
    // then
    expect(error).to(beNil());
    expect(client).to(beAKindOf(MSFClient.class));
    expect(@(client.authenticated)).to(beTruthy());
    expect(client.token).to(equal(@"foo"));
  });
});

QuickSpecEnd
