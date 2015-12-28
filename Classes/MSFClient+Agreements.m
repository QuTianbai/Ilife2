//
// MSFClient+Agreements.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFClient+Agreements.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFApplyCashVIewModel.h"
#import "MSFUser.h"
#import "MSFLoanType.h"

NSString *const MSFAgreementTypeRegister = @"REGISTRATION_PROTOCOL";
NSString *const MSFAgreementTypeAboutUs = @"ABOUT_US";
NSString *const MSFAgreementTypeIntro = @"PRODUCTION_INTRODUCTION";
NSString *const MSFAgreementTypeHelper = @"USER_HELP";
NSString *const MSFAgreementTypeAddresses = @"STORE_BRANCH";
NSString *const MSFAgreementTypeInsurance = @"LIFE_INSURANCE_PROTOCOL";

static NSString *const MSFClientResponseLoggingEnvironmentKey = @"LOG_API_RESPONSES";

@implementation MSFClient (Agreements)

#pragma mark - Private

- (RACSignal *)fetchLoanAgreementRequestWithProduct:(MSFApplyCashVIewModel *)product {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		NSURLRequest *request = [self requestWithMethod:@"GET" path:@"loan/treaty" parameters:@{
			@"productCode": product.loanType.typeID,
			@"appLmt": product.appLmt?:@"",
			@"loanTerm": product.loanTerm
		}];
		[subscriber sendNext:request];
		[subscriber sendCompleted];
		return nil;
	}];
}

- (RACSignal *)fetchUserAgreementRequestWithType:(NSString *)type {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		NSURLRequest *request = [self requestWithMethod:@"GET" path:@"loan/article" parameters:@{
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

- (RACSignal *)fetchLoanAgreementWithProduct:(MSFApplyCashVIewModel *)product {
	return [[self
		fetchLoanAgreementRequestWithProduct:product]
		flattenMap:^RACStream *(id value) {
			return [[NSURLConnection rac_sendAsynchronousRequest:value]
				reduceEach:^id(NSURLResponse *response, NSData *data){
					return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
				}];
		}];
}

- (RACSignal *)fetchLifeLoanAgreement:(NSString *)productCode {
	NSURLRequest *request = [self requestWithMethod:@"GET" path:@"loan/life" parameters:@{
		@"templateType": @"LOAN_PROTOCOL",
		@"productCode": productCode,
	}];
	return [[NSURLConnection rac_sendAsynchronousRequest:request]
		reduceEach:^id(NSURLResponse *response, NSData *data){
			return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		}];
}

- (RACSignal *)fetchCommodityLoanAgreement:(NSString *)productCode {
	//???: 缺少商品贷协议定义
	NSURLRequest *request = [self requestWithMethod:@"GET" path:@"loan/life" parameters:@{
		@"templateType": @"LOAN_PROTOCOL",
		@"productCode": productCode,
	}];
	request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://msxf.com"]];
	return [[NSURLConnection rac_sendAsynchronousRequest:request]
		reduceEach:^id(NSURLResponse *response, NSData *data){
			return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		}];
}

@end
