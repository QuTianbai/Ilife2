//
//  MSFSocialInsuranceModel.h
//  Finance
//
//  Created by xbm on 15/11/20.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFObject.h"

__attribute__((deprecated("This class is unavailable")))

@interface MSFSocialInsuranceModel : MSFObject
//职工社保
@property (nonatomic, copy, readonly) NSString *empEdwExist;//职工养老保险当前是否参保
@property (nonatomic, copy) NSString *empEdwBase;//******职工养老保险的缴费基数
@property (nonatomic, copy, readonly) NSString *empEdwStartDate;//职工养老保险首次缴费日期
@property (nonatomic, copy, readonly) NSString *empEdwMonths;//职工养老保险实际缴费月数
@property (nonatomic, copy, readonly) NSString *empMdcInsuExist;//职工医疗保险当前是否参保
@property (nonatomic, copy, readonly) NSString *empMdcInsuBase;//职工医疗保险的缴费基数
@property (nonatomic, copy, readonly) NSString *empMdcInsuStartDate;//职工医疗保险首次缴费日期
@property (nonatomic, copy, readonly) NSString *empMdcMonths;//职工医疗保险实际缴费月数
@property (nonatomic, copy, readonly) NSString *injuInsuExist;//职工工伤保险当前是否参保
@property (nonatomic, copy, readonly) NSString *unempInsuExist;//职工失业保险当前是否参保
@property (nonatomic, copy, readonly) NSString *birthInsuExist;//职工生育保险当前是否参保	birthInsuExist

//居民保险
@property (nonatomic, copy, readonly) NSString *rsdtOldInsuExist;//居民养老保险当前是否参保
@property (nonatomic, copy, readonly) NSString *rsdtOldInsuLvl;//居民养老保险的缴费档次
@property (nonatomic, copy, readonly) NSString *rsdtOldInsuStartDate;//居民养老保险首次缴费日期
@property (nonatomic, copy) NSString *rsdtOldInsuYears;//居民养老保险缴费年数
@property (nonatomic, copy, readonly) NSString *rsdtMdcInsuExist;//居民医疗保险当前是否参保
@property (nonatomic, copy, readonly) NSString *rsdtMdcInsuLvl;//居民医疗保险的缴费档次
@property (nonatomic, copy, readonly) NSString *rsdtMdcInsuStartDate;//居民医疗保险首次缴费日期
@property (nonatomic, copy, readonly) NSString *rsdtMdcInsuYears;//居民医疗保险缴费年数

@end
