//
//  MSFConfirmContractModel.h
//  Finance
//
//  Created by xbm on 15/9/3.
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFObject.h"

@interface MSFConfirmContractModel : MSFObject

@property (nonatomic, copy, readonly) NSString *errorCode;
@property (nonatomic, copy, readonly) NSString *message;

@end
