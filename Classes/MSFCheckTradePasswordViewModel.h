//
//  MSFCheckHasTradePassword.h
//  Finance
//
//  Created by xbm on 15/9/30.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "RVMViewModel.h"
#import "MSFViewModelServices.h"

@class RACCommand;

@interface MSFCheckTradePasswordViewModel : RVMViewModel

@property (nonatomic, copy) NSString *hasTradePassword;

@property (nonatomic, strong) RACCommand *executeChenkTradePassword;

- (instancetype)initWithServices:(id<MSFViewModelServices>)services;

@end
