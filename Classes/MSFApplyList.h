//
//	MSFApplyList.h
//	Cash
//
//	Created by xbm on 15/5/16.
//	Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFObject.h"

@interface MSFApplyList : MSFObject

//2.0参数
@property (nonatomic, copy, readonly) NSString *apply_time;//申请时间
@property (nonatomic, copy, readonly) NSString *total_amount;//总金额
@property (nonatomic, copy, readonly) NSString *total_installments;//总期数
@property (nonatomic, copy ,readonly) NSString *statusString;//2.0版本状态码。U：正在处理 R：拒绝 A：通过 C：激活前取消 N：签署 J：放弃
@property (nonatomic, copy, readonly) NSString *loan_id;//贷款合同ID

//老参数
@property (nonatomic, copy, readonly) NSString *payed_amount;//已还金额
@property (nonatomic, copy, readonly) NSString *monthly_repayment_amount;//每月还款金额
@property (nonatomic, copy, readonly) NSString *current_installment;//当前期数
@property (nonatomic, assign, readonly) NSNumber *status;//0 1：申请中，2：申请成功，3：申请失败，4：还款中，5：取消，6：已完结，7：已逾期

@end
