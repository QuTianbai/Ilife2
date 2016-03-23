//
//  MSFApplyListSpec.m
//  Cash
//
//  Created by xbm on 15/5/16.
//  Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSFApplyList.h"

QuickSpecBegin(MSFApplyListSpec)
__block MSFApplyList* applylist1;
__block MSFApplyList* applylist2;
beforeEach(^{
    NSURL* URL=[[NSBundle bundleForClass:self.class] URLForResource:@"applyList" withExtension:@"json"];
    expect(URL).notTo(beNil());
    NSData* data=[NSData dataWithContentsOfURL:URL];
    NSArray* representation=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    //adver=[MTLJSONAdapter modelOfClass:MSFAdver.class fromJSONDictionary:representation error:nil];
    applylist1=[[MTLJSONAdapter modelsOfClass:MSFApplyList.class fromJSONArray:representation error:nil] firstObject];
    applylist2=[[MTLJSONAdapter modelsOfClass:MSFApplyList.class fromJSONArray:representation error:nil] lastObject];
});
it(@"should has adID",^{
    expect(applylist1.loan_id).to(equal(@"1dafds782nj2"));
    expect(applylist1.apply_time).to(equal(@"2015-05-03T15:38:45Z"));
    expect(applylist1.payed_amount).to(equal(@"200"));
    expect(applylist1.total_amount).to(equal(@"300"));
    expect(applylist1.monthly_repayment_amount).to(equal(@"400"));
    expect(@(applylist1.current_installment)).to(equal(@4));
    expect(@(applylist1.total_installments)).to(equal(@10));
    expect(@(applylist1.status)).to(equal(@0));

});
it(@"should has adID2",^{
    expect(applylist2.loan_id).to(equal(@"1dafds782nj4"));
    expect(applylist2.apply_time).to(equal(@"2015-05-03T15:38:45Z"));
    expect(applylist2.payed_amount).to(equal(@"201"));
    expect(applylist2.total_amount).to(equal(@"400"));
    expect(applylist2.monthly_repayment_amount).to(equal(@"3000"));
    expect(@(applylist2.current_installment)).to(equal(@4));
    expect(@(applylist2.total_installments)).to(equal(@10));
    expect(@(applylist2.status)).to(equal(@1));
    
});
QuickSpecEnd
