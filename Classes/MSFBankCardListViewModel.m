//
//  MSFBankCardListViewModel.m
//  Finance
//
//  Created by xbm on 15/9/29.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFBankCardListViewModel.h"
#import "MSFClient+BankCardList.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFClient+Users.h"
#import "MSFClient+BankCardList.h"
#import "MSFCheckTradePasswordViewModel.h"
#import "MSFAddBankCardTableViewController.h"
#import "MSFSupportBankListModel.h"

@interface MSFBankCardListViewModel ()

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation MSFBankCardListViewModel

- (instancetype)initWithServices:(id<MSFViewModelServices>)servers {
	self = [super init];
	if (!self) {
		return nil;
	}
	_services = servers;
	_executeSetMaster = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return [self executeSetMasterSignal];
	}];
	_executeUnbind = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return [self executeUnbindSignal];
	}];
	_checkHasTrandPasswordViewModel = [[MSFCheckTradePasswordViewModel alloc] initWithServices:self.services];
    _excuteActionCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            MSFAddBankCardViewModel *viewModel =  [[MSFAddBankCardViewModel alloc] initWithServices:self.services andIsFirstBankCard:YES];
            
            [self.services pushViewModel:viewModel];
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
            return nil;
        }];
        
    }];
    _executeSupportCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            MSFSupportBankListModel *viewModel = [[MSFSupportBankListModel alloc]initWithServices:self.services ];
            [self.services pushViewModel:viewModel];
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
            return nil;

        }];
    }];
    
	return self;
}

- (MSFBankCardInfoViewModel *)getBankCardInfoViewModel:(NSInteger)integer {
	return self.dataArray[integer];
}

- (RACSignal *)executeBankListSignal {
	return [[self.services.httpClient fetchBankCardList] collect];
}

- (RACSignal *)executeSetMasterSignal {
	return [self.services.httpClient setMasterBankCard:self.bankCardID AndTradePwd:self.pwd];
}

- (RACSignal *)executeUnbindSignal {
	return [self.services.httpClient unBindBankCard:self.bankCardID AndTradePwd:self.pwd];
}

- (RACSignal *)fetchBankCardListSignal {
	return [self.services.httpClient fetchBankCardList];
}

@end
