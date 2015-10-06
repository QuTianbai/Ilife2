//
//  MSFRepaymentScheduleSpec.m
//  Cash
//
//  Created by xutian on 15/5/15.
//  Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFRepaymentSchedules.h"
QuickSpecBegin(MSFRepayMentSchedulesSpec)
__block  MSFRepaymentSchedules *repayMentSchedules;

beforeEach(^{
    NSURL *URL = [[NSBundle bundleForClass:self.class] URLForResource:@"repaymentschedules" withExtension:@"json"];
    expect(URL).notTo(beNil());
    
    NSData *data = [NSData dataWithContentsOfURL:URL];
    NSDictionary *representation = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    
    repayMentSchedules = [MTLJSONAdapter modelOfClass:MSFRepaymentSchedules.class fromJSONDictionary:representation error:nil];
});

it(@"should has contractNum contractStatus repaymentTime repaymentTotalAmount", ^{
  expect(repayMentSchedules.contractNum).to(equal(@"1dafds782nj8"));
  expect(repayMentSchedules.contractStatus).to(equal(@"1dafds782nj9"));
  expect(repayMentSchedules.repaymentTime).to(equal(@"2015-05-03T15:38:45Z"));
  expect(repayMentSchedules.repaymentTotalAmount).to(equal(@"0.99"));
});

QuickSpecEnd