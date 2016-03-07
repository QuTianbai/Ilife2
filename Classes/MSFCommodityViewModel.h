//
//  MSFCommodityViewModel.h
//  Finance
//
//  Created by xbm on 16/3/7.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>
#import "MSFViewModelServices.h"

@class RACCommand;

@interface MSFCommodityViewModel : RVMViewModel

@property (nonatomic, strong, readonly) NSArray *photos;

- (instancetype)initWithServices:(id <MSFViewModelServices>)services;

@end
