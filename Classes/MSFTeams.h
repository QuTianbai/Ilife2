//
//	MSFTeam.h
//	Cash
//
//	Created by xbm on 15/5/20.
//	Copyright (c) 2015年 MSFINANCE. All rights reserved.
//胥佰淼

#import "MSFObject.h"

@interface MSFTeams : MSFObject

@property (nonatomic, copy, readonly) NSString *maxAmount;
@property (nonatomic, copy, readonly) NSString *minAmount;
@property (nonatomic, copy, readonly) NSString *teamId;
@property (nonatomic, strong, readonly) NSArray *team;

@end
