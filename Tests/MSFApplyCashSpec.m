//
//  MSFApplyCash.m
//  Cash
//
//  Created by xbm on 15/5/16.
//  Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import "MSFApplicationResponse.h"

QuickSpecBegin(MSFApplyCashSpec)
__block MSFApplicationResponse* applycash;

beforeEach(^{
    NSURL* URL=[[NSBundle bundleForClass:self.class] URLForResource:@"applycash" withExtension:@"json"];
    expect(URL).notTo(beNil());
    NSData* data=[NSData dataWithContentsOfURL:URL];
    NSDictionary* representation=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    applycash=[MTLJSONAdapter modelOfClass:MSFApplicationResponse.class fromJSONDictionary:representation error:nil];
});
it(@"should has message",^{
    
    //expect(applycash.message).to(equal(@"message1"));
    
});
QuickSpecEnd