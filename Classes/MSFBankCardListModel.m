//
//  MSFBankCardListModel.m
//  Finance
//
//  Created by xbm on 15/9/29.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFBankCardListModel.h"

@implementation MSFBankCardListModel

+ (NSValueTransformer *)bankCardIdJSONTransformer {
	return [MTLValueTransformer transformerWithBlock:^id(id x) {
		if ([x isKindOfClass:NSString.class]) {
			return x;
		} else if ([x isKindOfClass:NSNumber.class]) {
			return [x stringValue];
		} else {
			return nil;
		}
	}];
}

@end
