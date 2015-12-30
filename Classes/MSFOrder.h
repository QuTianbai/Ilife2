//
//  MSFOrder.h
//  Finance
//
//  Created by 赵勇 on 12/22/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFObject.h"

@interface MSFOrder : MSFObject

@property (nonatomic, copy, readonly) NSString *count; // 总数
@property (nonatomic, copy, readonly) NSString *pageSize; // 行数
@property (nonatomic, copy, readonly) NSString *pageNo; // 当前页
@property (nonatomic, strong, readonly) NSArray *orderList; // 订单列表

@end
