//
//  MSFMarkets.h
//  Finance
//
//  Created by xbm on 15/10/2.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFObject.h"

@interface MSFMarkets : MSFObject

@property (nonatomic, copy, readonly) NSArray *teams;
@property (nonatomic, copy, readonly) NSString *allMinAmount;
@property (nonatomic, copy, readonly) NSString *allMaxAmount;

@end
