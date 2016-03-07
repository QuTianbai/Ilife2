//
//  MSFCmdtyModel.h
//  Finance
//
//  Created by xbm on 16/2/29.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFObject.h"

@interface MSFCmdtyModel : MSFObject

@property (nonatomic, copy, readonly) NSString *cmdtyName;
@property (nonatomic, copy, readonly) NSString *cmdtyPrice;
@property (nonatomic, copy, readonly) NSString *orderTime;

@end
