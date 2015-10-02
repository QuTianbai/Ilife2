//
//  MSFCheckAllowApply.h
//  Finance
//
//  Created by xbm on 15/10/2.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFObject.h"

@class MSFApplyCashInfo;

@interface MSFCheckAllowApply : MSFObject

@property (nonatomic, copy) NSString *processing;

@property (nonatomic, strong) MSFApplyCashInfo *data;

@end
