//
//  MSFCmdDetailViewModel.m
//  Finance
//
//  Created by xbm on 16/3/1.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFCmdDetailViewModel.h"
#import "MSFCmdtyModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface MSFCmdDetailViewModel ()

@property (nonatomic, strong) MSFCmdtyModel *model;

@end

@implementation MSFCmdDetailViewModel

- (instancetype)initWithModel:(id)model {
	self = [super init];
	if (!self) {
		return nil;
	}
	_model = model;
	_cmdtyName = @"";
	_cmdtyPrice = @"";
	_orderTime = @"";
	RAC(self, cmdtyName) = [RACObserve(self, model.cmdtyName) ignore:nil];
	RAC(self, cmdtyPrice) = [RACObserve(self, model.cmdtyPrice) ignore:nil];
	RAC(self, orderTime) = [RACObserve(self, model.orderTime) ignore:nil];
	
	return self;
}

@end
