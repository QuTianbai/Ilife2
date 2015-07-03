//
//  MSFPlanDetailsSpec.m
//  Cash
//
//  Created by xutian on 15/5/15.
//  Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFPlanDetails.h"
QuickSpecBegin(MSFPlanDetailsSpec)
__block  MSFPlanDetails *planDetails;

beforeEach(^{
    NSURL *URL = [[NSBundle bundleForClass:self.class] URLForResource:@"plandetails" withExtension:@"json"];
    expect(URL).notTo(beNil());
    
    NSData *data = [NSData dataWithContentsOfURL:URL];
    NSDictionary *representation = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    
    planDetails = [MTLJSONAdapter modelOfClass:MSFPlanDetails.class fromJSONDictionary:representation error:nil];
});

it(@"should has planID time thePrincipal interest serviceCharge totalMoney", ^{
    expect(planDetails.planID).to(equal(@"1dafds782nj8"));
    expect(planDetails.time).to(equal(@"2015-05-03T15:38:45Z"));
    expect(@(planDetails.repaymentAmount)).to(equal(@197));
    expect(@(planDetails.interest)).to(equal(@0.99));
    expect(@(planDetails.serviceCharge)).to(equal(@2.00));
    expect(@(planDetails.totalMoney)).to(equal(@199.99));
    
});

QuickSpecEnd


