//
// MSFAgreementSpec.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFAgreement.h"
#import "MSFServer.h"

QuickSpecBegin(MSFAgreementSpec)

__block MSFAgreement *agreement;

beforeEach(^{
  agreement = [[MSFAgreement alloc] initWithServer:MSFServer.dotComServer];
  
});

it(@"should initialize", ^{
  // then
  expect(agreement).notTo(beNil());
  expect(agreement.userURL).to(equal([NSURL URLWithString:@"https://msfinance.cn/agreement/user"]));
  expect(agreement.loanURL).to(equal([NSURL URLWithString:@"https://msfinance.cn/agreement/loan"]));
});

QuickSpecEnd
