//
//	MSFApplyInfo.h
//	Cash
//
//	Created by xbm on 15/5/16.
//	Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//
/*
 page=1\2\3\4
 status=0\1
 
 paersionID、applyNo
 
 87
 */

#import "MSFObject.h"
#import "MSFUserContact.h"


@class MSFPhotoStatus;

@interface MSFApplicationForms : MSFObject

@property (nonatomic, copy) NSString *loanId;//申请ID long类型

#pragma mark - 2.0参数
@property (nonatomic, strong) NSArray *contrastList;//联系人信息

//baseInfo
@property (nonatomic, copy) NSString *homeLine;//住宅电话
@property (nonatomic, copy) NSString *homeCode;//住宅电话区号
@property (nonatomic, copy) NSString *email;//个人电子邮箱 常用邮箱

@property (nonatomic, copy) NSString *currentProvinceCode;//居住地址省code
@property (nonatomic, copy) NSString *currentCityCode;//居住地址市code
@property (nonatomic, copy) NSString *currentCountryCode;//居住地址县code
	@property (nonatomic, copy) NSString *abodeDetail;//详细住址
@property (nonatomic, copy) NSString *houseType;//住房状况 住房情况
@property (nonatomic, copy) NSString *maritalStatus;//婚姻状况 是否婚姻code (1.未婚 2.已婚 3.其他)
@property (nonatomic, strong) NSString *houseTypeTitle;//住房类型：不上传，用于显示
@property (nonatomic, strong) NSString *marriageTitle;//婚姻状况：不上传，用于显示

@property (nonatomic, copy) NSString *qq;//QQ号
@property (nonatomic, copy) NSString *taobao;//淘宝账号
@property (nonatomic, copy) NSString *jdAccount;//京东账号

//occupationInfo
@property (nonatomic, copy) NSString *socialStatus;//社会身份
@property (nonatomic, copy) NSString *education;//教育程度code
	@property (nonatomic, copy) NSString *unitName;//单位名称。学生显示学校，职工显示单位
	@property (nonatomic, copy) NSString *empStandFrom;//起始日期。学生显示入学，职工显示入职日期
@property (nonatomic, copy) NSString *programLength;//学制 学制
@property (nonatomic, copy) NSString *workStartDate;//工作开始时间
@property (nonatomic, copy) NSString *income;//工作收入 工作月收入
@property (nonatomic, copy) NSString *otherIncome;//其他收入 其他月收入
@property (nonatomic, copy) NSString *familyExpense;//每月其他还款
@property (nonatomic, copy) NSString *department;//任职部门 任职部门
@property (nonatomic, copy) NSString *professional;//职位
@property (nonatomic, copy) NSString *industry;//行业类别code
@property (nonatomic, copy) NSString *companyType;//单位性质code
@property (nonatomic, copy) NSString *workProvinceCode;//单位地址省code
@property (nonatomic, copy) NSString *workCityCode;//单位地址市code
@property (nonatomic, copy) NSString *workCountryCode;//单位地址县code
	@property (nonatomic, copy) NSString *empAdd;//单位详细地址
@property (nonatomic, copy) NSString *unitAreaCode;//办公/个体电话区号
@property (nonatomic, copy) NSString *unitTelephone;//办公/个体电话
@property (nonatomic, copy) NSString *unitExtensionTelephone;//办公/个体电话分机号

@end
