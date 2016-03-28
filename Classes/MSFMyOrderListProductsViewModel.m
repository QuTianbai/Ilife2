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

#import "MSFClient+Order.h"
#import "MSFMyOrderCmdViewModel.h"
#import "MSFMyOrderDetailTravelViewModel.h"
#import "MSFCompanInfoListViewModel.h"
#import "NSDictionary+MSFKeyValue.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface MSFMyOrderListProductsViewModel ()

@property (nonatomic, copy, readwrite) NSString *isReload;

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
		[SVProgressHUD showWithStatus:@"正在加载..." maskType:SVProgressHUDMaskTypeClear];
		[[self.services.httpClient fetchMyOrderProductWithInOrderId:self.inOrderId appNo:self.appNo]
		subscribeNext:^(id x) {
			[SVProgressHUD dismiss];
			self.model = x;
			self.isReload = @"1";
		} error:^(NSError *error) {
			[SVProgressHUD dismiss];
			NSLog(@"error:%@", error);
			self.isReload = @"0";
		}];
	}];
	
	RAC(self, custName) = [RACObserve(self, model.custName) ignore:nil];
	RAC(self, cellphone) = [[RACObserve(self, model.cellphone) ignore:nil] map:^id(NSString *value) {
		NSString *str = [value stringByReplacingOccurrencesOfString:[value substringWithRange:NSMakeRange(3, 4)] withString:@"****"];
		return [NSString stringWithFormat:@"手机号：%@", str];
	}];
    RAC(self, cartType) = [RACObserve(self, model.cartType) ignore:nil];
    RAC(self, isDownPmt) = [RACObserve(self, model.isDownPmt) ignore:nil];
	RAC(self, contractId) = [RACObserve(self, model.contractId) ignore:nil];
	RAC(self, orderStatus) = [[RACObserve(self, model.orderStatus) ignore:nil] map:^id(id value) {
		return [NSDictionary statusStringForKey:value];
	}];
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
        NSString *mthlyPmtAmt = [NSString stringWithFormat:@"%.2f", value ? [value.mthlyPmtAmt floatValue] : 0.0];
		return [NSString stringWithFormat:@"¥%@×%@期", mthlyPmtAmt, value.loanTerm];
	}];
	RAC(self, loanAmt) = [[RACObserve(self, model.loanAmt) ignore:nil] map:^id(id value) {
		return [NSString stringWithFormat:@"贷款金额：%@", value];
	}];
	
	RAC(self, travelCompanInfoList) = [[RACObserve(self, model.companions) ignore:nil] map:^id(NSArray *value) {
		NSMutableArray *resutArray = [[NSMutableArray alloc] init];
		for (NSObject *model in value) {
			MSFCompanInfoListViewModel *viewModel = [[MSFCompanInfoListViewModel alloc] initWithModel:model];
			[resutArray addObject:viewModel];
		}
		return [NSArray arrayWithArray:resutArray];
	}];
	
	RAC(self, orderTravelDto) = [[RACObserve(self, model.travel) ignore:nil] map:^id(id value) {
		
		MSFMyOrderDetailTravelViewModel *viewModel = [[MSFMyOrderDetailTravelViewModel alloc] initWithModel:value];
		return viewModel;
	}];
	
	
	return self;
}

@end
