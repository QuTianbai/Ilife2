//
//  MSFClient+MSFLifeInsurance.h
//  Finance
//
//  Created by xbm on 15/10/13.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFClient.h"

@interface MSFClient (MSFLifeInsurance)

// 获取寿险协议.
//
// Returns HTML Request.
- (RACSignal *)fetchLifeInsuranceAgreementWithProductType:(NSString *)product;

@end
