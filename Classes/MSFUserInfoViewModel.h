//
//  MSFUserInfoViewModel.h
//  Finance
//
//  Created by 赵勇 on 9/29/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "RVMViewModel.h"
#import "MSFViewModelServices.h"

@interface MSFUserInfoViewModel : RVMViewModel

@property (nonatomic, weak, readonly) id<MSFViewModelServices>services;
@property (nonatomic, strong, readonly) RACSignal *contentUpdateSignal;

- (instancetype)initWithServices:(id <MSFViewModelServices>)services;

@end
