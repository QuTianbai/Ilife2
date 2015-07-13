//
//  MSFCheckEmployee.h
//  Cash
//
//  Created by xbm on 15/5/20.
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFObject.h"

@interface MSFMarket : MSFObject

@property(nonatomic,copy,readonly) NSString *employee;
@property(nonatomic,assign,readonly) BOOL white;
@property(nonatomic,copy,readonly) NSArray *teams;
@property(nonatomic,copy,readonly) NSString *allMinAmount;
@property(nonatomic,copy,readonly) NSString *allMaxAmount;

@end
