//
//  MSFOrderDetail.h
//  Finance
//
//  Created by 赵勇 on 12/22/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFObject.h"
#import "MSFCommodity.h"

@interface MSFOrderDetail : MSFObject

@property (nonatomic, copy, readonly) NSString *inOrderId; // 订单id
@property (nonatomic, copy, readonly) NSString *totalAmt; // 总金额
@property (nonatomic, copy, readonly) NSString *totalQuantity; // 总件数
@property (nonatomic, copy, readonly) NSString *orderStatus; // 订单状态
@property (nonatomic, copy, readonly) NSString *orderTime; // 下单时间
@property (nonatomic, strong, readonly) NSArray *cmdtyList; // 商品列表（MSFCommodity）

@end
