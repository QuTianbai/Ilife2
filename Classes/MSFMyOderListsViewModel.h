//
//  MSFMyOderListViewModel.h
//  Finance
//
//  Created by xbm on 16/3/2.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>
#import "MSFViewModelServices.h"

@class RACCommand;


@interface MSFMyOderListsViewModel : RVMViewModel

@property (nonatomic, weak, readonly) id <MSFViewModelServices> services;
@property (nonatomic, strong, readonly) NSArray *viewModels;
@property (nonatomic, copy) NSString *identifer;
@property (nonatomic, strong) RACCommand *executeFetchCommand;

- (instancetype)initWithservices:(id <MSFViewModelServices>)services;

@end
