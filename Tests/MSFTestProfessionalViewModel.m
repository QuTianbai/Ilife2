//
// MSFTestProfessionalViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFTestProfessionalViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFSelectKeyValues.h"

@implementation MSFTestProfessionalViewModel

- (RACSignal *)educationSignal {
	MSFSelectKeyValues *model = [[MSFSelectKeyValues alloc] initWithDictionary:@{
		@"code": @"1",
		@"text": @"bar",
	} error:nil];
	self.degrees = model;
	return [RACSignal return:nil];
}

- (RACSignal *)socialStatusSignal {
	MSFSelectKeyValues *model = [[MSFSelectKeyValues alloc] initWithDictionary:@{
		@"code": @"1",
		@"text": @"foo",
	} error:nil];
	self.socialstatus = model;
	return [RACSignal return:nil];
}

- (RACSignal *)workingLengthSignal {
	MSFSelectKeyValues *model = [[MSFSelectKeyValues alloc] initWithDictionary:@{
		@"code": @"1",
		@"text": @"11",
	} error:nil];
	self.seniority = model;
	return [RACSignal return:nil];
}

- (RACSignal *)industrySignal {
	MSFSelectKeyValues *model = [[MSFSelectKeyValues alloc] initWithDictionary:@{
		@"code": @"1",
		@"text": @"bar",
	} error:nil];
	self.industry = model;
	return [RACSignal empty];
}

- (RACSignal *)natureSignal {
	MSFSelectKeyValues *model = [[MSFSelectKeyValues alloc] initWithDictionary:@{
		@"code": @"1",
		@"text": @"bar",
	} error:nil];
	self.nature = model;
	return [RACSignal empty];
}

@end
