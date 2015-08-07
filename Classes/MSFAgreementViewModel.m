//
// MSFAgreementViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFAgreementViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFAgreement.h"
#import "MSFClient+Agreements.h"
#import "NSURLRequest+RequestWithIgnoreSSL.h"

@interface MSFAgreementViewModel ()

@property (nonatomic, weak) id <MSFViewModelServices> services;

@end

@implementation MSFAgreementViewModel

- (instancetype)initWithModel:(MSFAgreement *)agreement {
	self = [super init];
	if (!self) {
		return nil;
	}
	_agreement = agreement;
	
	return self;
}

- (instancetype)initWithServices:(id <MSFViewModelServices>)services {
	self = [super init];
	if (!self) {
		return nil;
	}
	_services = services;
	
	return self;
}

- (RACSignal *)registerAgreementSignal {
	NSURLRequest *request = [NSURLRequest requestWithURL:_agreement.registerURL];
	
	return [[NSURLConnection rac_sendAsynchronousRequest:request]
		reduceEach:^id(NSURLResponse *resposne, NSData *data){
			return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		}];
}

- (RACSignal *)aboutAgreementSignal {
	NSURLRequest *request = [NSURLRequest requestWithURL:_agreement.aboutWeURL];
	
	return [[NSURLConnection rac_sendAsynchronousRequest:request]
		reduceEach:^id(NSURLResponse *resposne, NSData *data){
			return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		}];
}

- (RACSignal *)productAgreementSignal {
	NSURLRequest *request = [NSURLRequest requestWithURL:_agreement.productURL];
	
	return [[NSURLConnection rac_sendAsynchronousRequest:request]
		reduceEach:^id(NSURLResponse *resposne, NSData *data){
			return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		}];
}

- (RACSignal *)usersAgreementSignal {
	NSURLRequest *request = [NSURLRequest requestWithURL:_agreement.helpURL];
	
	return [[NSURLConnection rac_sendAsynchronousRequest:request]
		reduceEach:^id(NSURLResponse *resposne, NSData *data){
			return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		}];
}

- (RACSignal *)branchAgreementSignal {
	NSURLRequest *request = [NSURLRequest requestWithURL:_agreement.branchesURL];
	
	return [[NSURLConnection rac_sendAsynchronousRequest:request]
		reduceEach:^id(NSURLResponse *resposne, NSData *data){
			return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		}];
}

- (RACSignal *)loanAgreementSignal {
	NSURLRequest *request = [NSURLRequest requestWithURL:_agreement.loanURL];
	
	return [[NSURLConnection rac_sendAsynchronousRequest:request]
		reduceEach:^id(NSURLResponse *response, NSData *data){
			return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		}];
}

- (RACSignal *)repayAgreementSignal {
	NSURLRequest *request = [NSURLRequest requestWithURL:_agreement.repayURL];
	
	return [[NSURLConnection rac_sendAsynchronousRequest:request]
		reduceEach:^id(NSURLResponse *response, NSData *data){
				return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		}];
}

- (RACSignal *)loanAgreementSignalWithProduct:(MSFProduct *)product {
	return [[self.services.httpClient
		fetchAgreementURLWithProduct:product]
		flattenMap:^RACStream *(id value) {
			NSURLRequest *request = [NSURLRequest requestWithURL:value];
			return [[NSURLConnection rac_sendAsynchronousRequest:request]
				reduceEach:^id(NSURLResponse *response, NSData *data){
					return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
				}];
		}];
}

@end
