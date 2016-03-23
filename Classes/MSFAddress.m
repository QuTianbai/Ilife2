//
//	MSFAreas.m
//	Cash
//
//	Created by xbm on 15/5/24.
//	Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFAddress.h"

@implementation MSFAddress

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
		@"name": @"area_name",
		@"codeID": @"area_code",
		@"parentCodeID": @"parent_area_code"
	};
}

+ (NSDictionary *)FMDBColumnsByPropertyKey {
	return @{
		@"name": @"area_name",
		@"codeID": @"area_code",
		@"parentCodeID": @"parent_area_code"
	};
}

+ (NSArray *)FMDBPrimaryKeys {
	return @[
		@"area_code"
	];
}

+ (NSString *)FMDBTableName {
	return @"basic_dic_area";
}

#pragma mark - MSFSelectionItem

- (NSString *)title {
	return self.name;
}

- (NSString *)subtitle {
	return @"";
}

@end
