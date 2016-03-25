//
//  MSFCommodityViewModel.h
//  Finance
//
//  Created by xbm on 16/3/7.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>
#import "MSFViewModelServices.h"
#import "MSFApplication.h"

@class RACCommand;

@interface MSFCommodityViewModel : RVMViewModel

@property (nonatomic, weak) id <MSFViewModelServices> services;
@property (nonatomic, strong, readonly) NSArray *photos;
@property (nonatomic, assign, readonly) MSFApplicationStatus status;
@property (nonatomic, copy, readonly) NSString *hasList;
@property (nonatomic, copy, readonly) NSString *statusString;
@property (nonatomic, copy, readonly) NSString *buttonTitle;
@property (nonatomic, strong, readonly) NSString *groundContent;
@property (nonatomic, strong, readonly) RACCommand *excuteActionCommand;
@property (nonatomic, strong, readonly) RACCommand *executeBillsCommand;
@property (nonatomic, strong, readonly) RACCommand *executeBarCodeCommand;
@property (nonatomic, strong, readonly) RACCommand *executeCartCommand;

- (instancetype)initWithServices:(id <MSFViewModelServices>)services;

@end
