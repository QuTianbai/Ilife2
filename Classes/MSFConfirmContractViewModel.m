//
//  MSFConfirmContactViewModel.m
//  Finance
//
//  Created by xbm on 15/9/2.
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFConfirmContractViewModel.h"
#import "MSFContactListModel.h"
#import "MSFClient+Contacts.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFCustomAlertView.h"
#import "MSFClient+ConfirmContract.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "MSFCirculateCashModel.h"
#import "MSFClient+CirculateCash.h"
#import "MSFUser.h"
#import "MSFClient+ApplyList.h"
#import "MSFApplyList.h"

static NSString *kSocialInsuranceLoanTemplate = @"4102";

@interface MSFConfirmContractViewModel ()

@property (nonatomic, strong) NSArray *contactsArray;
@property (nonatomic, strong, readwrite) MSFApplyList *model;

@end

@implementation MSFConfirmContractViewModel

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
	
	// HOMEPAGECONFIRMCONTRACT
	// 当确认合同工按钮点击的时候弹出确认合同的webview
	// 通知内容必须指明类型: 如马上贷1101
	@weakify(self)
	[[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"HOMEPAGECONFIRMCONTRACT" object:nil] subscribeNext:^(NSNotification *notification) {
		NSLog(@"接收确认合同通知");
        [SVProgressHUD showWithStatus:@"请稍后..."];
		@strongify(self)
		[[self.servers.httpClient fetchRecentApplicaiton:notification.object] subscribeNext:^(id x) {
			self.model = x;
			[self.confirmCommand execute:nil];
		} error:^(NSError *error) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
        }];
	}];
	
	[self fetchContractist];
		
	return self;
}

- (RACSignal *)requestContactInfo {
	return RACSignal.empty;
}

- (void)fetchContractist {
	// 这个接口暂时没有发现是做什么用的
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
        [SVProgressHUD dismiss];
		[self.servers pushViewModel:self];
		[subscriber sendCompleted];
		return [RACDisposable disposableWithBlock:^{
			
		}];
	}];
}

- (RACSignal *)requestContactWithTemplate:(NSString *)templateType productType:(NSString *)productType {
	return [[[self.servers.httpClient fetchContactsInfoWithAppNO:self.model.appNo AndProductNO:productType AndtemplateType:templateType] flattenMap:^RACStream *(id value) {
		return [[NSURLConnection rac_sendAsynchronousRequest:value] reduceEach:^id(NSURLResponse *response, NSData *data){
			return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		}];
	}] replayLast];
}

- (RACSignal *)requestContactInfo:(NSString *)type {
	return [[[self.servers.httpClient fetchContactsInfoWithAppNO:self.model.appNo AndProductNO:self.model.productCd AndtemplateType:type] flattenMap:^RACStream *(id value) {
		return [[NSURLConnection rac_sendAsynchronousRequest:value] reduceEach:^id(NSURLResponse *response, NSData *data){
			return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		}];
	}] replayLast];
}

- (RACSignal *)executeSubmitConfirmContract:(NSString *)type {
	return [self.servers.httpClient fetchConfirmContractWithAppNO:self.model.appNo AndProductNO:self.model.productCd AndtemplateType:type];
}

@end
