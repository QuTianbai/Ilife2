//
//  NSObject+MSFValidItem.h
//  Finance
//
//  Created by 赵勇 on 10/20/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//
//  用于个人信息上传下载的时候进行一些转换
//  一个过滤器的扩展，主要为了保证类型一致切非空

#import <Foundation/Foundation.h>

@interface NSObject(MSFValidItem)

//从字典取值
- (NSString *)stringForKey:(NSString *)key;
- (NSArray *)arrayForKey:(NSString *)key;
- (NSDictionary *)dictionaryForKey:(NSString *)key;


//转换为首尾去空格换行符的字符串
- (NSString *)trimString:(NSString *)aString;

//电话号码转换
- (NSString *)convertToUploadPhone:(NSString *)phone code:(NSString *)code;
- (NSArray *)convertToDownloadPhone:(NSString *)phone;

@end

