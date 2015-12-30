//
//  MSFClient+MSFCart.m
//  Finance
//
//  Created by 赵勇 on 12/25/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFClient+MSFCart.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "RACSignal+MSFClientAdditions.h"
#import "MSFCartViewModel.h"
#import "MSFCart.h"
#import "MSFTrial.h"
#import "MSFLoanType.h"

@implementation MSFClient(MSFCart)

- (RACSignal *)fetchCart:(NSString *)appNo {
	NSURLRequest *request = [self requestWithMethod:@"GET" path:[NSString stringWithFormat:@"orders/product/%@", appNo] parameters:nil];
	return [self enqueueRequest:request resultClass:MSFCart.class].msf_parsedResults;
}

- (RACSignal *)fetchTrialAmount:(MSFCartViewModel *)viewModel {
	NSDictionary *params = [self trialParamsFromViewModel:viewModel];
	if (!params) {
		MSFTrial *trial = [[MSFTrial alloc] init];
		trial.loanFixedAmt = @"0";
		trial.lifeInsuranceAmt = @"0";
		return [RACSignal return:trial];
	}
	NSURLRequest *request = [self requestWithMethod:@"POST" path:@"product/trial" parameters:params];
	return [self enqueueRequest:request resultClass:MSFTrial.class].msf_parsedResults;
}

#pragma mark - Private

- (NSDictionary *)trialParamsFromViewModel:(MSFCartViewModel *)viewModel {
	if (viewModel.cart.cmdtyList.count == 0) {
		return nil;
	}
	NSArray *cmdtyList = [MTLJSONAdapter JSONArrayFromModels:viewModel.cart.cmdtyList];
	BOOL valid = viewModel.loanAmt.doubleValue > 0 && viewModel.term.integerValue > 0 && cmdtyList.count > 0;
	if (!valid) {
		return nil;
	}
	return @{@"appLmt" : viewModel.loanAmt,
					 @"loanTerm" : viewModel.term,
					 @"productCd" : viewModel.loanType.typeID,
					 @"jionLifeInsurance" : @(viewModel.joinInsurance),
					 @"cmdtyList" : cmdtyList};
}

@end
