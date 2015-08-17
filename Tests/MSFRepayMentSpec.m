//
//  MSFRepayMentSpec.m
//  Cash
//
//  Created by xutian on 15/5/15.
//  Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFRepayMent.h"
QuickSpecBegin(MSFRepayMentSpec)
__block  MSFRepayMent *repayMent;

beforeEach(^{
    NSURL *URL = [[NSBundle bundleForClass:self.class] URLForResource:@"repayment" withExtension:@"json"];
    expect(URL).notTo(beNil());
    
    NSData *data = [NSData dataWithContentsOfURL:URL];
    NSDictionary *representation = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    
    repayMent = [MTLJSONAdapter modelOfClass:MSFRepayMent.class fromJSONDictionary:representation error:nil];
});


it(@"should has repaymentID expireDate allAmount", ^{
    expect(repayMent.repaymentID).to(equal(@"1dafds782nj6"));
    expect(repayMent.expireDate).to(equal(@"2015年01月01日"));
    expect(@(repayMent.allAmount)).to(equal(@197));
    
});

QuickSpecEnd

