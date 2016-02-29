//
//  MSFMyRepaysViewModel.h
//  Finance
//
//  Created by xbm on 16/2/29.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>
#import "MSFViewModelServices.h"

@class RACCommand;

@interface MSFMyRepaysViewModel : RVMViewModel

@property (nonatomic, weak, readonly) id <MSFViewModelServices> services;
@property (nonatomic, strong, readonly) NSArray *viewModels;
@property (nonatomic, strong, readonly) NSString *identifer;

@property (nonatomic, strong) RACCommand *executeFetchCommand;

- (instancetype)initWithservices:(id <MSFViewModelServices>)services;

@end
