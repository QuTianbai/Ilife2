//
//	MSFApplyCash.m
//	Cash
//
//	Created by xbm on 15/5/16.
//	Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFApplicationResponse.h"

@implementation MSFApplicationResponse

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
		@"applyID":@"id"
		};
}

- (BOOL)validateApplyID:(id *)applyID error:(NSError **)error {
	id product = *applyID;
	if ([product isKindOfClass:NSString.class]) {
		return YES;
	} else if ([product isKindOfClass:NSNumber.class]) {
		*applyID = [product stringValue];
		return YES;
	}
	return *applyID == nil;
}

- (BOOL)validatePersonId:(id *)personId error:(NSError **)error {
	id product = *personId;
	if ([product isKindOfClass:NSString.class]) {
		return YES;
	} else if ([product isKindOfClass:NSNumber.class]) {
		*personId = [product stringValue];
		return YES;
	}
	return *personId == nil;
}

@end
