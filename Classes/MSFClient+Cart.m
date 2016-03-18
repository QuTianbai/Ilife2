//
//  MSFClient+MSFCart.m
//  Finance
//
//  Created by 赵勇 on 12/25/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFClient+Cart.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "RACSignal+MSFClientAdditions.h"
#import "MSFCartViewModel.h"
#import "MSFCart.h"
#import "MSFTrial.h"
#import "MSFLoanType.h"
#import "MSFTravel.h"

@implementation MSFClient(Cart)

- (RACSignal *)fetchCart:(NSString *)appNo {
	NSURLRequest *request = [self requestWithMethod:@"GET" path:[NSString stringWithFormat:@"orders/product/%@", appNo] parameters:nil];
	return [self enqueueRequest:request resultClass:MSFCart.class].msf_parsedResults;
}

- (RACSignal *)fetchCartInfoForCart:(MSFCart *)cart {
	NSURLRequest *request = [self requestWithMethod:@"GET" path:@"orders/shopDetail" parameters:@{@"cartId": cart.cartId?:@""}];
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
	NSData *data = [NSJSONSerialization dataWithJSONObject:cmdtyList options:NSJSONWritingPrettyPrinted error:nil];
	NSString *jsonValue = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	return @{@"appLmt" : viewModel.loanAmt,
					 @"loanTerm" : viewModel.term,
					 @"compId": viewModel.compId,
					 @"productCd" : viewModel.loanType.typeID,
					 @"jionLifeInsurance" : viewModel.joinInsurance? @"1":@"0",
					 @"cmdtyList" : jsonValue};
}

- (RACSignal *)submitTrialAmount:(MSFCartViewModel *)viewModel {
	
	NSDictionary *order = @{
		@"productCd" : viewModel.loanType.typeID?:@"",
		@"appLmt" : viewModel.loanAmt?:@"",
		@"loanTerm" : viewModel.term?:@"",
		@"compId": viewModel.compId?:@"",
	  @"jionLifeInsurance" : viewModel.joinInsurance? @"1":@"0",
		@"lifeInsuranceAmt" : viewModel.lifeInsuranceAmt?:@"",
		@"loanFixedAmt" : viewModel.loanFixedAmt?:@"",
		@"downPmtScale" : viewModel.downPmtScale?:@"",
		@"downPmtAmt" : viewModel.downPmtAmt?:@"",
		@"totalAmt" : viewModel.totalAmt?:@"",
		@"promId" : viewModel.promId?:@"",
		@"isDownPmt": [@(viewModel.isDownPmt) stringValue],
	};
	
	NSDictionary *cart = @{
		@"cartId": viewModel.cart.cartId?:@"",
		@"compId": viewModel.cart.compId?:@"",
		@"cartType": viewModel.cart.cartType?:@"",
		@"empId": viewModel.cart.empId?:@"",
		@"totalAmt": viewModel.cart.totalAmt?:@"",
		@"totalQuantity": viewModel.cart.totalQuantity?:@"",
		@"riskMarkCode": viewModel.cart.riskMarkCode?:@"",
		@"crProdId": viewModel.cart.crProdId?:@"",
		@"minDownPmt": viewModel.cart.minDownPmt?:@"",
		@"maxDownPmt": viewModel.cart.maxDownPmt?:@"",
		@"internalCode": viewModel.cart.internalCode?:@"",
		@"cmdtyList": viewModel.cart.cmdtyList ? [MTLJSONAdapter JSONArrayFromModels:viewModel.cart.cmdtyList] : NSNull.null,
		@"travelCompanInfoList": viewModel.cart.companions ? [MTLJSONAdapter JSONArrayFromModels:viewModel.cart.companions] : NSNull.null,
		@"orderTravelDto": viewModel.cart.travel ? [MTLJSONAdapter JSONDictionaryFromModel:viewModel.cart.travel] : NSNull.null,
	};
	
	NSData *orderData = [NSJSONSerialization dataWithJSONObject:order options:NSJSONWritingPrettyPrinted error:nil];
	NSString *orderValue = [[NSString alloc] initWithData:orderData encoding:NSUTF8StringEncoding];
	
	NSData *arrayData = [NSJSONSerialization dataWithJSONObject:viewModel.accessories options:NSJSONWritingPrettyPrinted error:nil];
	NSString *accesory = [[NSString alloc] initWithData:arrayData encoding:NSUTF8StringEncoding];
	
	NSData *cartData = [NSJSONSerialization dataWithJSONObject:cart options:NSJSONWritingPrettyPrinted error:nil];
	NSString *cartValue = [[NSString alloc] initWithData:cartData encoding:NSUTF8StringEncoding];
	
	NSMutableDictionary *parameters = NSMutableDictionary.dictionary;
	
	[parameters setObject:accesory forKey:@"accessoryInfoVO"];
	[parameters setObject:cartValue forKey:@"cartVO"];
	[parameters setObject:@"1" forKey:@"applyStatus"];
	[parameters setObject:orderValue forKey:@"orderVO"];
	
	NSURLRequest *request = [self requestWithMethod:@"POST" path:@"loan/createOrder" parameters:parameters];
	return [self enqueueRequest:request resultClass:MSFTrial.class].msf_parsedResults;
}

@end
