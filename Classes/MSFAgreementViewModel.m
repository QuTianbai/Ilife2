//
// MSFAgreementViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFAgreementViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFAgreement.h"

@implementation MSFAgreementViewModel

- (instancetype)initWithModel:(MSFAgreement *)agreement {
	self = [super init];
	if (!self) {
		return nil;
	}
	_agreement = agreement;
	
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
	NSURLRequest *request = [NSURLRequest requestWithURL:[_agreement loanAgreementURLWithProduct:product]];
	
	return [[NSURLConnection rac_sendAsynchronousRequest:request]
		reduceEach:^id(NSURLResponse *response, NSData *data){
				return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		}];
}

@end
