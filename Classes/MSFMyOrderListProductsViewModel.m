//
//  MSFMyOrderListProductsViewModel.m
//  Finance
//
//  Created by xbm on 16/3/4.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFMyOrderListProductsViewModel.h"

@interface MSFMyOrderListProductsViewModel ()

@property (nonatomic, assign) id<MSFViewModelServices> services;
@property (nonatomic, copy) NSString *appNo;

@end

@implementation MSFMyOrderListProductsViewModel

- (instancetype)initWithServices:(id)services appNo:(NSString *)appNo {
	self = [super init];
	if (!self) {
		return nil;
	}
	_services = services;
	_appNo = appNo;
	return self;
}

@end
