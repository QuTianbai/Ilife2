//
//	MSFPersonalViewModel.m
//	Cash
//
//	Created by xutian on 15/6/13.
//	Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFRelationshipViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <UIKit/UIKit.h>
#import "MSFAddress.h"
#import "MSFAddressViewModel.h"
#import "MSFApplicationForms.h"
#import "MSFFormsViewModel.h"
#import "MSFClient+MSFApplyCash.h"
#import "NSString+Matches.h"
#import "MSFSelectionViewModel.h"
#import "MSFSelectKeyValues.h"

@implementation MSFRelationshipViewModel

- (instancetype)initWithFormsViewModel:(MSFFormsViewModel *)viewModel {
	self = [super init];
	if (!self) {
		return nil;
	}
	_formsViewModel = viewModel;
	_services = viewModel.services;
	MSFApplicationForms *forms = viewModel.model;
	if (forms.abodeDetail.length > 0) {
		NSDictionary *addr = @{@"province" : forms.currentProvinceCode ?: @"",
													 @"city" : forms.currentCityCode ?: @"",
													 @"area" : forms.currentCountryCode ?: @""};
		MSFAddress *addrModel = [MSFAddress modelWithDictionary:addr error:nil];
		MSFAddressViewModel *addrViewModel = [[MSFAddressViewModel alloc] initWithAddress:addrModel services:_services];
		_fullAddress = [NSString stringWithFormat:@"%@%@", addrViewModel.address, forms.abodeDetail];
	} else {
		_fullAddress = nil;
	}
	
	NSArray *marriageStatus = [MSFSelectKeyValues getSelectKeys:@"marital_status"];
	[marriageStatus enumerateObjectsUsingBlock:^(MSFSelectKeyValues *obj, NSUInteger idx, BOOL *stop) {
		if ([obj.code isEqualToString:self.formsViewModel.model.maritalStatus]) {
			self.formsViewModel.model.marriageTitle = obj.text;
			*stop = YES;
		}
	}];

	@weakify(self)
	_executeMarriageCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(UITableView *input) {
		@strongify(self);
		return [self marryValuesSignal];
	}];
	_executeMarriageCommand.allowsConcurrentExecution = YES;
//	_executeContactBookCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
//		
//	}];
	_executeCommitCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self commitSignal];
	}];
	return self;
}

- (RACSignal *)marryValuesSignal {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		MSFSelectionViewModel *viewModel = [MSFSelectionViewModel selectKeyValuesViewModel:[MSFSelectKeyValues getSelectKeys:@"marital_status"]];
		[self.services pushViewModel:viewModel];
		[viewModel.selectedSignal subscribeNext:^(MSFSelectKeyValues *x) {
			[subscriber sendNext:nil];
			[subscriber sendCompleted];
			self.formsViewModel.model.marriageTitle = x.text;
			self.formsViewModel.model.maritalStatus = x.code;
			[self.services popViewModel];
		}];
		return nil;
	}];
}

- (RACSignal *)commitSignal {
	NSString *error = [self checkForm];
	if (error) {
		return [RACSignal error:[NSError errorWithDomain:@"MSFRelationShipViewModel" code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: error}]];
	}
	return [self.formsViewModel submitUserInfoType:3];
}

- (RACSignal *)contactBookSignal {
	
	return nil;
}

- (NSString *)checkForm {
	if (self.formsViewModel.model.maritalStatus.length == 0) {
		return @"请选择婚姻状况";
	}
	NSArray *contactList = self.formsViewModel.model.contrastList;
	if (contactList.count < 2) {
		return [NSString stringWithFormat:@"请至少填写联系人1、2的信息"];
	}
	for (int i = 0; i < contactList.count; i ++) {
		MSFUserContact *contact = contactList[i];
		if (contact.contactRelation.length == 0) {
			return [NSString stringWithFormat:@"请选择联系人%d和你的关系", i + 1];
		}
		if (contact.contactName.length == 0) {
			return [NSString stringWithFormat:@"请填写联系人%d姓名", i + 1];
		}
		if (![contact.contactName isChineseName]) {
			return [NSString stringWithFormat:@"请填写正确的联系人%d姓名", i + 1];
		}
		if (![contact.contactMobile isMobile]) {
			return [NSString stringWithFormat:@"请填写正确的联系人%d手机号码", i + 1];
		}
		if (!contact.isFamily) {
			if (contact.contactAddress.length > 0 && (contact.contactAddress.length < 8 || contact.contactAddress.length > 60)) {
				return [NSString stringWithFormat:@"请填写长度8~60的联系人%d联系地址", i + 1];
			}
		} else {
			if (contact.contactAddress.length < 8 || contact.contactAddress.length > 60) {
				return [NSString stringWithFormat:@"请填写长度8~60的联系人%d联系地址", i + 1];
			}
		}
		for (int j = 0; j < contactList.count; j++) {
			if (i == j) {
				continue;
			}
			MSFUserContact *contractJ = contactList[j];
			if ([contractJ.contactName isEqualToString:contact.contactName] || [contractJ.contactMobile isEqualToString:contact.contactMobile]) {
				return @"联系人的姓名或者手机号不能相同";
			}
		}
	}
	return nil;
}

- (BOOL)marriageStatusChange:(NSString *)newStatus {
	if (![self.formsViewModel.model.maritalStatus isEqualToString:newStatus]) {
		if ([self.formsViewModel.model.maritalStatus isEqualToString:@"20"]) {
			return YES;
		} else if ([newStatus isEqualToString:@"20"]) {
			return YES;
		}
	}
	return NO;
}

@end