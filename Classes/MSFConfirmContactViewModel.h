//
//  MSFConfirmContactViewModel.h
//  Finance
//
//  Created by xbm on 15/9/2.
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

//#import "RVMViewModel.h"
#import "MSFViewModelServices.h"
#import <ReactiveViewModel/ReactiveViewModel.h>

@class RACCommand;

@interface MSFConfirmContactViewModel : RVMViewModel

@property (nonatomic, copy) NSString *contactStatus;
@property (nonatomic, strong) RACCommand *laterConfirmCommand;
@property (nonatomic, strong) RACCommand *confirmCommand;
@property (nonatomic, strong) RACCommand *requestConfirmCommand;

- (RACSignal *)requestContactInfo;
- (id)initWithServers:(id<MSFViewModelServices>)servers;
- (void)fetchContractist;

@end
