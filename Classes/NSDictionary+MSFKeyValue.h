//
//  NSDictionary+MSFKeyValue.h
//  Finance
//
//  Created by 赵勇 on 10/24/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary(MSFKeyValue)

//申请、还款状态code码映射 Code to String
+ (NSString *)statusStringForKey:(NSString *)key;

@end
