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
#import "MSFTrial.h"
#import "MSFMarkets.h"
#import "MSFTeams2.h"
#import "MSFTeam.h"
#import "MSFLoanType.h"
#import "MSFLifeInsuranceViewModel.h"

@interface MSFCartViewModel ()

@property (nonatomic, copy) NSString *totalAmt;
@property (nonatomic, strong, readwrite) MSFCart *cart;
@property (nonatomic, strong, readwrite) NSArray *terms;
@property (nonatomic, strong) MSFTrial *trial;

@end

@implementation MSFCartViewModel

- (instancetype)initWithCartId:(NSString *)cartId
											services:(id<MSFViewModelServices>)services {
	self = [super init];
	if (self) {
		_services = services;
		_loanType = [[MSFLoanType alloc] initWithTypeID:@"3101"];
		_trial = [[MSFTrial alloc] init];
	
		RAC(self, totalAmt) = RACObserve(self, cart.totalAmt);
		RAC(self, commodities) = RACObserve(self, cart.cmdtyList);
		RAC(self, trialAmt) = RACObserve(self, trial.loanFixedAmt);
		RAC(self, insurance) = RACObserve(self, trial.lifeInsuranceAmt);
		RACChannelTerminal *downPmt = RACChannelTo(self, downPmtAmt);
		RACChannelTerminal *loanAmt = RACChannelTo(self, loanAmt);
		[[downPmt map:^id(NSString *value) {
			double loan = self.totalAmt.doubleValue - value.doubleValue;
			return [NSString stringWithFormat:@"%.2f", loan];
		}] subscribe:loanAmt];
		_downPmtAmt = @"0";
		_joinInsurance = NO;
		
		@weakify(self)
		_executeInsuranceCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
			@strongify(self)
			return [self insuranceSignal];
		}];
		RACCommand *trialCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
			return [self.services.httpClient fetchTrialAmount:self];
		}];
		trialCommand.allowsConcurrentExecution = YES;
		[trialCommand.executionSignals.switchToLatest subscribeNext:^(MSFTrial *x) {
			self.trial = x;
		}];
		[trialCommand.errors subscribeNext:^(id x) {
			NSLog(@"试算失败");
		}];
		[[RACSignal combineLatest:@[RACObserve(self, term), RACObserve(self, loanAmt), RACObserve(self, joinInsurance)]] subscribeNext:^(id x) {
			[trialCommand execute:nil];
		}];
		[[self.services.httpClient fetchCart:cartId] subscribeNext:^(MSFCart *x) {
			@strongify(self)
			self.cart = x;
		}];
		[self handleMarkets:nil];
/*
		[[self.services.httpClient fetchCheckEmploeeWithProductCode:@"3101"] subscribeNext:^(MSFMarkets *x) {
			@strongify(self)
			[self handleMarkets:x];
		}];*/
	}
	return self;
}

- (void)handleMarkets:(MSFMarkets *)markets {
	
	self.terms = @[@"3", @"6", @"9", @"12"];
	self.term = self.terms[0];
	return;
	
	__block NSArray *terms = nil;
	[markets.teams enumerateObjectsUsingBlock:^(MSFTeams2 *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
		NSMutableArray *temp = NSMutableArray.array;
		[obj.team enumerateObjectsUsingBlock:^(MSFTeam *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
			[temp addObject:obj.loanTeam];
		}];
		terms = [NSArray arrayWithArray:terms];
	}];
	[terms sortedArrayUsingComparator:^NSComparisonResult(NSString *_Nonnull obj1, NSString *_Nonnull obj2) {
		if (obj1.integerValue < obj2.integerValue) {
			return NSOrderedAscending;
		} else if (obj1.integerValue > obj2.integerValue) {
			return NSOrderedDescending;
		}
		return NSOrderedSame;
	}];
	self.terms = terms;
	if (self.terms.count > 0) {
		self.term = self.terms[0];
	}
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

#pragma mark - Signals

- (RACSignal *)insuranceSignal {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		MSFLifeInsuranceViewModel *viewModel = [[MSFLifeInsuranceViewModel alloc] initWithServices:self.services loanType:self.loanType];
		[self.services pushViewModel:viewModel];
		[subscriber sendCompleted];
		return nil;
	}];
}

//- (RACSignal *)validSignal {
//	return [RACSignal combineLatest:@[RACObserve(self, loanAmt), RACObserve(self, term), RACObserve(self, commodities)] reduce:^id(NSString *x1, NSString *x2, NSArray *x3) {
//		return @(x1.doubleValue > 0 && x2.integerValue > 0 && x3.count > 0);
//	}];
//}

@end
