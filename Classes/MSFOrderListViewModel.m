//
//  MSFOrderListViewModel.m
//  Finance
//
//  Created by 赵勇 on 12/22/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFOrderListViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFClient+Order.h"
#import "MSFOrder.h"
#import "MSFOrderDetail.h"

@interface MSFOrderListViewModel ()

@property (nonatomic, strong, readwrite) NSMutableArray *orders;
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
		[_executeRefreshCommand.executionSignals.switchToLatest subscribeNext:^(MSFOrder *x) {
			@strongify(self)
			self.orders = [NSMutableArray arrayWithArray:x.orderList];
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
		[_executeInfinityCommand.executionSignals.switchToLatest subscribeNext:^(MSFOrder *x) {
			@strongify(self);
			[self.orders addObjectsFromArray:x.orderList];
			self.pn ++;
		}];
		[_executeRefreshCommand execute:nil];
	}
	return self;
}

- (NSInteger)numberOfSections {
	return self.orders.count;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
	MSFOrderDetail *order = self.orders[section];
	return order.cmdtyList.count + 2;
}

- (NSString *)identifierForCellAtIndexPath:(NSIndexPath *)indexPath {
	MSFOrderDetail *order = self.orders[indexPath.section];
	if (indexPath.row == 0) {
		return @"MSFOrderListHeaderCell";
	} else if (indexPath.row == order.cmdtyList.count + 1) {
		return @"MSFOrderListFooterCell";
	} else {
		return @"MSFOrderListItemCell";
	}
}

@end
