//
//  MSFApplyList.h
//  Cash
//
//  Created by xbm on 15/5/16.
//  Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFObject.h"

@interface MSFApplyList : MSFObject

@property(nonatomic,copy,readonly) NSString *loan_id;//贷款合同ID
@property(nonatomic,copy,readonly) NSDate *apply_time;//申请时间
@property(nonatomic,copy,readonly) NSString *payed_amount;//已还金额
@property(nonatomic,copy,readonly) NSString *total_amount;//总金额

@property(nonatomic,copy,readonly) NSString *monthly_repayment_amount;//每月还款金额
@property(nonatomic,copy,readonly) NSString *current_installment;//当前期数

@property(nonatomic,copy,readonly) NSString *total_installments;//总期数
@property(nonatomic,assign,readonly) NSNumber *status;//0 1：申请中，2：申请成功，3：申请失败，4：还款中，5：取消，6：已完结，7：已逾期

@end
