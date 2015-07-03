//
// MSFLEvent.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <Mantle/Mantle.h>
#import <MTLFMDBAdapter/MTLFMDBAdapter.h>

@class MSFUser;

typedef NS_ENUM(NSUInteger, MSFEventType) {
  MSFEventTypePage,
};

/**
 *  网络状态
 */
typedef NS_ENUM(NSUInteger, MSFNetworkType){
  /**
   *  无网络
   */
  MSFNetworkTypeNone = 1000,
  /**
   *  获取网络状态失败或特殊网络
   */
  MSFNetworkTypeFailure = 1010,
  /**
   *  获取不到运营商网络的具体信息
   */
  MSFNetworkTypeAbandon = 1020,
  /**
   *  2g
   */
  MSFNetworkType2G = 1021,
  /**
   *  3g
   */
  MSFNetworkType3G = 1022,
  /**
   *  4g
   */
  MSFNetworkType4G = 1023,
  /**
   *  WIFI
   */
  MSFNetworkTypeWiFi = 1030,
};

/**
 *  页面ID
 */
typedef NS_ENUM(NSUInteger, MSFPage){
  /**
   *  未知
   */
  MSFPageNone = -1,
  /**
   *  首页未登录
   */
  MSFPageHomepageNotSigin = 1,
  /**
   *  登录
   */
  MSFPageSignIning = 2,
  /**
   *  找回密码
   */
  MSFPageForgetPassword = 3,
  /**
   *  注册
   */
  MSFPageSignUping = 4,
  /**
   *  设置
   */
  MSFPageSetting = 5,
  /**
   *  关于
   */
  MSFPageAbout = 6,
  /**
   *  产品介绍
   */
  MSFPageIntro = 7,
  /**
   *  帮助
   */
  MSFPageHelper = 8,
  /**
   *  门店
   */
  MSFPageShop = 9,
  /**
   *  首页已登录
   */
  MSFPageHomepageSigin = 10,
  /**
   *  我的账户
   */
  MSFPageAccount = 11,
  /**
   *  个人中心
   */
  MSFPageUser = 12,
  /**
   *  申请记录
   */
  MSFPageApplyRecord = 13,
  /**
   *  还款计划
   */
  MSFPageRepayment = 14,
  /**
   *  历史交易
   */
  MSFPageHistory = 15,
  /**
   *  修改密码
   */
  MSFPageUpdatePassword = 16,
  /**
   *  贷款1
   */
  MSFPageLoan1 = 17,
  /**
   *  贷款2
   */
  MSFPageLoan2 = 18,
  /**
   *  贷款3
   */
  MSFPageLoan3 = 19,
  /**
   *  贷款4
   */
  MSFPageLoan4 = 20,
  /**
   *  贷款5
   */
  MSFPageLoan5 = 21,
  /**
   *  完善资料
   */
  MSFPageCloze = 22,
  /**
   *  当前还款列表
   */
  MSFPageLoanList = 23,
};

@interface MSFLEvent : MTLModel <MTLFMDBSerializing>

@property(nonatomic,copy,readonly) NSString *event;
@property(nonatomic,copy,readonly) NSString *currentTime;
@property(nonatomic,copy,readonly) NSString *networkType;
@property(nonatomic,copy,readonly) NSString *userId;
@property(nonatomic,copy,readonly) NSString *location;
@property(nonatomic,copy,readonly) NSString *label;
@property(nonatomic,copy,readonly) NSString *value;

- (instancetype)initWithEvent:(MSFEventType)event
  date:(NSDate *)date
  network:(MSFNetworkType)network
  user:(MSFUser *)user
  latitude:(double)latitude
  longitude:(double)longitude
  label:(NSString *)label
  value:(NSString *)value;

@end
