//
//  MSFMarkets.h
//  Finance
//
//  Created by xbm on 15/10/2.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFObject.h"

// 马上贷产品集
@interface MSFMarkets : MSFObject

// 产品列表 <MSFTeams2>
@property (nonatomic, copy, readonly) NSArray *teams;

// 可贷最小金额
@property (nonatomic, copy, readonly) NSString *allMinAmount;

// 可贷最大金额
@property (nonatomic, copy, readonly) NSString *allMaxAmount;

@end
