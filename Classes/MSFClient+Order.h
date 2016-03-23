//
//  MSFClient+MSFOrder.h
//  Finance
//
//  Created by 赵勇 on 12/22/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFClient.h"

@class RACSignal;

@interface MSFClient(Order)

- (RACSignal *)fetchOrderList:(NSString *)status pageNo:(NSInteger)pn;
- (RACSignal *)fetchOrder:(NSString *)orderId;

- (RACSignal *)fetchMyOrderListWithType:(NSString *)type;
//商品贷详情
- (RACSignal *)fetchMyOrderProductWithInOrderId:(NSString *)inOrderId appNo:(NSString *)appNo;
//马上贷、信用钱包详情
- (RACSignal *)fetchMyOrderDetailWithAppNo:(NSString *)appNo type:(NSString *)type;

@end
