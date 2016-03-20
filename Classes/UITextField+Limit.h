//
//  UITextField+Limit.h
//  Finance
//
//  Created by admin on 16/3/18.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Limit)
//限制uitextFiled的长度
- (void)limitWitLength:(int)length;
//使用正则表达式限制
- (void)limitWitRex:(NSString *)rex;
- (void)dylimitWithRex:(BOOL(^)(NSString *str))block;

@end
