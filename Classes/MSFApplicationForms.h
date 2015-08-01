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


@class MSFPhotoStatus;

@interface MSFApplicationForms : MSFObject
@property (nonatomic, copy) NSString *loanId;//申请ID long类型

/*
 居住地址
*/
@property (nonatomic, copy) NSString *currentProvinceCode;//居住地址省code
@property (nonatomic, copy) NSString *currentProvince;//现居省
@property (nonatomic, copy) NSString *currentCityCode;//居住地址市code
@property (nonatomic, copy) NSString *currentCity;//现居市
@property (nonatomic, copy) NSString *currentCountryCode;//居住地址县code
@property (nonatomic, copy) NSString *currentCountry;//现居区/县
@property (nonatomic, copy) NSString *currentTown;//现居镇 居住地址镇
@property (nonatomic, copy) NSString *currentStreet;//现居街道/村/路 居住街道
@property (nonatomic, copy) NSString *currentCommunity;//现居小区/楼盘 居住小区
@property (nonatomic, copy) NSString *currentApartment;//现居栋/单元/房间号 居住栋
// 自定义地址信息
@property (nonatomic, copy) NSString *currentAddress;//现居栋/单元/房间号 居住栋

/*
 教育程度
*/
@property (nonatomic, copy) NSString *education;//教育程度code
@property (nonatomic, copy) NSString *socialStatus;//社会身份
@property (nonatomic, copy) NSString *universityName;//学校名称 学校名称
@property (nonatomic, copy) NSString *enrollmentYear;//入学年份 入学年份
@property (nonatomic, copy) NSString *programLength;//学制 学制
/*
	工作信息
*/
@property (nonatomic, copy) NSString *workingLength;//工作年限 工作年限
@property (nonatomic, copy) NSString *currentJobDate;//现工作开始时间 工作开始时间
@property (nonatomic, copy) NSString *company;//单位/个体全称 单位/个体名称
@property (nonatomic, copy) NSString *department;//任职部门 任职部门
@property (nonatomic, copy) NSString *title;//职位
@property (nonatomic, copy) NSString *industry;//行业类别code
@property (nonatomic, copy) NSString *companyType;//单位性质code
@property (nonatomic, copy) NSString *workProvinceCode;//单位地址省code
@property (nonatomic, copy) NSString *workProvince;//单位所在省
@property (nonatomic, copy) NSString *workCityCode;//单位地址市code
@property (nonatomic, copy) NSString *workCity;//单位所在市
@property (nonatomic, copy) NSString *workCountryCode;//单位地址县code
@property (nonatomic, copy) NSString *workCountry;//单位所在区/县
@property (nonatomic, copy) NSString *workTown;// 单位所在镇 单位地址镇

@property (nonatomic, copy) NSString *homeCode;//住宅电话区号
@property (nonatomic, copy) NSString *homeLine;//住宅电话 户籍小区
@property (nonatomic, copy) NSString *homeLineOwner;//住宅电话登记人
@property (nonatomic, copy) NSString *mailAddress;//邮寄地址(1.与工作地址相同		2.与现居地址相同 )

@property (nonatomic, copy) NSString *unitAreaCode;//办公/个体电话区号
@property (nonatomic, copy) NSString *unitTelephone;//办公/个体电话
@property (nonatomic, copy) NSString *unitExtensionTelephone;//办公/个体电话分机号
@property (nonatomic, copy) NSString *email;//个人电子邮箱 常用邮箱
@property (nonatomic, copy) NSString *maritalStatus;//婚姻状况 是否婚姻code (1.未婚 2.已婚 3.其他)
@property (nonatomic, copy) NSString *houseType;//住房状况 住房情况
@property (nonatomic, copy) NSString *memberName;//家庭成员名称 家庭成员姓名
@property (nonatomic, copy) NSString *memberRelation;//家庭成员类型 家庭成员关系类型code
@property (nonatomic, copy) NSString *memberCellNum;//家庭成员手机号 家庭成员电话
@property (nonatomic, copy) NSString *memberAddress;// 家庭成员联系地址 家庭成员地址
@property (nonatomic, copy) NSString *memberName2;//家庭成员姓名
@property (nonatomic, copy) NSString *memberRelation2;//家庭成员关系类型code
@property (nonatomic, copy) NSString *memberCellNum2;//家庭成员电话
@property (nonatomic, copy) NSString *memberAddress2;//家庭成员地址

@property (nonatomic, copy) NSString *income;//工作收入 工作月收入
@property (nonatomic, copy) NSString *otherIncome;//其他收入 其他月收入
@property (nonatomic, copy) NSString *familyExpense;//每月还贷额
@property (nonatomic, copy) NSString *name1;// 联系人姓名 联系人姓名1
@property (nonatomic, copy) NSString *phone1;//联系人手机号 联系电话1
@property (nonatomic, copy) NSString *relation1;//与申请人关系 与联系人关系类型1code
@property (nonatomic, copy) NSString *name2;//联系人姓名 联系人姓名2
@property (nonatomic, copy) NSString *phone2;//联系人手机号 联系电话2
@property (nonatomic, copy) NSString *relation2;//与申请人关系 与联系人关系类型2code
@property (nonatomic, copy) NSString *customerFrom;//客户来源种类 客户来源
@property (nonatomic, copy) NSString *remark;//客户申请描述 备注

@property (nonatomic, copy) NSString *usageCode;//贷款用途 借款用途code
@property (nonatomic, copy) NSString *tenor;//贷款期数 分期期数
@property (nonatomic, copy) NSString *principal;//贷款本金 申请金额
@property (nonatomic, copy) NSString *applyStatus1;//申请状态1 (1:不显示 0:申请中)// 最后一个页面是1

@property (nonatomic, copy) NSString *qq;//QQ号
@property (nonatomic, copy) NSString *weixin;//微信号 微信号
@property (nonatomic, copy) NSString *renren;//人人账号
@property (nonatomic, copy) NSString *sinaWeibo;//新浪微博
@property (nonatomic, copy) NSString *tencentWeibo;//腾讯微博
@property (nonatomic, copy) NSString *taobao;//淘宝账号
@property (nonatomic, copy) NSString *taobaoPassword;//淘宝密码
@property (nonatomic, copy) NSString *jdAccount;//京东账号
@property (nonatomic, copy) NSString *jdAccountPwd;//京东密码

@property (nonatomic, copy) NSString *isSafePlan;//是否寿险计划(1:是，0:否)
@property (nonatomic, copy) NSString *bankName;//银行名称
@property (nonatomic, copy) NSString *bankNumber;//银行号码
@property (nonatomic, copy) NSString *page;//页数
@property (nonatomic, copy) NSString *applyNo;//申请单号
@property (nonatomic, copy) NSString *personId;//客户id		long类型
@property (nonatomic, copy) NSString *productId;//产品Id
@property (nonatomic, copy) NSString *productName;//产品名称
@property (nonatomic, copy) NSString *proGroupId;//产品群Id
@property (nonatomic, copy) NSString *proGroupName;//产品群名称
@property (nonatomic, copy) NSString *productGroupCode;//产品群code
@property (nonatomic, copy) MSFPhotoStatus *whitePhoto;//白名单
@property (nonatomic, copy) NSString *repayMoneyMonth;//每月还款额
@property (nonatomic, copy) NSString *monthlyInterestRate;//月利率
@property (nonatomic, copy) NSString *monthlyFeeRate;//月服务费利率

@end
