//
//  MSFCommodityViewModel.h
//  Finance
//
//  Created by xbm on 16/3/7.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>
#import "MSFViewModelServices.h"

typedef NS_ENUM(NSUInteger, MSFCommodityStatus) {
	MSFCommodityNone,        // 没有订单
	MSFCommodityInReview,    // 审核中
	MSFCommodityConfirmation, // 等待合同确认
	MSFCommodityResubmit,    // 资料重传
	MSFCommodityRelease,     // 放款中
	MSFCommodityRejected,    // 审核失败需要重新提交
	MSFCommodityPay,   // 去支付
};

@class RACCommand;

@interface MSFCommodityViewModel : RVMViewModel

@property (nonatomic, weak) id <MSFViewModelServices> services;
@property (nonatomic, strong, readonly) NSArray *photos;
@property (nonatomic, assign, readonly) MSFCommodityStatus status;
@property (nonatomic, copy, readonly) NSString *hasList;
@property (nonatomic, copy, readonly) NSString *statusString;
@property (nonatomic, copy, readonly) NSString *buttonTitle;
@property (nonatomic, strong, readonly) RACCommand *excuteActionCommand;
@property (nonatomic, strong, readonly) RACCommand *executeBillsCommand;
@property (nonatomic, strong, readonly) RACCommand *executeBarCodeCommand;
@property (nonatomic, strong, readonly) RACCommand *executeCartCommand;

- (instancetype)initWithServices:(id <MSFViewModelServices>)services;

@end
