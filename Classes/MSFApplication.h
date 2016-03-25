//
// MSFApplication.h
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFObject.h"

typedef NS_ENUM(NSUInteger, MSFApplicationStatus) {
	MSFApplicationNone,        // 未激活的状态
    MAFApplicationRepayed,     //已还款
    MAFApplicationHasOrderList,     //已出账
    MAFApplicationRepayedOuttime, //已逾期
    MAFApplicationRepaying,     //还款中
	MSFApplicationInReview,    // 审核中
    MSFApplicationConfirmationed, //合同已确认
	MSFApplicationConfirmation, // 等待合同确认
	MSFApplicationResubmit,    // 资料重传
	MSFApplicationRelease,     // 放款中
	MSFApplicationReleased,    // 已放款
	MSFApplicationRejected,    // 审核失败需要重新提交
	MSFApplicationActivated,   // 已激活
    MSFApplicationCancled,   // 已取消
    MSFApplicationQuite,   // 已退货
    MSFApplicationWillPay,   // 待支付
    MSFApplicationPayed,   // 已支付
    MSFApplicationPayedFirst,   // 已支付首付
};

@interface MSFApplication : MSFObject

@end
