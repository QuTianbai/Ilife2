//
//  MSFLifeInsuranceViewModel.h
//  Finance
//
//  Created by xbm on 15/10/13.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "RVMViewModel.h"
#import "MSFViewModelServices.h"

@class RACCommand;

@interface MSFLifeInsuranceViewModel : RVMViewModel

@property (nonatomic, strong, readonly) RACCommand *executeRequest;

- (instancetype)initWithServices:(id<MSFViewModelServices>) services;

@end
