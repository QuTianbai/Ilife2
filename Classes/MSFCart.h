//
//  MSFCart.h
//  Finance
//
//  Created by 赵勇 on 12/24/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFObject.h"

@interface MSFCart : MSFObject

@property (nonatomic, copy, readonly) NSString *cartId; // 货单号
@property (nonatomic, copy, readonly) NSString *compId; // 商户编号
@property (nonatomic, copy, readonly) NSString *empId; // 员工编号
@property (nonatomic, copy, readonly) NSString *totalAmt; // 商品总金额
@property (nonatomic, copy, readonly) NSString *totalQuantity; // 商品总件数
@property (nonatomic, copy, readonly) NSString *riskMarkCode; // 风险标识码
@property (nonatomic, strong, readonly) NSArray *cmdtyList; // 商品列表
@property (nonatomic, copy, readonly) NSString *crProdId; // 信贷产品编号
@property (nonatomic, copy, readonly) NSString *promId; // 活动编号
@property (nonatomic, copy, readonly) NSString *minDownPmt; // 最低首付比例
@property (nonatomic, copy, readonly) NSString *maxDownPmt; // 最高首付比例
@property (nonatomic, copy, readonly) NSString *internalCode; // 内部代码

@end
