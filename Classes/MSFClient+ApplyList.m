//
//	MSFClient+MSFApplyList.m
//	Cash
//
//	Created by xbm on 15/5/16.
//	Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFClient+ApplyList.h"
#import "MSFApplyList.h"
#import "RACSignal+MSFClientAdditions.h"
#import "MSFResponse.h"

@implementation MSFClient (ApplyList)

- (RACSignal *)fetchMSApplyList {
//	NSString *path = [[NSBundle mainBundle] pathForResource:@"MSFApplyList" ofType:@"json"];
//	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]];
	NSURLRequest *request = [self requestWithMethod:@"POST" path:@"loan/applyList" parameters:nil];
	return [[[self enqueueRequest:request resultClass:MSFApplyList.class] msf_parsedResults] collect];
}

- (RACSignal *)fetchSpicyApplyList {
//	NSString *path = [[NSBundle mainBundle] pathForResource:@"MSFSpicyApplyList" ofType:@"json"];
//	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]];
	NSURLRequest *request = [self requestWithMethod:@"POST" path:@"append/applyList" parameters:nil];
	return [[[self enqueueRequest:request resultClass:MSFApplyList.class] msf_parsedResults] collect];
}

/*
- (id)filter:(id)obj class:(Class)class {
	if ([obj isKindOfClass:class]) {
		return obj;
	} else {
		if (class == NSString.class) {
			if ([obj isKindOfClass:NSNumber.class]) {
				return [obj stringValue];
			}
			return @"";
		} else if (class == NSArray.class) {
			return @[];
		} else if (class == NSDictionary.class) {
			return @{};
		}
		return nil;
	}
}

- (NSArray *)convertArray:(NSArray *)array {
	if (![array isKindOfClass:NSArray.class] || array.count == 0) {
		return nil;
	}
	NSMutableArray *mArray = [NSMutableArray array];
	for (int i = 0; i < array.count; i++) {
		MSFResponse *response = array[i];
		NSDictionary *dic = response.parsedResult;
		NSDictionary *apply =
	@{@"apply_time" : [self filter:dic[@"applyTime"] class:NSString.class],
		@"total_amount" : [self filter:dic[@"appLmt"] class:NSString.class],
		@"total_installments" : [self filter:dic[@"loanTerm"] class:NSString.class],
		@"statusString" : [self filter:dic[@"status"] class:NSString.class],
		@"loan_id" : [self filter:dic[@"appNo"] class:NSString.class]};
		[mArray addObject:apply];
	}
	if (mArray.count > 0) {
		return mArray;
	}
	return nil;
}
*/
- (RACSignal *)fetchRepayURLWithAppliList:(MSFApplyList *)applylist {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		NSURLRequest *request = [self requestWithMethod:@"GET" path:@"coresys/cont/contract/pageQuery" parameters:@{@"applyId": applylist.appNo}];
		[subscriber sendNext:request];
		[subscriber sendCompleted];
		return nil;
	}];
}

@end
