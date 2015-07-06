//
//  MSFXTClientSpec.m
//  Cash
//
//  Created by xutian on 15/5/15.
//  Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFClient.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <OHHTTPStubs/OHHTTPStubs.h>
#import <Mantle/Mantle.h>

#import "MSFApplyList.h"
#import "MSFClient+ApplyList.h"

#import "MSFServer.h"
#import "MSFResponse.h"


#import "MSFRepayMent.h"
#import "MSFClient+Repayment.h"

#import "MSFRepaymentSchedules.h"
#import "MSFClient+RepaymentSchedules.h"

#import "MSFPlanDetails.h"
#import "MSFClient+PlanDetails.h"

#import "MSFPlanPerodicTables.h"
#import "MSFClient+PlanPerodicTables.h"

#import "MSFInstallment.h"
#import "MSFClient+Installment.h"

#import "MSFTrade.h"
#import "MSFClient+Trades.h"

#import "MSFAccordToNperLists.h"
#import "MSFClient+AccordToNperLists.h"


QuickSpecBegin(MSFXTClientSpec)

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

beforeEach(^{
  client = [[MSFClient alloc] initWithServer:MSFServer.dotComServer];
  success = NO;
  error = nil;
});


it(@"should fetch repayment", ^{
  // given
  stubResponse(@"/repayment",@"repayment.json");
  
  // when
  RACSignal *request = [client fetchRepayment];
  MSFRepayMent *repayment = [request asynchronousFirstOrDefault:nil success:nil error:nil];
  
  // then
  expect(repayment).to(beAKindOf(MSFRepayMent.class));
});

it(@"should fetch repaymentschedules", ^{
  // given
  stubResponse(@"/plans",@"repaymentschedules.json");
  
  // when
  RACSignal *request = [client fetchRepaymentSchedules];
  MSFRepaymentSchedules *repaymentSchedules = [request asynchronousFirstOrDefault:nil success:nil error:nil];
  
  // then
  expect(repaymentSchedules).to(beAKindOf(MSFRepaymentSchedules.class));
});


it(@"should fetch plan the periodic table", ^{
  // given
  stubResponse(@"plans/1dafds782nj6/installments",@"planperodictables.json");
  
  MSFRepaymentSchedules * rs = mock([MSFRepaymentSchedules class]);
 // stubProperty(rs, planID, @"1dafds782nj6");
  // when
  RACSignal *request = [client fetchPlanPerodicTables:rs];
  MSFPlanPerodicTables *planPerodicTables = [request asynchronousFirstOrDefault:nil success:nil error:nil];
  
  // then
  expect(planPerodicTables).to(beAKindOf(MSFPlanPerodicTables.class));
});

it(@"should fetch install ment", ^{
  // given
  stubResponse(@"/installments/1",@"installment.json");
  MSFPlanPerodicTables *ppt = mock([MSFPlanPerodicTables class]);
 // stubProperty(ppt, installmentID, @"1");
  
  // when
  RACSignal *request = [client fetchInstallment:ppt];
  MSFInstallment *installMent = [request asynchronousFirstOrDefault:nil success:nil error:nil];
  
  // then
  expect(installMent).to(beAKindOf(MSFInstallment.class));
});


it(@"should fetch trade", ^{
  // given
  stubResponse(@"/transactions",@"trade.json");
  
  // when
  RACSignal *request = [client fetchTrades];
  MSFTrade *trade = [request asynchronousFirstOrDefault:nil success:nil error:nil];
  
  // then
  expect(trade).to(beAKindOf(MSFTrade.class));
});

it(@"should fetch accord to nper lists", ^{
  // given
  stubResponse(@"/loans/500/installments",@"accordtonperlist.json");
  
  MSFApplyList *al = mock([MSFApplyList class]);
  stubProperty(al, total_amount, @"500");
  // when
  RACSignal *request = [client fetchAccordToNperLists:al];
  MSFAccordToNperLists *accordToNperLists = [request asynchronousFirstOrDefault:nil success:nil error:nil];
  
  // then
  expect(accordToNperLists).to(beAKindOf(MSFAccordToNperLists.class));
  expect(accordToNperLists.installmentID).to(equal(@"1dafds782nj2"));
});

QuickSpecEnd