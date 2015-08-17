//
//	MSFTrade.m
//	Cash
//	交易
//	Created by xutian on 15/5/14.
//	Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFTrade.h"
#import "NSDateFormatter+MSFFormattingAdditions.h"

@implementation MSFTrade
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
		@"tradeID": @"transaction_id",
		@"tradeDate": @"date",
		@"tradeAmount": @"amount",
		@"tradeDescription": @"description",
		};
}

+ (NSValueTransformer *)tradeDateJSONTransformer {
	return [MTLValueTransformer reversibleTransformerWithBlock:^(NSString *num) {
		return [NSDateFormatter msf_dateFromString:num];
	}];
}

@end
