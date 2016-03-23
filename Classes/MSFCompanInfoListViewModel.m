//
//  MSFCompanInfoListViewModel.m
//  Finance
//
//  Created by xbm on 16/3/7.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFCompanInfoListViewModel.h"
#import "MSFCompanion.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface MSFCompanInfoListViewModel ()

@property (nonatomic, strong) MSFCompanion *model;

@end

@implementation MSFCompanInfoListViewModel

- (instancetype)initWithModel:(id)model {
	self = [super init];
	if (!self) {
		return nil;
	}
	_model = model;
	RAC(self, companName) = RACObserve(self, model.companName);
	RAC(self, companCellphone) = RACObserve(self, model.companCellphone);
	RAC(self, companCertId) = RACObserve(self, model.companCertId);
	RAC(self, companRelationship) = RACObserve(self, model.companRelationship);
	return self;
}

@end
