//
//  MSFHomePageCellModel.h
//  Finance
//
//  Created by 赵勇 on 10/29/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>
#import "MSFViewModelServices.h"

typedef NS_ENUM(NSInteger, MSFHomePageDestination) {
	MSFHomePageDesApplyList,
	MSFHomePageDesRepayList,
	MSFHomePageDesContract,
	MSFHomePageDesUploadData
};

typedef NS_ENUM(NSInteger, MSFHomePageDateDisplayType) {
	MSFHomePageDateDisplayTypeNone,
	MSFHomePageDateDisplayTypeApply,
	MSFHomePageDateDisplayTypeRepay,
	MSFHomePageDateDisplayTypeOverDue,
	MSFHomePageDateDisplayTypeProcessing
};

@interface MSFHomePageCellModel : RVMViewModel

@property (nonatomic, weak) id<MSFViewModelServices>services;

//产品类型： 1101、4101、4102
@property (nonatomic, strong) NSString *productType;

/* 马上贷 */

// 标题
@property (nonatomic, strong) NSString *title;

// 申请：申请金额；合同：每月应还款额；逾期：所有未还金额
@property (nonatomic, strong) NSString *money;

// 期数
@property (nonatomic, strong) NSString *loanTerm;

// 状态描述, 状态码对应的描述（申请、合同均取用此字段）
@property (nonatomic, strong) NSString *statusString;

// 申请时间（申请单独有）
@property (nonatomic, strong) NSString *applyTime;

// 申请日期（合同独有）
@property (nonatomic, strong) NSString *applyDate;

// 当前期截止日期（合同独有）
@property (nonatomic, strong) NSString *currentPeriodDate;

// 跳转目标
@property (nonatomic, assign) MSFHomePageDestination jumpDes;

// 日期展示类型
@property (nonatomic, assign) MSFHomePageDateDisplayType dateDisplay;

/* 随借随还 */

// 总额度
@property (nonatomic, strong) NSString *totalLimit;

// 已用额度
@property (nonatomic, strong) NSString *usedLimit;

// 可用额度
@property (nonatomic, strong) NSString *usableLimit;

// 逾期金额
@property (nonatomic, strong) NSString *overdueMoney;

// 合同到期时间
@property (nonatomic, strong) NSString *contractExpireDate;

// 最近应还款金额， 带￥符号
@property (nonatomic, strong) NSString *latestDueMoney;

// 最近还款日
@property (nonatomic, strong) NSString *latestDueDate;

// 总欠款额
@property (nonatomic, strong) NSString *totalOverdueMoney;

// 合同号
@property (nonatomic, strong) NSString *contractNo;

// 合同状态
//@property (nonatomic, strong) NSString *contractStatus;

- (instancetype)initWithModel:(id)model
										 services:(id<MSFViewModelServices>)services;

- (void)pushDetailViewController;

@end
