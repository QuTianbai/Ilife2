//
//  MSFApplyInfo.m
//  Cash
//
//  Created by xbm on 15/5/16.
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSFApplicationForms.h"

QuickSpecBegin(MSFApplyInfoSpec)
__block MSFApplicationForms* applyinfo;

beforeEach(^{
    NSURL* URL=[[NSBundle bundleForClass:self.class] URLForResource:@"loadinfo" withExtension:@"json"];
    expect(URL).notTo(beNil());
    NSData* data=[NSData dataWithContentsOfURL:URL];
    NSDictionary* representation=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    //adver=[MTLJSONAdapter modelOfClass:MSFAdver.class fromJSONDictionary:representation error:nil];
    applyinfo=[MTLJSONAdapter modelOfClass:MSFApplicationForms.class fromJSONDictionary:representation error:nil];
  
});
it(@"should has adID",^{
    expect(applyinfo.loanId).to(equal(@"119"));
   
});
QuickSpecEnd

