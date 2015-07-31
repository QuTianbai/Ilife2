//
//  MSFResultModel.h
//  Finance
//
//  Created by xbm on 15/7/31.
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFObject.h"

@class MSFAddressInfo;

@interface MSFResultModel : MSFObject

@property (nonatomic, copy) NSString *formatted_address;
@property (nonatomic, strong) MSFAddressInfo *addressComponent;

@end
