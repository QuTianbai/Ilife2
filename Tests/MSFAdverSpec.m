//
//  MSFAdverSpec.m
//  Cash
//
//  Created by xbm on 15/5/14.
//  Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFAdver.h"
//#import "MSFClient.h"

QuickSpecBegin(MSFAdverSpec)
__block MSFAdver* adver1;
__block MSFAdver* adver2;

beforeEach(^{
    NSURL* URL=[[NSBundle bundleForClass:self.class] URLForResource:@"adver" withExtension:@"json"];
    expect(URL).notTo(beNil());
    NSData* data=[NSData dataWithContentsOfURL:URL];
    NSArray* representation=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    //adver=[MTLJSONAdapter modelOfClass:MSFAdver.class fromJSONDictionary:representation error:nil];
    adver1=[[MTLJSONAdapter modelsOfClass:MSFAdver.class fromJSONArray:representation error:nil] firstObject];
    adver2=[[MTLJSONAdapter modelsOfClass:MSFAdver.class fromJSONArray:representation error:nil] lastObject];
});

//TODO: merge pull request from !25 YongZhao/master
/*
it(@"should has adID",^{
    expect(adver1.adID).to(equal(@"1dafds782nj2"));
    expect(adver1.title).to(equal(@"title"));
    expect(@(adver1.type)).to(equal(@0));
    expect(adver1.adDescription).to(equal(@"description"));
    expect(adver1.adURL).to(equal([NSURL URLWithString:@"http://url.com"]));
    expect(adver1.imgURL).to(equal([NSURL URLWithString:@"http://imgurl.com"]));
});
it(@"should has adID2",^{
    expect(adver2.adID).to(equal(@"1dafds782nj3"));
    expect(adver2.title).to(equal(@"title2"));
     expect(@(adver2.type)).to(equal(@0));
    expect(adver2.adDescription).to(equal(@"description2"));
    expect(adver2.adURL).to(equal([NSURL URLWithString:@"http://url.co2m"]));
    expect(adver2.imgURL).to(equal([NSURL URLWithString:@"http://imgurl.co2m"]));
});
*/
QuickSpecEnd


