//
// MSFTestAddressViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFTestAddressViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFAreas.h"

@implementation MSFTestAddressViewModel

- (RACSignal *)fetchProvince {
	MSFAreas *area = [[MSFAreas alloc] initWithDictionary:@{
		@"name": @"重庆市",
		@"codeID": @"bar",
	} error:nil];
	self.province = area;
	return [RACSignal return:area];
}

- (RACSignal *)fetchCity {
	MSFAreas *area = [[MSFAreas alloc] initWithDictionary:@{
		@"name": @"直辖市",
		@"codeID": @"foo",
	} error:nil];
	self.city = area;
	return [RACSignal return:area];
}

- (RACSignal *)fetchArea {
	MSFAreas *area = [[MSFAreas alloc] initWithDictionary:@{
		@"name": @"沙坪坝区",
		@"codeID": @"abc",
	} error:nil];
	self.area = area;
	return [RACSignal return:area];
}

- (MSFAreas *)regionWithCode:(NSString *)code {
	if ([code isEqualToString:@"0"]) return [[MSFAreas alloc] initWithDictionary:@{@"name": @"重庆市", @"codeID": @"0"} error:nil];
	if ([code isEqualToString:@"1"]) return [[MSFAreas alloc] initWithDictionary:@{@"name": @"直辖市", @"codeID": @"1"} error:nil];
	if ([code isEqualToString:@"2"]) return [[MSFAreas alloc] initWithDictionary:@{@"name": @"沙坪坝区", @"codeID": @"2"} error:nil];

	return nil;
}

@end
