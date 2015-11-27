//
//  MSFConfirmContactViewModel.h
//  Finance
//
//  Created by xbm on 15/9/2.
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFViewModelServices.h"
#import <ReactiveViewModel/ReactiveViewModel.h>

@class RACCommand;
@class MSFCirculateCashModel;

@interface MSFConfirmContactViewModel : RVMViewModel

@property (nonatomic, copy) NSString *contactStatus;
@property (nonatomic, strong) RACCommand *laterConfirmCommand;
@property (nonatomic, strong) RACCommand *confirmCommand;
@property (nonatomic, strong) RACCommand *requestConfirmCommand;
@property (nonatomic, weak) id<MSFViewModelServices> servers;
@property (nonatomic, strong) MSFCirculateCashModel *circulateModel;

- (RACSignal *)requestContactInfo;
- (id)initWithServers:(id<MSFViewModelServices>)servers;
- (void)fetchContractist;

// 获取合同详情
//
// type -  合同模版类型
//
// Returns a signal which wil send HTML String
- (RACSignal *)requestContactInfo:(NSString *)type __deprecated;
- (RACSignal *)requestContactWithTemplate:(NSString *)templateType productType:(NSString *)productType;

@end
