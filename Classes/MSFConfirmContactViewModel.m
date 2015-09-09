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

@interface MSFConfirmContactViewModel ()
{
	 id<MSFViewModelServices> _servers;
}

@property (nonatomic, strong) NSArray *contactsArray;
@property (nonatomic, strong) id<MSFViewModelServices> servers;
@property (nonatomic, strong) MSFContactListModel *model;

@end

@implementation MSFConfirmContactViewModel

- (id)initWithServers:(id<MSFViewModelServices>)servers {
	if (self = [super init]) {
		
	}
	_servers = servers;
	_laterConfirmCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return [self executeLaterConfirmContract];

	}];
	//_laterConfirmCommand.allowsConcurrentExecution = YES;
	_confirmCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		[[NSNotificationCenter defaultCenter] postNotificationName:MSFCONFIRMCONTACTIONLATERNOTIFICATION object:nil];
		//[self executeLaterConfirmContract];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"MSFREQUESTCONTRACTSNOTIFACATIONSHOWBT" object:nil];
		return [self executeConfirmContract];
	}];
	
	_requestConfirmCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return [self executeSubmitConfirmContract];
	}];


	@weakify(self)
	[[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"HOMEPAGECONFIRMCONTRACT" object:nil] subscribeNext:^(id x) {
		NSLog(@"我是收通知");
		@strongify(self)
		[self.confirmCommand execute:nil];
		//[[self executeConfirmContract] replayLast];
	}];
	
	[self fetchContractist];
		
	return self;
}

- (void)fetchContractist {
	@weakify(self)
	[[[self.servers.httpClient fetchContacts].collect replayLazily] subscribeNext:^(id x) {
		[SVProgressHUD dismiss];
		@strongify(self)
		self.contactsArray = x;
		for (MSFContactListModel *model in self.contactsArray) {
			if ([model.contractStatus isEqualToString:@"WN"]) {
			self.model = model;
			[[NSNotificationCenter defaultCenter] postNotificationName:MSFCONFIRMCONTACTNOTIFACATION object:nil];
			break;
			}
		}
	} error:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
		//NSLog(@"%@", error);
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

- (RACSignal *)requestContactInfo {
	return [[[self.servers.httpClient fetchContactsInfoWithID:self.model.contactID] flattenMap:^RACStream *(id value) {
		NSLog(@"request:%@", value);
		return [[NSURLConnection rac_sendAsynchronousRequest:value] reduceEach:^id(NSURLResponse *response, NSData *data){
			return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		}];
	}] replayLast];
	
	
}

- (RACSignal *)executeSubmitConfirmContract {
	return [self.servers.httpClient fetchConfirmContractWithContractID:self.model.contactID];
}

@end
