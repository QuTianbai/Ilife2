//
//  MSFWalletRepayViewModel.m
//  Finance
//
//  Created by Wyc on 16/3/17.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFWalletRepayViewModel.h"
#import "MSFClient+BankCardList.h"

@interface MSFWalletRepayViewModel()

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation MSFWalletRepayViewModel

- (instancetype)initWithServices:(id<MSFViewModelServices>)servers {

    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    _services = servers;
    
    return self;
}

-(MSFRepayPlayMode *)getRepayPlayMode:(NSInteger)integer {
    return self.dataArray[integer];
    
}

-(RACSignal *)fetchRepayInformationSignal{
    return [self.services.httpClient  fetchRepayInformationSignal];
}

@end
