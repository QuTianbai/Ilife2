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
    @keypath(MSFUser.new, phone): @"18696995689",
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
    expect(request.URL).to(equal([NSURL URLWithString:@"https://api.msfinance.cn/get"]));
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
    stubResponse(@"/app/check_version",@"releasenote.json");
    
    // when
    RACSignal *request = [client fetchReleaseNote];
    MSFReleaseNote *releasenote = [request asynchronousFirstOrDefault:nil success:nil error:nil];
    
    // then
    expect(releasenote).to(beAKindOf(MSFReleaseNote.class));
    expect(@(releasenote.status)).to(equal(@1));
  });
  
  it(@"should fetch empty releasenote", ^{
    // given
    stubResponse(@"/app/check_version",@{});
    
    // when
    RACSignal *request = [client fetchReleaseNote];
    MSFReleaseNote *releasenote = [request asynchronousFirstOrDefault:nil success:&success error:&error];
    
    // then
    expect(@(success)).to(beTruthy());
    expect(releasenote).to(beNil());
    expect(error).to(beNil());
  });
  
  it(@"should user forget password", ^{
    // given
    stubResponse(@"/users/forget_password",@{@"message":@"success"});
    
    // when
    RACSignal *request = [client resetPassword:@"" phone:@"" captcha:@""];
    MSFResponse *response = [request asynchronousFirstOrDefault:nil success:nil error:nil];
    
    // then
    expect(response.parsedResult[@"message"]).to(equal(@"success"));
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
});

describe(@"authenticated", ^{
  beforeEach(^{
    client = [MSFClient authenticatedClientWithUser:user token:@"" session:@""];
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
    expect(user.phone).to(equal(@"15222222222"));
  });
  
  it(@"should update user password", ^{
    stubResponse(@"/users/1/update_password",@{@"message": @"foo"});
    
    // when
    RACSignal *request = [client updateUserPassword:@"" password:@""];
    MSFResponse *response = [request asynchronousFirstOrDefault:nil success:&success error:&error];
    
    // then
    expect(response.parsedResult[@"message"]).to(equal(@"foo"));
  });
  
  it(@"should update user avatar", ^{
    // given
    stubResponse(@"/users/1/update_avatar",@{@"avatar": @{@"url": @"http://msf.com/new_avatar.jpg"}});
    
    // when
    NSURL *URL = [[NSBundle bundleForClass:self.class] URLForResource:@"avatar" withExtension:@"jpg"];
    RACSignal *request = [client updateUserAvatarWithFileURL:URL];
    MSFUser *user = [request asynchronousFirstOrDefault:nil success:nil error:nil];
    
    // then
    expect(user.avatarURL).to(equal([NSURL URLWithString:@"http://msf.com/new_avatar.jpg"]));
  });
  
  it(@"should bind bank card", ^{
    // given
    stubResponse(@"/users/1/bind_bank_card",@"authorizations.json");
    
    // when
    RACSignal *request = [client associateUserPasscard:@"" bank:@"" country:@"" province:@"" city:@"" address:@""];
    MSFUser *user = [request asynchronousFirstOrDefault:nil success:nil error:nil];
    
    // then
    expect(user.passcard).to(equal(@"563"));
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
  it(@"should request authenticated", ^{
    // given
    [OHHTTPStubs addRequestHandler:^OHHTTPStubsResponse *(NSURLRequest *request, BOOL onlyCheck) {
      NSURL *fileURL = [[NSBundle bundleForClass:self.class] URLForResource:@"authorizations" withExtension:@"json"];
      return [OHHTTPStubsResponse responseWithFileURL:fileURL statusCode:200 responseTime:0 headers:@{
         @"Content-Type": @"application/json",
         @"finance": @"token",
         @"msfinance": @"objectid",
         }];
    }];
    
    // when
    RACSignal *request = [MSFClient signInAsUser:user password:@"123456" phone:@"" captcha:@""];
    MSFClient *client = [request asynchronousFirstOrDefault:nil success:&success error:nil];
    
    // then
    expect(error).to(beNil());
    expect(client).to(beAKindOf(MSFClient.class));
    expect(@(client.authenticated)).to(beTruthy());
    expect(client.token).to(equal(@"token"));
  });
  
  it(@"should sign up a user", ^{
    // given
    [OHHTTPStubs addRequestHandler:^OHHTTPStubsResponse *(NSURLRequest *request, BOOL onlyCheck) {
      NSURL *fileURL = [[NSBundle bundleForClass:self.class] URLForResource:@"authorizations" withExtension:@"json"];
      return [OHHTTPStubsResponse responseWithFileURL:fileURL statusCode:200 responseTime:0 headers:@{
         @"Content-Type": @"application/json",
         @"finance": @"token",
         @"msfinance": @"objectid",
         }];
    }];
    
    // when
    RACSignal *request = [MSFClient signUpAsUser:user password:@"123456" phone:@"" captcha:@""];
    MSFClient *client = [request asynchronousFirstOrDefault:nil success:&success error:nil];
    
    // then
    expect(error).to(beNil());
    expect(client).to(beAKindOf(MSFClient.class));
    expect(@(client.authenticated)).to(beTruthy());
    expect(client.token).to(equal(@"token"));
  });
});

QuickSpecEnd
