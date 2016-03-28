//
//  MSFSaveCreditViewModel.m
//  Finance
//
//  Created by administrator on 16/3/28.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFSaveCreditViewModel.h"
#import "MSFApplicationViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFAuthorizationViewModel.h"

@interface MSFSaveCreditViewModel()

@property (nonatomic, weak, readonly) id <MSFViewModelServices> services;

@end

@implementation MSFSaveCreditViewModel

- (instancetype)initWithModel:(id)model Services:(id)services {
    if (self = [super init]) {
        _applicationViewModel = model;
        _services = services;
        _selectCreditChannelCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIButton *input) {
            MSFAuthorizationViewModel *authoViewModel = [[MSFAuthorizationViewModel alloc] initWithModel:model Services:services];
            authoViewModel.channel = input.tag - 100;
            [self.services pushViewModel:authoViewModel];
            return [RACSignal empty];
        }];
    }
    return self;
}

@end
