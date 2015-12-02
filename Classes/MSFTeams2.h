//
//  MSFTeams2.h
//  Finance
//
//  Created by xbm on 15/10/2.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFObject.h"

// 产品集
@interface MSFTeams2 : MSFObject

@property (nonatomic, copy, readonly) NSString *maxAmount;
@property (nonatomic, copy, readonly) NSString *minAmount;

// MSFTeam array
@property (nonatomic, strong, readonly) NSArray *team;

@end
