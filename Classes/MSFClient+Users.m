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
#import "MSFPaymentToken.h"
#import "MSFPersonal.h"
#import "MSFProfessional.h"
#import "MSFSocialProfile.h"
#import "MSFSocialInsurance.h"
#import "MSFContact.h"
#import "MSFAuthenticate.h"

@implementation MSFClient (Users)

- (RACSignal *)authenticateUsername:(NSString *)username userident:(NSString *)userident city:(NSString *)city province:(NSString *)province banknumber:(NSString *)number {
	NSMutableDictionary *parameters = NSMutableDictionary.dictionary;
	parameters[@"name"] = username;
	parameters[@"idCard"] = userident;
	parameters[@"bankCardNo"] = number;
	parameters[@"bankBranchProvinceCode"] = province;
	parameters[@"bankBranchCityCode"] = city;
	NSMutableURLRequest *request = [self requestWithMethod:@"POST" path:@"user/authentication" parameters:parameters];
	
	return [[self enqueueRequest:request resultClass:MSFAuthenticate.class] msf_parsedResults];
}

- (RACSignal *)resetSignInPassword:(NSString *)password phone:(NSString *)phone captcha:(NSString *)captcha name:(NSString *)name citizenID:(NSString *)citizenID {
	NSMutableDictionary *parameters = NSMutableDictionary.dictionary;
	parameters[@"mobile"] = phone;
	parameters[@"newPassword"] = password.sha256;
	parameters[@"smsCode"] = captcha;
	NSMutableURLRequest *request = [self requestWithMethod:@"POST" path:@"user/forgetPassword" parameters:parameters];
	
	return [self enqueueRequest:request resultClass:nil];
}

- (RACSignal *)updateSignInPassword:(NSString *)oldpassword password:(NSString *)newpassword {
	NSURLRequest *request = [self requestWithMethod:@"POST" path:@"user/updatePassword" parameters: @{
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
	parameters[@"uniqueId"] = self.user.objectID;
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
	parameters[@"uniqueId"] = self.user.objectID;
	parameters[@"transPassword"] = pwd;
	parameters[@"bankCardId"] = bankCardID;
	
	NSMutableURLRequest *request = [self requestWithMethod:@"POST" path:@"bankcard/mainbind" parameters:parameters];
	
	return [self enqueueRequest:request resultClass:nil];
}

- (RACSignal *)unBindBankCard:(NSString *)bankCardID AndTradePwd:(NSString *)pwd {
	NSMutableDictionary *parameters = NSMutableDictionary.dictionary;
	parameters[@"uniqueId"] = self.user.objectID;
	parameters[@"transPassword"] = pwd;
	parameters[@"bankCardId"] = bankCardID;
	
	NSMutableURLRequest *request = [self requestWithMethod:@"POST" path:@"bankcard/unbind" parameters:parameters];
	
	return [self enqueueRequest:request resultClass:nil];
}

- (RACSignal *)drawCashWithDrawCount:(NSString *)count AndContraceNO :(NSString *)contractNO AndPwd:(NSString *)pwd AndType:(int)type {
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	parameters[@"drawingAmount"] = count;
	parameters[@"contractNo"] = contractNO;
	parameters[@"uniqueId"] = self.user.objectID;
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
		@"uniqueId": self.user.uniqueId?:@"",
		@"newTransPassword": pwd?:@"",
		@"smsCode": capthch?:@""
	}];
	return [self enqueueRequest:request resultClass:nil];
}

- (RACSignal *)updateTradePwdWitholdPwd:(NSString *)oldpwd AndNewPwd:(NSString *)pwd AndCaptch:(NSString *)captch {
	NSMutableURLRequest *request = [self requestWithMethod:@"POST" path:@"transPassword/updatePassword" parameters:@{
		@"uniqueId": self.user.objectID,
		@"newTransPassword": pwd?:@"",
		@"smsCode": captch?:@"",
		@"oldTransPassword": oldpwd?:@""
	}];
	return [self enqueueRequest:request resultClass:nil];
}

- (RACSignal *)resetTradepwdWithBankCardNo:(NSString *)bankCardNO AndprovinceCode:(NSString *)provinceCode AndcityCode:(NSString *)cityCode AndsmsCode:(NSString *)smsCode AndnewTransPassword:(NSString *)newTransPassword {
	NSMutableURLRequest *request = [self requestWithMethod:@"POST" path:@"transPassword/forgetPassword" parameters:@{
		@"uniqueId": self.user.objectID,
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
	return [[self enqueueRequest:request resultClass:MSFPaymentToken.class] msf_parsedResults];
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

- (RACSignal *)drawingsWithAmounts:(NSString *)amounts contractNo:(NSString *)contractNo passcode:(NSString *)passcode bankCardID:(NSString *)bankCardID {
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	parameters[@"drawingAmount"] = amounts;
	parameters[@"contractNo"] = contractNo;
	parameters[@"dealPwd"] = passcode;
	parameters[@"dealPwd"] = bankCardID?:@"";
	
	NSURLRequest *request = [self requestWithMethod:@"POST" path:@"pay/drawings" parameters:parameters];
	
	return [self enqueueRequest:request resultClass:nil];
}

- (RACSignal *)fetchUserInfo {
	NSURLRequest *request = [self requestWithMethod:@"GET" path:@"user/getInfo" parameters:nil];
	return [[self enqueueRequest:request resultClass:MSFUser.class] msf_parsedResults];
}

- (RACSignal *)updateUserInfo {
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	parameters[@"baseInfo"] = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:[MTLJSONAdapter JSONDictionaryFromModel:self.user.personal] options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
	parameters[@"occupationInfo"] = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:[MTLJSONAdapter JSONDictionaryFromModel:self.user.professional] options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
	parameters[@"additionalList"] = self.user.profiles ? [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:[MTLJSONAdapter JSONArrayFromModels:self.user.profiles] options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding] : [NSNull null];
	parameters[@"contrastList"] = self.user.contacts ? [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:[MTLJSONAdapter JSONArrayFromModels:self.user.contacts] options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding] : [NSNull null];
	parameters[@"custSocialSecurity"] = self.user.insurance ? [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:[MTLJSONAdapter JSONDictionaryFromModel:self.user.insurance] options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding] : [NSNull null];
	parameters[@"infoType"] = @"1";
	
	NSLog(@"%@", parameters.description);
	NSURLRequest *request = [self requestWithMethod:@"POST" path:@"user/saveInfo" parameters:parameters];
	return [self enqueueRequest:request resultClass:nil];
}

- (RACSignal *)updateUser:(MSFUser *)user {
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	parameters[@"baseInfo"] = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:[MTLJSONAdapter JSONDictionaryFromModel:user.personal] options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
	parameters[@"occupationInfo"] = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:[MTLJSONAdapter JSONDictionaryFromModel:user.professional] options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
	parameters[@"additionalList"] = user.profiles ? [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:[MTLJSONAdapter JSONArrayFromModels:user.profiles] options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding] : @"[]";
	parameters[@"contactList"] = user.contacts ? [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:[MTLJSONAdapter JSONArrayFromModels:user.contacts] options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding] : @"[]";
	parameters[@"custSocialSecurity"] = user.insurance ? [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:[MTLJSONAdapter JSONDictionaryFromModel:user.insurance] options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding] : @"{}";
	parameters[@"infoType"] = user.applyType?:@"1";
	
	NSLog(@"%@", parameters.description);
	NSURLRequest *request = [self requestWithMethod:@"POST" path:@"user/saveInfo" parameters:parameters];
	return [self enqueueRequest:request resultClass:nil];
}

@end
