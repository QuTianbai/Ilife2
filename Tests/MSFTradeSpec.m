//
//  MSFTradeSpec.m
//  Cash
//
//  Created by xutian on 15/5/14.
//  Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFTrade.h"

QuickSpecBegin(MSFTradeSpec)

__block MSFTrade *trade;

beforeEach(^{
    NSURL *URL = [[NSBundle bundleForClass:self.class] URLForResource:@"trade" withExtension:@"json"];
    expect(URL).notTo(beNil());
    
    NSData *data = [NSData dataWithContentsOfURL:URL];
    NSDictionary *representation = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    
    trade = [MTLJSONAdapter modelOfClass:MSFTrade.class fromJSONDictionary:representation error:nil];
});

it(@"should has tradeDate tradeID tradeAmount tradeDescription", ^{
    expect(trade.tradeDate).to(beAKindOf([NSDate class]));
    expect(trade.tradeID).to(equal(@"1dafds782nj2"));
    expect(@(trade.tradeAmount)).to(equal(@6000));
    expect(trade.tradeDescription).to(equal(@"借款六千元"));
    
});

QuickSpecEnd
