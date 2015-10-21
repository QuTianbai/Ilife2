//
//  NSObject+MSFValidItem.h
//  Finance
//
//  Created by 赵勇 on 10/20/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject(MSFValidItem)

//转换为有效字符串
- (NSString *)validString;

//转换为有效数组
- (NSArray *)validArray;

//转换为有效字典
- (NSDictionary *)validDictionary;

//转换为首尾去空格换行符的字符串
- (NSString *)trimmedString;

@end

