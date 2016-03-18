//
//  MSFBankInfoModel.h
//  Finance
//
//  Created by xbm on 15/8/31.
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFObject.h"
#import <MTLFMDBAdapter/MTLFMDBAdapter.h>

// 数据库银行卡信息
@interface MSFBankInfoModel : MTLModel <MTLJSONSerializing, MTLFMDBSerializing>

@property (nonatomic, copy, readonly) NSString *bin;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *maxSize;
@property (nonatomic, copy, readonly) NSString *type;
@property (nonatomic, copy, readonly) NSString *support;
@property (nonatomic, copy, readonly) NSString *code;

@end
