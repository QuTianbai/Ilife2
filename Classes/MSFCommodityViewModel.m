//
//  MSFCommodityViewModel.m
//  Finance
//
//  Created by xbm on 16/3/7.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFCommodityViewModel.h"
#import "MSFPhoto.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFClient+Photos.h"

@interface MSFCommodityViewModel ()

@property (nonatomic, strong, readwrite) NSArray *photos;
@property (nonatomic, weak) id <MSFViewModelServices> services;

@end

@implementation MSFCommodityViewModel
- (instancetype)initWithServices:(id<MSFViewModelServices>)services {
	self = [super init];
	if (!self) {
		return nil;
	}
	_services = services;
	@weakify(self)
	[self.didBecomeActiveSignal subscribeNext:^(id x) {
		@strongify(self)
		[self.fetchPhotos subscribeNext:^(id x) {
			self.photos = x;
		}];
	}];
	return self;
}

- (RACSignal *)fetchPhotos {
	return [[self.services.httpClient fetchAdv:@"B"] collect];
}

@end
