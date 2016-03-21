//
//  MSFCmdtyModel.h
//  Finance
//
//  Created by xbm on 16/2/29.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFObject.h"

@interface MSFCmdtyModel : MSFObject

@property (nonatomic, copy) NSString *cmdtyName;
@property (nonatomic, copy) NSString *cmdtyPrice;
@property (nonatomic, copy) NSString *orderTime;

@end
