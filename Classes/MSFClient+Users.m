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

@implementation MSFClient (Users)

- (RACSignal *)fetchUserInfo {
	return [[self enqueueUserRequestWithMethod:@"GET" relativePath:@"/profile" parameters:nil resultClass:MSFUser.class] msf_parsedResults];
}

- (RACSignal *)resetPassword:(NSString *)password phone:(NSString *)phone captcha:(NSString *)captcha {
	NSMutableDictionary *parameters = NSMutableDictionary.dictionary;
	parameters[@"phoneNumber"] = phone;
	parameters[@"password"] = password.sha256;
	parameters[@"captcha"] = captcha;
	NSMutableURLRequest *request = [self requestWithMethod:@"PUT" path:@"users/forget_password" parameters:parameters];
	
	return [self enqueueRequest:request resultClass:nil];
}

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

- (RACSignal *)updateUserAvatarWithFileURL:(NSURL *)URL {
	NSString *path = [NSString stringWithFormat:@"users/%@/update_avatar", self.user.objectID];
	NSMutableURLRequest *request =
	[self requestWithMethod:@"PUT" path:path parameters:nil
		constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
			NSString *fileName = [URL lastPathComponent];
			NSString *mimeType = @"image/*";
			[formData appendPartWithFileData:[NSData dataWithContentsOfURL:URL] name:@"image" fileName:fileName mimeType:mimeType];
	}];
	
	return [[self enqueueRequest:request resultClass:MSFUser.class] msf_parsedResults];
}

- (RACSignal *)identityVerificationUsername:(NSString *)name idcard:(NSString *)idcard expire:(NSDate *)date session:(BOOL)session {
	NSMutableDictionary *parameters = NSMutableDictionary.dictionary;
	parameters[@"username"] = name;
	parameters[@"id_card"] = idcard;
	parameters[@"expire"] = [NSDateFormatter msf_stringFromDate:date];;
	parameters[@"valid_for_lifetime"] = @(session);
	NSString *path = [NSString stringWithFormat:@"users/%@%@", self.user.objectID, @"/real_name_auth"];;
	NSMutableURLRequest *request = [self requestWithMethod:@"GET" path:path parameters:parameters];
	[request setHTTPMethod:@"POST"];
	
	return [[self enqueueRequest:request resultClass:MSFUser.class] msf_parsedResults];
}

- (RACSignal *)associateUserPasscard:(NSString *)card bank:(NSString *)bank country:(NSString *)country province:(NSString *)province city:(NSString *)city address:(NSString *)address {
	NSMutableDictionary *parameters = NSMutableDictionary.dictionary;
	parameters[@"bank_name"] = bank;
	parameters[@"bank_card_number"] = card;
	parameters[@"province_code"] = province;
	parameters[@"city_code"] = city;
	parameters[@"county_code"] = country;
	parameters[@"detail_address"] = address;
	
	return [[self enqueueUserRequestWithMethod:@"POST" relativePath:@"/bind_bank_card" parameters:parameters resultClass:MSFUser.class] msf_parsedResults];
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

- (RACSignal *)checkUserHasCredit {
	return [self enqueueUserRequestWithMethod:@"GET" relativePath:@"/processing" parameters:nil resultClass:nil];
}

- (RACSignal *)checkUserIsEmployee {
	return [self enqueueUserRequestWithMethod:@"GET" relativePath:@"/check_employee" parameters:nil resultClass:nil];
}

- (RACSignal *)addBankCardWithTransPassword:(NSString *)transPassword AndBankCardNo:(NSString *)bankCardNo AndbankBranchProvinceCode:(NSString *)bankBranchProvinceCode AndbankBranchCityCode:(NSString *)bankBranchCityCode {
	NSMutableDictionary *parameters = NSMutableDictionary.dictionary;
	parameters[@"uniqueId"] = self.user.uniqueId;
	parameters[@"transPassword"] = transPassword;
	parameters[@"bankCardNo"] = bankCardNo;
	parameters[@"bankBranchProvinceCode"] = bankBranchProvinceCode;
	parameters[@"bankBranchCityCode"] = bankBranchCityCode;
	
	//NSString *path = [NSString stringWithFormat:@"users/%@%@", self.user.objectID, @"/real_name_auth"];;
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
	parameters[@"uniqueId"] = @"645c9b2289904836a8eb42276d444481";
	parameters[@"dealPwd"] = pwd?:@"";
	NSString *path = @"loan/drawings";
	if (type == 1) {
		path = @"loan/repay";
		parameters[@"money"] = count;
	}
	
	NSMutableURLRequest *request = [self requestWithMethod:@"POST" path:path parameters:parameters];
	
	return [self enqueueRequest:request resultClass:nil];
	
}

- (RACSignal *)setTradePwdWithPWD:(NSString *)pwd AndCaptch:(NSString *)capthch {
	NSMutableURLRequest *request = [self requestWithMethod:@"POST" path:@"transPassword/set" parameters:@{@"uniqueId":self.user.uniqueId, @"newTransPassword":pwd?:@"", @"smsCode":capthch?:@""}];
	return [self enqueueRequest:request resultClass:nil];
}

- (RACSignal *)updateTradePwdWitholdPwd:(NSString *)oldpwd AndNewPwd:(NSString *)pwd AndCaptch:(NSString *)captch {
	NSMutableURLRequest *request = [self requestWithMethod:@"POST" path:@"transPassword/updatePassword" parameters:@{@"uniqueId":self.user.uniqueId, @"newTransPassword":pwd?:@"", @"smsCode":captch?:@"", @"oldTransPassword":oldpwd?:@""}];
	return [self enqueueRequest:request resultClass:nil];
}

- (RACSignal *)resetTradepwdWithBankCardNo:(NSString *)bankCardNO AndprovinceCode:(NSString *)provinceCode AndcityCode:(NSString *)cityCode AndsmsCode:(NSString *)smsCode AndnewTransPassword:(NSString *)newTransPassword {
	NSMutableURLRequest *request = [self requestWithMethod:@"POST" path:@"transPassword/forgetPassword" parameters:@{@"uniqueId":self.user.uniqueId, @"newTransPassword":newTransPassword?:@"", @"smsCode":smsCode?:@"", @"bankCardNo":bankCardNO?:@"", @"provinceCode":provinceCode?:@"", @"cityCode":cityCode?:@""}];
	return [self enqueueRequest:request resultClass:nil];
}

@end
