//
// MSFApplicationViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSFViewModelServices.h"

@class MSFFormsViewModel;
@class MSFLoanType;

// 贷款申请
@protocol MSFApplicationViewModel <NSObject>

// 申请API调用服务
@property (nonatomic, weak) id <MSFViewModelServices> services;

// 申请订单号，社保贷默认申请流程中申请订单号为空字符串
@property (nonatomic, strong) NSString *applicationNo;

// 申请表中，用户基本信息/职业信息/联系人信息
@property (nonatomic, strong) MSFFormsViewModel *formViewModel;

// 申请的产品类型: 社保贷/马上贷款/随借随还
@property (nonatomic, strong) MSFLoanType *loanType;

// 附件列表 <NSDictionary>
@property (nonatomic, strong) NSArray *accessories;

@end
