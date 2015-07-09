//
// MSFApplyStartViewModelSpec.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFTestApplyViewModel.h"
#import <OHHTTPStubs/OHHTTPStubs.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "MSFClient.h"
#import "MSFUser.h"
#import "MSFServer.h"

#import "MSFCheckEmployee.h"
#import "MSFApplyInfo.h"
#import "MSFApplyCash.h"

QuickSpecBegin(MSFApplyStartViewModelSpec)


/*
__block MSFCheckEmployee *range;
__block MSFApplyInfo *apply;
__block MSFTestApplyViewModel *viewModel;

__block NSError *error;
__block BOOL success;

beforeEach(^{
  NSDictionary *representation = @{
    @"teams" :
      @[@{
          @"team" :
            @[@{
                @"period" : @"3",
                @"productId" : @"23"
                }],
          @"minAmount" : @"2000",
          @"maxAmount" : @"5000"
          }],
    @"allMaxAmount" : @"25000",
    @"allMinAmount" : @"2000",
    @"white" : @0,
    @"employee" : @"0"
    };
  
  range = [MTLJSONAdapter modelOfClass:MSFCheckEmployee.class fromJSONDictionary:representation error:nil];
  expect(range).notTo(beNil());
  
  NSURL *URL = [[NSBundle bundleForClass:self.class] URLForResource:@"loaninfo" withExtension:@"json"];
  NSData *data = [NSData dataWithContentsOfURL:URL];
  representation = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
  
  apply = [MTLJSONAdapter modelOfClass:MSFApplyInfo.class fromJSONDictionary:representation error:nil];
  expect(apply).notTo(beNil());
  
  MSFUser *user = mock(MSFUser.class);
  stubProperty(user, server, MSFServer.dotComServer);
  MSFClient *client = [MSFClient authenticatedClientWithUser:user token:@"" session:@""];
  [MSFTestApplyViewModel setHttpClient:client];
  
  viewModel = [[MSFTestApplyViewModel alloc] initWithEmployee:range applyInfo:apply];
  
  error = nil;
  success = NO;
});


it(@"should create new viewModel", ^{
  // then
  expect(viewModel).notTo(beNil());
});
*/

QuickSpecEnd
