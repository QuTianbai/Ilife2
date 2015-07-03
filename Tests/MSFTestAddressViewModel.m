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
	} error:nil];
	self.province = area;
	return [RACSignal return:area];
}

- (RACSignal *)fetchCity {
	MSFAreas *area = [[MSFAreas alloc] initWithDictionary:@{
		@"name": @"直辖市",
	} error:nil];
	self.city = area;
	return [RACSignal return:area];
}

- (RACSignal *)fetchArea {
	MSFAreas *area = [[MSFAreas alloc] initWithDictionary:@{
		@"name": @"沙坪坝区",
	} error:nil];
	self.area = area;
	return [RACSignal return:area];
}

@end
