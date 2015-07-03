//
//  MSFPlanPerodicTablesSpec.m
//  Cash
//
//  Created by xutian on 15/5/15.
//  Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFPlanPerodicTables.h"
QuickSpecBegin(MSFPlanPerodicTablesSpec)

__block  MSFPlanPerodicTables *planPerodicTables;

beforeEach(^{
    NSURL *URL = [[NSBundle bundleForClass:self.class] URLForResource:@"planperodictables" withExtension:@"json"];
    expect(URL).notTo(beNil());
    NSData *data = [NSData dataWithContentsOfURL:URL];
    NSDictionary *representation = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    
    planPerodicTables = [MTLJSONAdapter modelOfClass:MSFPlanPerodicTables.class fromJSONDictionary:representation error:nil];
});

it(@"should has contractNum repaymentTime repaymentAmount amountType contractStatus", ^{
  expect(planPerodicTables.contractNum).to(equal(@"1dafds782nj5"));
  expect(planPerodicTables.repaymentTime).to(equal(@"1dafds782nj6"));
  expect(@(planPerodicTables.repaymentAmount)).to(equal(@197));
  expect(planPerodicTables.amountType).to(equal(@"1dafds7828"));
  expect(planPerodicTables.contractStatus).to(equal(@"1dafds7820"));
});

QuickSpecEnd