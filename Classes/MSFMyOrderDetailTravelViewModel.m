//
//  MSFMyOrderDetailTravelViewModel.m
//  Finance
//
//  Created by xbm on 16/3/4.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFMyOrderDetailTravelViewModel.h"
#import "MSFTravel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface MSFMyOrderDetailTravelViewModel ()

@property (nonatomic, strong) MSFTravel *model;

@end

@implementation MSFMyOrderDetailTravelViewModel

- (instancetype)initWithModel:(id)model {
	self = [super init];
	if (!self) {
		return nil;
	}
	_model = model;
	RAC(self, departureTime) = RACObserve(self, model.departureTime);
	RAC(self, returnTime) = RACObserve(self, model.returnTime);
	RAC(self, isNeedVisa) = RACObserve(self, model.isNeedVisa);
	RAC(self, origin) = RACObserve(self, model.origin);
	RAC(self, destination) = RACObserve(self, model.destination);
	RAC(self, travelNum) = RACObserve(self, model.travelNum);
	RAC(self, travelKidsNum) = RACObserve(self, model.travelKidsNum);
	RAC(self, travelType) = RACObserve(self, model.travelType);
	
	RAC(self, title) = [[RACObserve(self, model) ignore:nil] map:^id(MSFTravel *value) {
		return [NSString stringWithFormat:@"%@%@", value.destination, value.travelType];
	}];
	
	return self;
}

@end
