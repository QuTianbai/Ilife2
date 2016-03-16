//
//  MSFSupportBankListModel.m
//  Finance
//
//  Created by Wyc on 16/3/15.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFSupportBankListModel.h"
#import "MSFClient+BankCardList.h"

@interface MSFSupportBankListModel ()

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation MSFSupportBankListModel

- (instancetype)initWithServices:(id<MSFViewModelServices>)servers {
    
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    _services = servers;
    return self;
}

- (RACSignal *)executeBankListSignal {
    return [[self.services.httpClient fetchSupportBankInfoNew] collect ];
}

- (MSFSupportBankModel *)getSupportBankModel:(NSInteger)integer {
    return self.dataArray[integer];
}

- (RACSignal *)fetchSupportBankSignal {
    return [self.services.httpClient fetchSupportBankInfoNew];
}

@end
