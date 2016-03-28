//
//  MSFAuthorizationViewModel.m
//  Finance
//
//  Created by administrator on 16/3/28.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFAuthorizationViewModel.h"

@interface MSFAuthorizationViewModel()

@property (nonatomic, weak, readonly) id <MSFViewModelServices> services;

@end

@implementation MSFAuthorizationViewModel

- (instancetype)initWithModel:(id)model Services:(id<MSFViewModelServices>)services {
    if (self = [super init]) {
        _services = services;
        _applicationViewModel = model;
    }
    return self;
}

@end
