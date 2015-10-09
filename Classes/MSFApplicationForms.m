//
//	MSFApplyInfo.m
//	Cash
//
//	Created by xbm on 15/5/16.
//	Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFApplicationForms.h"
#import "MSFPhotoStatus.h"
#import "NSDateFormatter+MSFFormattingAdditions.h"

@implementation MSFApplicationForms

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{@"loanId":@"id"};
}

+ (NSValueTransformer *)whitePhotoJSONTransformer {
	return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(id photo) {
		if (![photo isKindOfClass:NSDictionary.class]) {
			return nil;
		}
		
		return [MTLJSONAdapter modelOfClass:MSFPhotoStatus.class fromJSONDictionary:photo error:nil];
	} reverseBlock:^id(MSFPhotoStatus *whitePhoto) {
		return whitePhoto.dictionaryValue;
	}];
}

+ (NSValueTransformer *)contrastListJSONTransformer {
	return [MTLValueTransformer mtl_JSONArrayTransformerWithModelClass:MSFUserContact.class];
}

+ (NSValueTransformer *)repayMoneyJSONTransformer {
	return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(NSString *num) {
		return num.intValue>=0?num:@"";
	} reverseBlock:^id(NSString *str) {
		if (str==nil) {
			return [NSDecimalNumber decimalNumberWithString:str];
		}
		
		return nil;
	}];
}

+ (NSValueTransformer *)principalJSONTransformer {
	return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(NSString *num) {
		return num.intValue>=0?num:@"";
	} reverseBlock:^id(NSString *str) {
		if (str==nil) {
			return [NSDecimalNumber decimalNumberWithString:str];
		}
		
		return nil;
	}];
}

@end
