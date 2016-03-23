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

//new version
@property (nonatomic, copy, readonly) NSString *productCd;
@property (nonatomic, copy, readonly) NSString *applyTime;
@property (nonatomic, copy, readonly) NSString *appLmt;
@property (nonatomic, copy, readonly) NSString *loanTerm;
@property (nonatomic, copy, readonly) NSString *status;
@property (nonatomic, copy, readonly) NSString *appNo;
@property (nonatomic, copy, readonly) NSString *type;
@property (nonatomic, copy, readonly) NSString *loanFixedAmt;
@property (nonatomic, copy, readonly) NSString *loanPurpose;
@property (nonatomic, copy, readonly) NSString *bankCardNo;
@property (nonatomic, copy, readonly) NSString *jionLifeInsurance;

@end
