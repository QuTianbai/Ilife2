//
//  MSFAddressInfo.h
//  Finance
//
//  Created by xbm on 15/7/31.
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFObject.h"

__attribute__((deprecated("This class is unavailable")))

@interface MSFAddressInfo : MSFObject

@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *district;

@end
