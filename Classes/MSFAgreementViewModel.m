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
#import "MSFServer.h"

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

- (instancetype)initWithServices:(id <MSFViewModelServices>)services model:(MSFAgreement *)agreement {
	self = [super init];
	if (!self) {
		return nil;
	}
	_services = services;
	_agreement = agreement;
	
	return self;
}

- (RACSignal *)registerAgreementSignal {
	MSFClient *client = [[MSFClient alloc] initWithServer:MSFServer.dotComServer];
	return [[client
		fetchRegisterURL]
		flattenMap:^RACStream *(id value) {
			return [[NSURLConnection rac_sendAsynchronousRequest:value]
				reduceEach:^id(NSURLResponse *response, NSData *data){
					return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
				}];
		}];
}

- (RACSignal *)aboutAgreementSignal {
	MSFClient *client = [[MSFClient alloc] initWithServer:MSFServer.dotComServer];
	return [[client
		fetchAgreementURLWithType:@"ABOUT_US"]
		flattenMap:^RACStream *(id value) {
			return [[NSURLConnection rac_sendAsynchronousRequest:value]
				reduceEach:^id(NSURLResponse *response, NSData *data){
					return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
				}];
		}];
}

- (RACSignal *)productAgreementSignal {
	MSFClient *client = [[MSFClient alloc] initWithServer:MSFServer.dotComServer];
	return [[client
		fetchAgreementURLWithType:@"PRODUCTION_INTRODUCTION"]
		flattenMap:^RACStream *(id value) {
			return [[NSURLConnection rac_sendAsynchronousRequest:value]
				reduceEach:^id(NSURLResponse *response, NSData *data){
					return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
				}];
		}];
}

- (RACSignal *)usersAgreementSignal {
	MSFClient *client = [[MSFClient alloc] initWithServer:MSFServer.dotComServer];
	return [[client
		fetchAgreementURLWithType:@"USER_HELP"]
		flattenMap:^RACStream *(id value) {
			return [[NSURLConnection rac_sendAsynchronousRequest:value]
				reduceEach:^id(NSURLResponse *response, NSData *data){
					return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
				}];
		}];
}

- (RACSignal *)branchAgreementSignal {
	MSFClient *client = [[MSFClient alloc] initWithServer:MSFServer.dotComServer];
	return [[client
		fetchAgreementURLWithType:@"STORE_BRANCH"]
		flattenMap:^RACStream *(id value) {
			return [[NSURLConnection rac_sendAsynchronousRequest:value]
				reduceEach:^id(NSURLResponse *response, NSData *data){
					return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
				}];
		}];
}

- (RACSignal *)loanAgreementSignal {
	NSURLRequest *request = [NSURLRequest requestWithURL:_agreement.loanURL];
	
	return [[NSURLConnection rac_sendAsynchronousRequest:request]
		reduceEach:^id(NSURLResponse *response, NSData *data){
			return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		}];
}

- (RACSignal *)loanAgreementSignalWithViewModel:(MSFApplyCashVIewModel *)product {
	return [[self.services.httpClient
		fetchAgreementURLWithProduct:product]
		flattenMap:^RACStream *(id value) {
			return [[NSURLConnection rac_sendAsynchronousRequest:value]
				reduceEach:^id(NSURLResponse *response, NSData *data){
					return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
				}];
		}];
}

@end
