//
// MSFClient+Users.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFClient.h"

@interface MSFClient (Users)

- (RACSignal *)authenticateUsername:(NSString *)username userident:(NSString *)userident city:(NSString *)city province:(NSString *)province banknumber:(NSString *)number;

// 找回登录密码.
//
// password  - 新的登录密码.
// phone     - 注册手机号.
// captcha	 - 验证码.
// name			 - 用户姓名.
// citizenID - 用户身份证号.
//
// Returns  MSFResponse.
- (RACSignal *)resetSignInPassword:(NSString *)password phone:(NSString *)phone captcha:(NSString *)captcha name:(NSString *)name citizenID:(NSString *)citizenID;

// 更新用户登录密码.
//
// oldpassword - 旧密码.
// newpassword - 新密码.
//
// Returns response.
- (RACSignal *)updateSignInPassword:(NSString *)oldpassword password:(NSString *)newpassword;

// 更新用户登录手机号.
//
// mobile				- 用户新手机号.
// usingMobile	- 用户正在使用的手机号.
// captcha			- The new mobile received capthca.
// citizenID		- The user citizen identifier card number.
// name					- The user realname.
//
// Returns authenticated client.
- (RACSignal *)associateSignInMobile:(NSString *)mobile usingMobile:(NSString *)usingMobile captcha:(NSString *)captcha citizenID:(NSString *)citizenID name:(NSString *)name;

// Bind New bank card to user account
//
// transPassword					- The user trading password.
// bankCardNo							- The bank card numbers.
// bankBranchProvinceCode - The card's bank province code.
// bankBranchCityCode			- The card's bank city code.
//
// Returns MSFResponse.
- (RACSignal *)addBankCardWithTransPassword:(NSString *)transPassword AndBankCardNo:(NSString *)bankCardNo AndbankBranchProvinceCode:(NSString *)bankBranchProvinceCode AndbankBranchCityCode:(NSString *)bankBranchCityCode;

// Set main card.
//
// bankCardID - The bank card id, which had bind to user account.
// pwd				- The user trading password.
//
// Returns MSFResponse.
- (RACSignal *)setMasterBankCard:(NSString *)bankCardID AndTradePwd:(NSString *)pwd;

// Unbind user bank card from user account
//
// bankCardID - The user band card ID.
// pwd				- The user trading password.
//
// Returns MSFResponse.
- (RACSignal *)unBindBankCard:(NSString *)bankCardID AndTradePwd:(NSString *)pwd;

// 提现/还款.
//
// count			- 提现/还款金额.
// contractNO - `合同号`.
// pwd				- 用户交易密码.
// type				- 1 还款 2提现.
//
// Returns MSFResponse.
- (RACSignal *)drawCashWithDrawCount:(NSString *)count AndContraceNO:(NSString *)contractNO AndPwd:(NSString *)pwd AndType:(int)type;

// 设置交易密码.
//
// pwd	   - 交易密码.
// captcha - 手机验证码.
//
// Returns MSFResponse.
- (RACSignal *)setTradePwdWithPWD:(NSString *)pwd AndCaptch:(NSString *)capthch;

// 更新交易密码
//
// oldpwd  - 旧交易密码.
// pwd		 - 新交易密码
// captcha - 手机验证码
//
// Returns MSFResponse.
- (RACSignal *)updateTradePwdWitholdPwd:(NSString *)oldpwd AndNewPwd:(NSString *)pwd AndCaptch:(NSString *)captch;

// 重置交易密码
//
// bankCardNO				- 银行卡号
// provinceCode			- 银行所在省编码
// cityCode					- 银行所在市编码
// smsCode					- 手机验证码
// newTransPassword - 新交易密码
//
// Returns MSFResponse.
- (RACSignal *)resetTradepwdWithBankCardNo:(NSString *)bankCardNO AndprovinceCode:(NSString *)provinceCode AndcityCode:(NSString *)cityCode AndsmsCode:(NSString *)smsCode AndnewTransPassword:(NSString *)newTransPassword;

// 支付.验证数据交易密码
//
// transpassword			- 交易密码.
// contractNO - `合同号`.
//
// Returns MSFResponse.
- (RACSignal *)checkDataWithPwd:(NSString *)transpassword contractNO:(NSString *)contractNO;

// 支付验证码
//
//
// Returns MSFResponse.
- (RACSignal *)sendSmsCodeForTrans;

// 支付交易
//
//
// Returns MSFResponse.
- (RACSignal *)transActionWithAmount:(NSString *)amount smsCode:(NSString *)smsCode smsSeqNo:(NSString *)smsSeqNo contractNo:(NSString *)contractNo;

// 提款.
//
// amounts    - 提款金额.
// contractNO - 提款合同号.
// passcode   - 交易密码.
//
// Returns MSFResponse.
- (RACSignal *)drawingsWithAmounts:(NSString *)amounts contractNo:(NSString *)contractNo passcode:(NSString *)passcode bankCardID:(NSString *)bankCardID;

- (RACSignal *)fetchUserInfo;
- (RACSignal *)updateUserInfo __deprecated_msg("Use -updateUser:");
- (RACSignal *)updateUser:(MSFUser *)user;

@end
