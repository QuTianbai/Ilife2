//
//  MSFConfirmContactViewModel.m
//  Finance
//
//  Created by xbm on 15/9/2.
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFConfirmContactViewModel.h"
#import "MSFContactListModel.h"
#import "MSFClient+Contacts.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFCustomAlertView.h"
#import "MSFClient+ConfirmContract.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "MSFCirculateCashModel.h"
#import "MSFClient+MSFCirculateCash.h"
#import "MSFUser.h"

static NSString *kSocialInsuranceLoanTemplate = @"4102";

@interface MSFConfirmContactViewModel ()

@property (nonatomic, strong) NSArray *contactsArray;
@property (nonatomic, strong) MSFContactListModel *model;

@end

@implementation MSFConfirmContactViewModel

- (id)initWithServers:(id<MSFViewModelServices>)servers {
	if (!(self = [super init])) {
		return nil;
	}
	_servers = servers;
	_laterConfirmCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return [self executeLaterConfirmContract];

	}];
	_confirmCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		[[NSNotificationCenter defaultCenter] postNotificationName:MSFCONFIRMCONTACTIONLATERNOTIFICATION object:nil];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"MSFREQUESTCONTRACTSNOTIFACATIONSHOWBT" object:nil];
		return [self executeConfirmContract];
	}];
	
	_requestConfirmCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return [self executeSubmitConfirmContract:input];
	}];

	@weakify(self)
	[[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"HOMEPAGECONFIRMCONTRACT" object:nil] subscribeNext:^(id x) {
		NSLog(@"接收确认合同通知");
		@strongify(self)
		[self.confirmCommand execute:nil];
	}];
	
	[self fetchContractist];
		
	return self;
}

- (RACSignal *)requestContactInfo {
	return RACSignal.empty;
}

- (void)fetchContractist {
	@weakify(self)
	[[self.servers.httpClient fetchCirculateCash:nil] subscribeNext:^(MSFCirculateCashModel *model) {
		@strongify(self)
		if (([model.type isEqualToString:@"APPLY"] && [model.applyStatus isEqualToString:@"I"]) || (![model.type isEqualToString:@"APPLY"] && [model.contractStatus isEqualToString:@"I"])) {
			[[NSNotificationCenter defaultCenter] postNotificationName:MSFCONFIRMCONTACTNOTIFACATION object:nil];
			self.circulateModel = model;
		}
	} error:^(NSError *error) {
		NSLog(@"%@", error.localizedDescription);
	}];
}

- (RACSignal *)executeLaterConfirmContract {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		[[NSNotificationCenter defaultCenter] postNotificationName:@"MSFREQUESTCONTRACTSNOTIFACATIONSHOWBT" object:nil];
		[[NSNotificationCenter defaultCenter] postNotificationName:MSFCONFIRMCONTACTIONLATERNOTIFICATION object:nil];
		[subscriber sendCompleted];
		return nil;
	}];
}

- (RACSignal *)executeConfirmContract {
	@weakify(self)
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		@strongify(self)
		[self.servers pushViewModel:self];
		[subscriber sendCompleted];
		return [RACDisposable disposableWithBlock:^{
			
		}];
	}];
}

- (RACSignal *)requestContactWithTemplate:(NSString *)templateType productType:(NSString *)productType {
	return [[[self.servers.httpClient fetchContactsInfoWithAppNO:self.circulateModel.applyNo AndProductNO:productType AndtemplateType:templateType] flattenMap:^RACStream *(id value) {
		return [[NSURLConnection rac_sendAsynchronousRequest:value] reduceEach:^id(NSURLResponse *response, NSData *data){
			return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		}];
	}] replayLast];
}

- (RACSignal *)requestContactInfo:(NSString *)type {
	return [[[self.servers.httpClient fetchContactsInfoWithAppNO:self.circulateModel.applyNo AndProductNO:self.circulateModel.productType AndtemplateType:type] flattenMap:^RACStream *(id value) {
		return [[NSURLConnection rac_sendAsynchronousRequest:value] reduceEach:^id(NSURLResponse *response, NSData *data){
			return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		}];
	}] replayLast];
}

- (RACSignal *)executeSubmitConfirmContract:(NSString *)type {
	return [self.servers.httpClient fetchConfirmContractWithAppNO:self.circulateModel.applyNo AndProductNO:self.circulateModel.productType AndtemplateType:type];
}

@end
