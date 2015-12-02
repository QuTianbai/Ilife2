//
//  MSFCheckAllowApply.h
//  Finance
//
//  Created by xbm on 15/10/2.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFObject.h"

@class MSFApplyCashInfo;

// 通过接口获取是否允许贷款，解析的数据信息
@interface MSFCheckAllowApply : MSFObject

// 是否允许贷款判断标志
@property (nonatomic, assign) NSInteger processing;

// 申请单信息，申请中，预期等
@property (nonatomic, strong) MSFApplyCashInfo *data;

@end
