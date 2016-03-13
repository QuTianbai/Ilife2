//
// MSFClient+Agreements.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFClient+Agreements.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFApplyCashViewModel.h"
#import "MSFUser.h"
#import "MSFLoanType.h"
#import "MSFCartViewModel.h"
#import "MSFSocialInsuranceCashViewModel.h"

NSString *const MSFAgreementTypeRegister = @"REGISTRATION_PROTOCOL";
NSString *const MSFAgreementTypeAboutUs = @"ABOUT_US";
NSString *const MSFAgreementTypeIntro = @"PRODUCTION_INTRODUCTION";
NSString *const MSFAgreementTypeHelper = @"USER_HELP";
NSString *const MSFAgreementTypeAddresses = @"STORE_BRANCH";
NSString *const MSFAgreementTypeInsurance = @"LIFE_INSURANCE_PROTOCOL";

static NSString *const MSFClientResponseLoggingEnvironmentKey = @"LOG_API_RESPONSES";

@implementation MSFClient (Agreements)

#pragma mark - Private

- (RACSignal *)fetchLoanAgreementRequestWithProduct:(MSFApplyCashViewModel *)product {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		NSURLRequest *request = [self requestWithMethod:@"GET" path:@"treaty/loan" parameters:@{
			@"productCode": product.loanType.typeID,
			@"appLmt": product.appLmt?:@"",
			@"templateType": @"LOAN_PROTOCOL",
			@"loanTerm": product.loanTerm
		}];
		[subscriber sendNext:request];
		[subscriber sendCompleted];
		return nil;
	}];
}

- (RACSignal *)fetchLoanAgreementWithCart:(MSFCartViewModel *)product {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		NSURLRequest *request = [self requestWithMethod:@"GET" path:@"loan/treaty" parameters:@{
			@"productCode": product.loanType.typeID,
			@"appLmt": product.loanAmt?:@"",
			@"loanTerm": product.term?:@"",
		}];
		[subscriber sendNext:request];
		[subscriber sendCompleted];
		return nil;
	}];
}

- (RACSignal *)fetchUserAgreementRequestWithType:(NSString *)type {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		NSURLRequest *request = [self requestWithMethod:@"GET" path:@"treaty/static" parameters:@{
			@"templateType" :type,
		}];
		[subscriber sendNext:request];
		[subscriber sendCompleted];
		return nil;
	}];
}

#pragma mark - Public

- (RACSignal *)fetchUserAgreementWithType:(NSString *)type {
	return [[self
		fetchUserAgreementRequestWithType:type]
		flattenMap:^RACStream *(id value) {
			if (NSProcessInfo.processInfo.environment[MSFClientResponseLoggingEnvironmentKey] != nil) {
				NSLog(@"%@", [value description]);
			}
			return [[[NSURLConnection rac_sendAsynchronousRequest:value]
				reduceEach:^id(NSURLResponse *response, NSData *data){
					return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
				}]
				doError:^(NSError *error) {
					if (NSProcessInfo.processInfo.environment[MSFClientResponseLoggingEnvironmentKey] != nil) {
						NSLog(@"%@", error.description);
					}
				}];
		}];
}

- (RACSignal *)fetchLoanAgreementWithProduct:(MSFApplyCashViewModel *)product {
	return [[self
		fetchLoanAgreementRequestWithProduct:product]
		flattenMap:^RACStream *(id value) {
			return [[NSURLConnection rac_sendAsynchronousRequest:value]
				reduceEach:^id(NSURLResponse *response, NSData *data){
					return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
				}];
		}];
}

- (RACSignal *)fetchLifeLoanAgreement:(MSFSocialInsuranceCashViewModel *)product {
	NSURLRequest *request = [self requestWithMethod:@"GET" path:@"treaty/loan" parameters:@{
			@"productCode": product.loanType.typeID,
			@"appLmt": @"",
			@"templateType": @"LOAN_PROTOCOL",
			@"loanTerm":@""
		}];
	return [[NSURLConnection rac_sendAsynchronousRequest:request]
		reduceEach:^id(NSURLResponse *response, NSData *data){
			return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		}];
}

- (RACSignal *)fetchCommodityLoanAgreement:(MSFCartViewModel *)product {
	NSURLRequest *request = [self requestWithMethod:@"GET" path:@"treaty/loan" parameters:@{
			@"productCode": product.loanType.typeID,
			@"appLmt": product.loanAmt,
			@"templateType": @"LOAN_PROTOCOL",
			@"loanTerm": product.loanTerm
		}];
	return [[NSURLConnection rac_sendAsynchronousRequest:request]
		reduceEach:^id(NSURLResponse *response, NSData *data){
			return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		}];
}

@end
