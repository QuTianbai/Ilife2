//
//  MSFBankInfoModel.m
//  Finance
//
//  Created by xbm on 15/8/31.
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFBankInfoModel.h"

@implementation MSFBankInfoModel

+ (NSDictionary *)FMDBColumnsByPropertyKey {
	return @{
					 @"bin": @"bank_bin",
					 @"name": @"bank_name",
					 @"type": @"bank_type",
					 @"support": @"bank_support",
					 @"code": @"bank_code",
					 @"maxSize": @"bank_max_size"
					 };
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
					 @"bin": @"bank_bin",
					 @"name": @"bank_name",
					 @"type": @"bank_type",
					 @"support": @"bank_support",
					 @"code": @"bank_code",
					 @"maxSize": @"bank_max_size"
					 };
}

+ (NSArray *)FMDBPrimaryKeys {
	return @[@"bank_bin"];
}

+ (NSString *)FMDBTableName {
	return @"basic_bank_bin";
}

@end
