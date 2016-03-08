//
//  MSFCreditViewModel.m
//  Finance
//
//  Created by Wyc on 16/3/7.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFCreditViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "MSFClient+Photos.h"

@interface MSFCreditViewModel ()

@property (nonatomic, weak) id <MSFViewModelServices>services;

@end

@implementation MSFCreditViewModel

- (instancetype)initWithServices:(id<MSFViewModelServices>)services {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _services = services;
    return self;
    
}

@end
