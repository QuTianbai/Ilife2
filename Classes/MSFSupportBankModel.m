//
//  MSFSupportBankModel.m
//  Finance
//
//  Created by Wyc on 16/3/16.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFSupportBankModel.h"

@implementation MSFSupportBankModel

- (instancetype)initWithServices:(id<MSFViewModelServices>)servers {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _bankCode = @"";
    _singleAmountLimit = 0;
    _dayAmountLimit = 0;
    _bankName = @"";
    _isMainCard = @"";
    _picUrl = @"";
    return self;
    
}

@end
