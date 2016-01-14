//
//  MSFOrderDetail.h
//  Finance
//
//  Created by 赵勇 on 12/22/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFObject.h"

@class MSFCommodity;
@class MSFTravel;

@interface MSFOrderDetail : MSFObject

@property (nonatomic, copy, readonly) NSString *inOrderId; // 订单id
@property (nonatomic, copy, readonly) NSString *orderStatus; // 订单状态
@property (nonatomic, copy, readonly) NSString *orderTime; // 下单时间
@property (nonatomic, copy, readonly) NSString *txnTime; // 交易时间
@property (nonatomic, copy, readonly) NSString *compId; // 商户编号
@property (nonatomic, copy, readonly) NSString *empId; // 员工编号
@property (nonatomic, copy, readonly) NSString *compName; // 商户名称
@property (nonatomic, copy, readonly) NSString *empName; // 员工姓名
@property (nonatomic, copy, readonly) NSString *outOrderId; // 商户订单号
@property (nonatomic, copy, readonly) NSString *catId; // 品类编号
@property (nonatomic, copy, readonly) NSString *totalAmt; // 总金额
@property (nonatomic, copy, readonly) NSString *totalQuantity; // 总件数
@property (nonatomic, copy, readonly) NSString *uniqueId; // 商户编号
@property (nonatomic, copy, readonly) NSString *custName; // 客户姓名
@property (nonatomic, copy, readonly) NSString *cellphone; // 客户手机号
@property (nonatomic, copy, readonly) NSString *appId; // 申请单编号
@property (nonatomic, copy, readonly) NSString *contractId; // 合同编号
@property (nonatomic, copy, readonly) NSString *crProdId; // 产品编号
@property (nonatomic, copy, readonly) NSString *crProdName; // 产品名称
@property (nonatomic, copy, readonly) NSString *curCode; // 币种
@property (nonatomic, copy, readonly) NSString *loanAmt; // 贷款金额
@property (nonatomic, copy, readonly) NSString *loanTerm; // 贷款期数
@property (nonatomic, copy, readonly) NSString *mthlyPmtAmt; // 月还款额
@property (nonatomic, assign, readonly) BOOL isDownPmt; // 是否首付贷
@property (nonatomic, copy, readonly) NSString *downPmtPct; // 首付贷比例
@property (nonatomic, copy, readonly) NSString *downPmt; // 首付金额
@property (nonatomic, assign, readonly) BOOL valueAddedSvc; // 是否增值服务项
@property (nonatomic, strong, readonly) NSArray *cmdtyList; // 商品列表（MSFCommodity）

// 判断商品还是旅行
@property (nonatomic, assign, readonly) BOOL isCommodity;
@property (nonatomic, strong, readonly) MSFTravel *travel;
@property (nonatomic, strong, readonly) NSArray *companions;

@end
