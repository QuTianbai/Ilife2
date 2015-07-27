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

- (RACSignal *)updateUserPassword:(NSString *)oldpassword password:(NSString *)newpassword {
	return [self enqueueUserRequestWithMethod:@"PUT" relativePath:@"/update_password" parameters:@{@"password": oldpassword.sha256, @"new_password": newpassword.sha256} resultClass:nil];
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

- (RACSignal *)checkUserHasCredit {
	return [self enqueueUserRequestWithMethod:@"GET" relativePath:@"/processing" parameters:nil resultClass:nil];
}

- (RACSignal *)checkUserIsEmployee {
	return [self enqueueUserRequestWithMethod:@"GET" relativePath:@"/check_employee" parameters:nil resultClass:nil];
}

@end
