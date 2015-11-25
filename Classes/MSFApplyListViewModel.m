//
//  MSFApplyListViewModel.m
//  Finance
//
//  Created by 赵勇 on 11/24/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFApplyListViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFClient+ApplyList.h"

@interface MSFApplyListViewModel ()

@property (nonatomic, weak) id<MSFViewModelServices>services;

@end

@implementation MSFApplyListViewModel

- (instancetype)initWithServices:(id<MSFViewModelServices>)services {
	self = [super init];
	if (self) {
		_services = services;
	}
	return self;
}

- (RACSignal *)fetchApplyListSignal:(int)type {
	return [self.services.httpClient fetchSpicyApplyList:type + 1];
}

@end
