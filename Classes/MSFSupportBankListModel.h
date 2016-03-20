//
//  MSFSupportBankListModel.h
//  Finance
//
//  Created by Wyc on 16/3/15.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>
#import "MSFViewModelServices.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFSupportBankModel.h"

@interface MSFSupportBankListModel : RVMViewModel

@property (nonatomic, weak, readonly) id <MSFViewModelServices> services;
@property (nonatomic, strong) RACCommand  *executeBankList;

- (instancetype)initWithServices:(id<MSFViewModelServices>)servers;

- (MSFSupportBankModel *)getSupportBankModel:(NSInteger)integere;
- (RACSignal *)fetchSupportBankSignal;
- (RACSignal *)executeBankListSignal;

@end
