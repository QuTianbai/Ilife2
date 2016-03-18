//
//  MSFMarkets.h
//  Finance
//
//  Created by xbm on 15/10/2.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFObject.h"

// 总金额度限制
@interface MSFAmortize : MSFObject

// 分金额上下限集MSFOrganize
@property (nonatomic, copy, readonly) NSArray *teams;

// 可贷最小金额
@property (nonatomic, copy, readonly) NSString *allMinAmount;

// 可贷最大金额
@property (nonatomic, copy, readonly) NSString *allMaxAmount;

@end
