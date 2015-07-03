//
//  MSFInstallmentSpec.m
//  Cash
//
//  Created by xutian on 15/5/14.
//  Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFInstallment.h"
QuickSpecBegin(MSFInstallmentSpec)

__block  MSFInstallment *installment;

beforeEach(^{
    NSURL *URL = [[NSBundle bundleForClass:self.class] URLForResource:@"installment" withExtension:@"json"];
    expect(URL).notTo(beNil());
    
    NSData *data = [NSData dataWithContentsOfURL:URL];
    NSDictionary *representation = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    
    installment = [MTLJSONAdapter modelOfClass:MSFInstallment.class fromJSONDictionary:representation error:nil];
});

it(@"should has installmentID planID loanID thePrincipal interest serviceCharge totalMoney", ^{
    expect(installment.installmentID).to(equal(@"1dafds782nj5"));
    expect(installment.planID).to(equal(@"1dafds782nj6"));
    expect(installment.loanID).to(equal(@"1dafds7828"));
    expect(@(installment.thePrincipal)).to(equal(@197));
    expect(@(installment.interest)).to(equal(@0.99));
    expect(@(installment.serviceCharge)).to(equal(@2));
    expect(@(installment.totalMoney)).to(equal(@199.99));
    
});

QuickSpecEnd