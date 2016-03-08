//
//	MSFClient+ApplyInfo.m
//	Cash
//
//	Created by xbm on 15/5/16.
//	Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFClient+ApplyInfo.h"
#import "MSFApplicationForms.h"
#import "MSFResponse.h"
#import "MSFUser.h"
#import "NSDateFormatter+MSFFormattingAdditions.h"
#import "RACSignal+MSFClientAdditions.h"
#import "NSObject+MSFValidItem.h"

@implementation MSFClient (ApplyInfo)

- (RACSignal *)fetchApplyInfo {
	return RACSignal.empty;
}

- (NSDictionary *)convertDictionary:(NSDictionary *)dic {
	return @{};
}

- (NSDictionary *)convertToSubmit:(id)forms {
	return @{};
}

- (RACSignal *)submitUserInfo:(MSFApplicationForms *)model infoType:(int)type {
	return RACSignal.empty;
}

@end
