//
// MSFClient+Users.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFClient+Users.h"
#import "RACSignal+MSFClientAdditions.h"
#import "MSFUser.h"
#import "NSDateFormatter+MSFFormattingAdditions.h"
#import <NSString-Hashes/NSString+Hashes.h>
#import "MSFResponse.h"
#import "MSFCirculateCashModel.h"
#import "MSFTransSmsSeqNOModel.h"

@implementation MSFClient (Users)

- (RACSignal *)resetSignInPassword:(NSString *)password phone:(NSString *)phone captcha:(NSString *)captcha name:(NSString *)name citizenID:(NSString *)citizenID {
	NSMutableDictionary *parameters = NSMutableDictionary.dictionary;
	parameters[@"mobile"] = phone;
	parameters[@"newPassword"] = password.sha256;
	parameters[@"smsCode"] = captcha;
	parameters[@"name"] = name;
	parameters[@"ident"] = citizenID;
	NSMutableURLRequest *request = [self requestWithMethod:@"POST" path:@"password/forgetPassword" parameters:parameters];
	
	return [self enqueueRequest:request resultClass:nil];
}

- (RACSignal *)updateSignInPassword:(NSString *)oldpassword password:(NSString *)newpassword {
	NSURLRequest *request = [self requestWithMethod:@"POST" path:@"password/updatePassword" parameters: @{
		@"oldPassword": oldpassword.sha256,
		@"newPassword": newpassword.sha256,
		@"uniqueId": self.user.objectID
	}];
	
	return [self enqueueRequest:request resultClass:nil];
}

- (RACSignal *)associateSignInMobile:(NSString *)mobile usingMobile:(NSString *)usingMobile captcha:(NSString *)captcha citizenID:(NSString *)citizenID name:(NSString *)name {
	NSDictionary *parameters = @{
		@"newMobile": mobile,
		@"oldMobile": usingMobile,
		@"smsCode": captcha,
		@"idCard": citizenID,
		@"name": name,
		@"uniqueId": self.user.objectID,
	};
	
	NSURLRequest *request = [self requestWithMethod:@"POST" path:@"user/updateMobile" parameters:parameters];
	return [[self enqueueRequest:request resultClass:nil]
		map:^id(MSFResponse *response) {
			NSString *token = response.parsedResult[@"token"];
			MSFUser *user = [MTLJSONAdapter modelOfClass:MSFUser.class fromJSONDictionary:response.parsedResult error:nil];
			MSFClient *client = [MSFClient authenticatedClientWithUser:user token:token];
			return client;
		}];
}

- (RACSignal *)addBankCardWithTransPassword:(NSString *)transPassword AndBankCardNo:(NSString *)bankCardNo AndbankBranchProvinceCode:(NSString *)bankBranchProvinceCode AndbankBranchCityCode:(NSString *)bankBranchCityCode {
	NSMutableDictionary *parameters = NSMutableDictionary.dictionary;
	parameters[@"uniqueId"] = self.user.uniqueId;
	parameters[@"transPassword"] = transPassword;
	parameters[@"bankCardNo"] = bankCardNo;
	parameters[@"bankBranchProvinceCode"] = bankBranchProvinceCode;
	parameters[@"bankBranchCityCode"] = bankBranchCityCode;
	
	NSMutableURLRequest *request = [self requestWithMethod:@"POST" path:@"bankcard/bind" parameters:parameters];
	[request setHTTPMethod:@"POST"];
	
	return [self enqueueRequest:request resultClass:nil];
}

- (RACSignal *)setMasterBankCard:(NSString *)bankCardID AndTradePwd:(NSString *)pwd {
	NSMutableDictionary *parameters = NSMutableDictionary.dictionary;
	parameters[@"uniqueId"] = self.user.uniqueId;
	parameters[@"transPassword"] = pwd;
	parameters[@"bankCardId"] = bankCardID;
	
	NSMutableURLRequest *request = [self requestWithMethod:@"POST" path:@"bankcard/mainbind" parameters:parameters];
	
	return [self enqueueRequest:request resultClass:nil];
}

- (RACSignal *)unBindBankCard:(NSString *)bankCardID AndTradePwd:(NSString *)pwd {
	NSMutableDictionary *parameters = NSMutableDictionary.dictionary;
	parameters[@"uniqueId"] = self.user.uniqueId;
	parameters[@"transPassword"] = pwd;
	parameters[@"bankCardId"] = bankCardID;
	
	NSMutableURLRequest *request = [self requestWithMethod:@"POST" path:@"bankcard/unbind" parameters:parameters];
	
	return [self enqueueRequest:request resultClass:nil];
}

- (RACSignal *)drawCashWithDrawCount:(NSString *)count AndContraceNO :(NSString *)contractNO AndPwd:(NSString *)pwd AndType:(int)type {
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	parameters[@"drawingAmount"] = count;
	parameters[@"contractNo"] = contractNO;
	parameters[@"uniqueId"] = self.user.uniqueId;
	parameters[@"dealPwd"] = pwd?:@"";
	NSString *path = @"loan/drawings";
	if (type == 1 || type == 2) {
		path = @"loan/repay";
		parameters[@"money"] = count;
	}
	
	NSMutableURLRequest *request = [self requestWithMethod:@"POST" path:path parameters:parameters];
	
	return [self enqueueRequest:request resultClass:nil];
}

- (RACSignal *)setTradePwdWithPWD:(NSString *)pwd AndCaptch:(NSString *)capthch {
	NSMutableURLRequest *request = [self requestWithMethod:@"POST" path:@"transPassword/set" parameters:@{
		@"uniqueId": self.user.uniqueId,
		@"newTransPassword": pwd?:@"",
		@"smsCode": capthch?:@""
	}];
	return [self enqueueRequest:request resultClass:nil];
}

- (RACSignal *)updateTradePwdWitholdPwd:(NSString *)oldpwd AndNewPwd:(NSString *)pwd AndCaptch:(NSString *)captch {
	NSMutableURLRequest *request = [self requestWithMethod:@"POST" path:@"transPassword/updatePassword" parameters:@{
		@"uniqueId": self.user.uniqueId,
		@"newTransPassword": pwd?:@"",
		@"smsCode": captch?:@"",
		@"oldTransPassword": oldpwd?:@""
	}];
	return [self enqueueRequest:request resultClass:nil];
}

- (RACSignal *)resetTradepwdWithBankCardNo:(NSString *)bankCardNO AndprovinceCode:(NSString *)provinceCode AndcityCode:(NSString *)cityCode AndsmsCode:(NSString *)smsCode AndnewTransPassword:(NSString *)newTransPassword {
	NSMutableURLRequest *request = [self requestWithMethod:@"POST" path:@"transPassword/forgetPassword" parameters:@{
		@"uniqueId": self.user.uniqueId,
		@"newTransPassword": newTransPassword?:@"",
		@"smsCode": smsCode?:@"",
		@"bankCardNo": bankCardNO?:@"",
		@"provinceCode": provinceCode?:@"",
		@"cityCode": cityCode?:@""
	}];
	return [self enqueueRequest:request resultClass:nil];
}

- (RACSignal *)checkDataWithPwd:(NSString *)transpassword contractNO:(NSString *)contractNO {
	NSMutableURLRequest *request = [self requestWithMethod:@"POST" path:@"activePay/checkData" parameters:@{@"transPassword":transpassword, @"contractNo":contractNO}];
	return [self enqueueRequest:request resultClass:nil];
}

- (RACSignal *)sendSmsCodeForTrans {
	NSMutableURLRequest *request = [self requestWithMethod:@"POST" path:@"activePay/checkSms" parameters:nil];
	return [[self enqueueRequest:request resultClass:MSFTransSmsSeqNOModel.class] msf_parsedResults];
}

- (RACSignal *)transActionWithAmount:(NSString *)amount smsCode:(NSString *)smsCode smsSeqNo:(NSString *)smsSeqNo contractNo:(NSString *)contractNo {
	NSMutableURLRequest *request = [self requestWithMethod:@"POST" path:@"activePay/consume" parameters:@{
																		@"amount": amount?:@"",
																		@"smsCode": smsCode?:@"",
																		@"smsSeqNo": smsSeqNo?:@"",
																		@"contractNo": contractNo?:@"",
																	}];
	return [self enqueueRequest:request resultClass:nil];
}

- (RACSignal *)drawingsWithAmounts:(NSString *)amounts contractNo:(NSString *)contractNo passcode:(NSString *)passcode {
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	parameters[@"drawingAmount"] = amounts;
	parameters[@"contractNo"] = contractNo;
	parameters[@"dealPwd"] = passcode;
	
	NSURLRequest *request = [self requestWithMethod:@"POST" path:@"loan/drawings" parameters:parameters];
	
	return [self enqueueRequest:request resultClass:nil];
}

@end
