//
//  MSFOrderListViewModel.m
//  Finance
//
//  Created by 赵勇 on 12/22/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFOrderListViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFClient+MSFOrder.h"

@interface MSFOrderListViewModel ()

@property (nonatomic, strong, readwrite) NSMutableArray *orders;
//@property (nonatomic, strong) NSMutableArray *tempOrders;
@property (nonatomic, assign) NSInteger pn;

@end

@implementation MSFOrderListViewModel

- (instancetype)initWithServices:(id<MSFViewModelServices>)services {
	self = [super init];
	if (self) {
		_services = services;
		_pn = 0;
		_orders = NSMutableArray.array;
		
		@weakify(self)
		_executeRefreshCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
			@strongify(self)
			return [self.services.httpClient fetchOrderList:@"" pageNo:0];
		}];
		[_executeRefreshCommand.errors subscribeNext:^(id x) {
			@strongify(self)
			[self.orders removeAllObjects];
			self.pn = 0;
		}];
		[_executeRefreshCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
			@strongify(self)
			self.orders = [NSMutableArray arrayWithArray:x];
			self.pn = 0;
		}];
		_executeInfinityCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
			@strongify(self)
			return [self.services.httpClient fetchOrderList:@"" pageNo:self.pn + 1];
		}];
		[_executeInfinityCommand.errors subscribeNext:^(id x) {
			@strongify(self)
			[self.orders removeAllObjects];
			self.pn = 0;
		}];
		[_executeInfinityCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
			@strongify(self);
			[self.orders addObjectsFromArray:x];
			self.pn ++;
		}];
		[_executeRefreshCommand execute:nil];
	}
	return self;
}

@end
