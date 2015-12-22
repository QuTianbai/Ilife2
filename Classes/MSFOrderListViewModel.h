//
//  MSFOrderListViewModel.h
//  Finance
//
//  Created by 赵勇 on 12/22/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>
#import "MSFViewModelServices.h"

@class RACCommand;

@interface MSFOrderListViewModel : RVMViewModel

@property (nonatomic, weak, readonly) id<MSFViewModelServices>services;
@property (nonatomic, strong, readonly) NSMutableArray *orders;

@property (nonatomic, strong, readonly) RACCommand *executeRefreshCommand;
@property (nonatomic, strong, readonly) RACCommand *executeInfinityCommand;

- (instancetype)initWithServices:(id<MSFViewModelServices>)services;

@end
