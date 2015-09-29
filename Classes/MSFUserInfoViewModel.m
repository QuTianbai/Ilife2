//
//  MSFUserInfoViewModel.m
//  Finance
//
//  Created by 赵勇 on 9/29/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFUserInfoViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface MSFUserInfoViewModel ()

@property (nonatomic, weak, readwrite) id<MSFViewModelServices>services;

@end

@implementation MSFUserInfoViewModel

- (instancetype)initWithServices:(id<MSFViewModelServices>)services {
	self = [super init];
	if (self) {
		_services = services;
		
		
		
	}
	return self;
}

@end
