//
// MSFClient+Users.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFClient.h"

@interface MSFClient (Users)

/**
 *	获取用户详细信息
 *
 *	@return user
 */
- (RACSignal *)fetchUserInfo;

/**
 *	找回用密码
 *
 *	@param phone		手机号
 *	@param password 密码
 *	@param captcha	验证码
 *
 *	@return response
 */
- (RACSignal *)resetPassword:(NSString *)password phone:(NSString *)phone captcha:(NSString *)captcha __deprecated_msg("Use `resetSignInPassword:password:phone:captcha:name: citizenID:`");
- (RACSignal *)resetSignInPassword:(NSString *)password phone:(NSString *)phone captcha:(NSString *)captcha name:(NSString *)name citizenID:(NSString *)citizenID;

/**
 *	更新用户密码
 *
 *	@param oldpassword 旧密码
 *	@param newpassword 新密码
 *
 *	@return response
 */
- (RACSignal *)updateSignInPassword:(NSString *)oldpassword password:(NSString *)newpassword;

/**
 *	更新用户头像
 *
 *	@param URL 图片文件本地地址
 *
 *	@return new user
 */
- (RACSignal *)updateUserAvatarWithFileURL:(NSURL *)URL;

/**
 *	实名认证
 *
 *	@param name		 姓名
 *	@param idcard	 身份证号
 *	@param date		 有效时间，默认""
 *	@param session 是否永久有效，YES表示永久有效
 *
 *	@return new user
 */
- (RACSignal *)identityVerificationUsername:(NSString *)name idcard:(NSString *)idcard expire:(NSDate *)date session:(BOOL)session __deprecated_msg("Use `realnameAuthentication: idcard: expire: session`");

/**
 *	绑定银行卡
 *
 *	@param card			银行卡号
 *	@param banck		开户银行
 *	@param country	国家
 *	@param province 省份
 *	@param city			城市
 *	@param address	详细地址
 *
 *	@return new user
 */
- (RACSignal *)associateUserPasscard:(NSString *)card bank:(NSString *)bank country:(NSString *)country province:(NSString *)province city:(NSString *)city address:(NSString *)address;

- (RACSignal *)associateSignInMobile:(NSString *)mobile usingMobile:(NSString *)usingMobile captcha:(NSString *)captcha citizenID:(NSString *)citizenID name:(NSString *)name;

/**
 *	检查用户是否存在贷款
 *
 *	@return response
 */
- (RACSignal *)checkUserHasCredit;

/**
 *	检查用户是否是员工
 *
 *	@return response
 */
- (RACSignal *)checkUserIsEmployee;

- (RACSignal *)addBankCardWithTransPassword:(NSString *)transPassword AndBankCardNo:(NSString *)bankCardNo AndbankBranchProvinceCode:(NSString *)bankBranchProvinceCode AndbankBranchCityCode:(NSString *)bankBranchCityCode;

- (RACSignal *)setMasterBankCard:(NSString *)bankCardID AndTradePwd:(NSString *)pwd;

- (RACSignal *)unBindBankCard:(NSString *)bankCardID AndTradePwd:(NSString *)pwd;

- (RACSignal *)drawCashWithDrawCount:(NSString *)count AndContraceNO:(NSString *)contractNO AndPwd:(NSString *)pwd AndType:(int)type;

- (RACSignal *)setTradePwdWithPWD:(NSString *)pwd AndCaptch:(NSString *)capthch;

- (RACSignal *)updateTradePwdWitholdPwd:(NSString *)oldpwd AndNewPwd:(NSString *)pwd AndCaptch:(NSString *)captch;

- (RACSignal *)resetTradepwdWithBankCardNo:(NSString *)bankCardNO AndprovinceCode:(NSString *)provinceCode AndcityCode:(NSString *)cityCode AndsmsCode:(NSString *)smsCode AndnewTransPassword:(NSString *)newTransPassword;

@end
