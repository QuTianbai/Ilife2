//
//  MSFCartViewModel.m
//  Finance
//
//  Created by 赵勇 on 12/23/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFCartViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFClient+MSFCheckEmploee2.h"
#import "MSFClient+MSFCart.h"
#import "MSFCart.h"

@interface MSFCartViewModel ()

@property (nonatomic, assign) double totalAmt;

@end

@implementation MSFCartViewModel

- (instancetype)initWithCartId:(NSString *)cartId
											services:(id<MSFViewModelServices>)services {
	self = [super init];
	if (self) {
		_services = services;
		
		RACSignal *cartSignal = [self.services.httpClient fetchCart:cartId];
		//RACSignal *termSignal = [self.services.httpClient fetchCheckEmploeeWithProductCode:<#(NSString *)#>]
		
		_downPmtAmt = @"1000"; // 首付金额
		_loanAmt = @"3000"; // 分期总金额
		_loanTerms = @[@{@"price" : @"446",
										 @"term" : @"3"},
									 @{@"price" : @"232",
										 @"term" : @"6"}];
		_joinInsurance = NO; // 是否加入寿险计划
		_insurance = @"10.00";
		_trialAmt = @"1312.32";
		_commodities = @[@{@"cate1" : @"电器",
											 @"cate2" : @"电视",
											 @"shop" : @"加上家",
											 @"name" : @"海尔",
											 @"price" : @"2000",
											 @"num" : @"1"},
										 @{@"cate1" : @"电器",
											 @"cate2" : @"空调",
											 @"shop" : @"加上家",
											 @"name" : @"格力",
											 @"price" : @"2000",
											 @"num" : @"1"}];
		
		_totalAmt = _downPmtAmt.doubleValue + _loanAmt.doubleValue;
		
		RACChannelTerminal *downPmt = RACChannelTo(self, downPmtAmt);
		RACChannelTerminal *loanAmt = RACChannelTo(self, loanAmt);
		[[downPmt map:^id(NSString *value) {
			double loan = self.totalAmt - value.doubleValue;
			return [NSString stringWithFormat:@"%.2f", loan];
		}] subscribe:loanAmt];
		
		RACSignal *orderValidSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
			//BOOL valid = self.cart.loanAmt && self.order.loanTerm && self.order.crProdId && self.commodities;
			[subscriber sendNext:@(YES)];
			[subscriber sendCompleted];
			return [RACDisposable disposableWithBlock:^{}];
		}];
		RACCommand *trialCommand = [[RACCommand alloc] initWithEnabled:orderValidSignal signalBlock:^RACSignal *(id input) {
			return [self.services.httpClient fetchTrialAmount:self.cart];
		}];
		[trialCommand.executionSignals.switchToLatest subscribeNext:^(NSDictionary *x) {
			_trialAmt = x[@"loanFixedAmt"];
			_insurance = x[@"lifeInsuranceAmt"];
		}];
		[trialCommand.errors subscribeNext:^(id x) {
			NSLog(@"试算失败");
		}];
		[RACObserve(self, term) subscribeNext:^(id x) {
			[trialCommand execute:nil];
		}];
		[RACObserve(self, downPmtAmt) subscribeNext:^(id x) {
			[trialCommand execute:nil];
		}];
	}
	return self;
}

- (NSString *)reuseIdentifierForCellAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == self.commodities.count) {
		switch (indexPath.row) {
			case 0: return @"MSFCartInputCell";
			case 1: return @"MSFCartContentCell";
			case 2: return @"MSFCartLoanTermCell";
			case 3: return @"MSFCartSwitchCell";
			case 4: return @"MSFCartTrialCell";
		}
	} else {
		if (indexPath.row == 0) {
			return @"MSFCartCategoryCell";
		}
		return @"MSFCartContentCell";
	}
	return nil;
}

@end
