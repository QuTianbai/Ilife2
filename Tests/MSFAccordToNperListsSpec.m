//
//  MSFAccordToNperListsSpec.m
//  Cash
//
//  Created by xutian on 15/5/16.
//  Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFAccordToNperLists.h"

QuickSpecBegin(MSFAccordToNperListsSpec)

__block  MSFAccordToNperLists *accordToNperLists;

beforeEach(^{
    NSURL *URL = [[NSBundle bundleForClass:self.class] URLForResource:@"accordtonperlist" withExtension:@"json"];
    expect(URL).notTo(beNil());
    NSData *data = [NSData dataWithContentsOfURL:URL];
    NSDictionary *representation = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    
    accordToNperLists = [MTLJSONAdapter modelOfClass:MSFAccordToNperLists.class fromJSONDictionary:representation error:nil];
});

it(@"should has installmentID nper", ^{
    expect(accordToNperLists.installmentID).to(equal(@"1dafds782nj2"));
    expect(@(accordToNperLists.nper)).to(equal(@4));
    
});

QuickSpecEnd