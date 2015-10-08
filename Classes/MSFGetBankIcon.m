//
//  MSFGetBankIcon.m
//  Finance
//
//  Created by xbm on 15/10/1.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFGetBankIcon.h"

@implementation MSFGetBankIcon

+ (NSString *)getIconNameWithBankCode:(NSString *)bankcode {
	if ([bankcode isEqualToString:@"0103"]) {
		return @"ABC";//农业1
	} else if ([bankcode isEqualToString:@"0303"]) {
		return @"guangda";//光大2
	} else if ([bankcode isEqualToString:@"0308"]) {
		return @"CMBC";//招商3
	} else if ([bankcode isEqualToString:@"0102"]) {
		return @"ICBC";//工商4
	} else if ([bankcode isEqualToString:@"0305"]) {
		//民生5
		return @"CMSB";
	} else if ([bankcode isEqualToString:@"0105"]) {
		//建设6
		return @"CBC";
	} else if ([bankcode isEqualToString:@"0302"]) {
		return @"zhongxin";//中信7
	} else if ([bankcode isEqualToString:@"0309"]) {
		return @"xingye";//兴业8
	} else if ([bankcode isEqualToString:@"0104"]) {
		return @"china";//中国9
	} else if ([bankcode isEqualToString:@"0100"]) {
		return @"youzheng";//邮政10
	} else if ([bankcode isEqualToString:@"0306"]) {
		return @"guangfa";//广发11
	}

	return @"bankdefult";
}

@end
