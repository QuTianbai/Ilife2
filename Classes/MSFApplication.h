//
// MSFApplication.h
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, MSFApplicationStatus) {
	MSFApplicationNone,        // 未激活的状态
	MSFApplicationInReview,    // 审核中
	MSFApplicationConfirmation, // 等待合同确认
	MSFApplicationResubmit,    // 资料重传
	MSFApplicationRelease,     // 放款中
	MSFApplicationReleased,    // 已放款
	MSFApplicationRejected,    // 审核失败需要重新提交
	MSFApplicationActivated,   // 已激活
};

@interface MSFApplication : NSObject

@end
