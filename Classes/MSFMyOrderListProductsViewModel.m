//
//  MSFMyOrderListProductsViewModel.m
//  Finance
//
//  Created by xbm on 16/3/4.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFMyOrderListProductsViewModel.h"
#import <objc/runtime.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFOrderDetail.h"
#import "MSFClient+Order.h"
#import "MSFMyOrderCmdViewModel.h"
#import "MSFMyOrderDetailTravelViewModel.h"
#import "MSFCompanInfoListViewModel.h"

@interface MSFMyOrderListProductsViewModel ()

@property (nonatomic, assign) id<MSFViewModelServices> services;
@property (nonatomic, copy) NSString *appNo;
@property (nonatomic, strong) MSFOrderDetail *model;

@end

@implementation MSFMyOrderListProductsViewModel

- (instancetype)initWithServices:(id)services appNo:(NSString *)appNo {
	self = [super init];
	if (!self) {
		return nil;
	}
	unsigned int propertyCount = 0;
	objc_property_t *properties = class_copyPropertyList([self class], &propertyCount);
	for (unsigned int i = 0; i < propertyCount; i ++ ) {
		objc_property_t property = properties[i];
		const char *name = property_getName(property);
		const char *attributes = property_getAttributes(property);
		NSString *key = [NSString stringWithUTF8String:name];
		NSString *type = [NSString stringWithUTF8String:attributes];
		if ([type rangeOfString:@"NSString"].location != NSNotFound ) {
			[self setValue:@"" forKey:key];
		}
	}
	_services = services;
	_appNo = appNo;
	@weakify(self)
	[self.didBecomeActiveSignal subscribeNext:^(id x) {
		@strongify(self)
		[[self.services.httpClient fetchMyOrderProductWithInOrderId:self.inOrderId appNo:self.appNo]
		subscribeNext:^(id x) {
			self.model = x;
		} error:^(NSError *error) {
			NSLog(@"error:%@", error);
		}];
	}];
	
	RAC(self, custName) = [RACObserve(self, model.custName) ignore:nil];
	RAC(self, cellphone) = [[RACObserve(self, model.cellphone) ignore:nil] map:^id(NSString *value) {
		NSString *str = [value stringByReplacingOccurrencesOfString:[value substringWithRange:NSMakeRange(3, 4)] withString:@"****"];
		return [NSString stringWithFormat:@"手机号：%@", str];
	}];
	RAC(self, contractId) = [RACObserve(self, model.contractId) ignore:nil];
	RAC(self, orderStatus) = [RACObserve(self, model.orderStatus) ignore:nil];
	RAC(self, cmdtyList) = [[RACObserve(self, model.cmdtyList) ignore:nil] map:^id(NSArray *value) {
		NSMutableArray *resutArray = [[NSMutableArray alloc] init];
		for (NSObject *model in value) {
			MSFMyOrderCmdViewModel *viewModel = [[MSFMyOrderCmdViewModel alloc] initWithModel:model];
			[resutArray addObject:viewModel];
		}
		return [NSArray arrayWithArray:resutArray];
	}];
	RAC(self, downPmt) = [[RACObserve(self, model.downPmt) ignore:nil] map:^id(id value) {
		return [NSString stringWithFormat:@"首付：¥%@", value];
	}];
	RAC(self, months) = [[RACObserve(self, model) ignore:nil] map:^id(MSFOrderDetail *value) {
		return [NSString stringWithFormat:@"¥%@×%@期", value.mthlyPmtAmt, value.loanTerm];
	}];
	RAC(self, loanAmt) = [[RACObserve(self, model.loanAmt) ignore:nil] map:^id(id value) {
		return [NSString stringWithFormat:@"贷款金额：%@", value];
	}];
	
	return self;
}

@end
