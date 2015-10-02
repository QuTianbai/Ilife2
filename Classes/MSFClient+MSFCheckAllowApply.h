//
//  MSFClient+MSFCheckAllowApply.h
//  Finance
//
//  Created by xbm on 15/10/2.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFClient.h"

@interface MSFClient (MSFCheckAllowApply)

- (RACSignal *)fetchCheckAllowApply;

@end
