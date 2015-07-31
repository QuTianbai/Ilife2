//
//  MSFLocationModel.h
//  Finance
//
//  Created by xbm on 15/7/30.
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFObject.h"

@class MSFResultModel;

@interface MSFLocationModel : MSFObject

@property (nonatomic, strong) MSFResultModel *result;
@property (nonatomic, assign) NSString *status;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;

@end
