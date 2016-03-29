//
//  MSFOperatorsManager.h
//  Finance
//
//  Created by administrator on 16/3/29.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSFOperatorsManager : NSObject

+ (NSString *)checkCarrier;//检测本机号运营商

+ (NSString *)checkCarrierWithPhoneNum:(NSString *)phone;

@end
