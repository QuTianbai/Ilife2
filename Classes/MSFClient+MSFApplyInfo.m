//
//	MSFClient+MSFApplyInfo.m
//	Cash
//
//	Created by xbm on 15/5/16.
//	Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFClient+MSFApplyInfo.h"
#import "MSFApplicationForms.h"
#import "MSFResponse.h"
#import "MSFUser.h"
#import "NSDateFormatter+MSFFormattingAdditions.h"
#import "RACSignal+MSFClientAdditions.h"
#import "NSObject+MSFValidItem.h"

@implementation MSFClient (MSFApplyInfo)

- (RACSignal *)fetchApplyInfo {
	NSMutableURLRequest *request = [self requestWithMethod:@"GET" path:@"cust/getInfo" parameters:@{@"uniqueId" : self.user.objectID}];
	return [[self enqueueRequest:request resultClass:nil] map:^id(MSFResponse *value) {
		NSLog(@"%@", value.parsedResult);
		MSFApplicationForms *forms = [MTLJSONAdapter modelOfClass:MSFApplicationForms.class fromJSONDictionary:[self convertDictionary:value.parsedResult] error:nil];
		return forms;
	}];
}

- (NSArray *)convertPhoneNumber:(NSString *)phoneNumber {
	NSArray *numbers = @[@"010", @"020", @"021" ,@"022" ,@"023" ,@"024" ,@"025" ,@"027" ,@"028", @"029"];
	if (phoneNumber.length < 4) {
		return nil;
	}
	if ([numbers containsObject:[phoneNumber substringToIndex:2]]) {
		return @[[phoneNumber substringToIndex:2], [phoneNumber substringFromIndex:2]];
	}
	return @[[phoneNumber substringToIndex:3], [phoneNumber substringFromIndex:3]];
}

- (NSDictionary *)convertDictionary:(NSDictionary *)dic {
	if (!dic) {
		return nil;
	}
	
	NSArray *additionalList = [dic arrayForKey:@"additionalList"];
	NSString *qq = @"";
	NSString *tb = @"";
	NSString *jd = @"";
	for (NSDictionary *addition in additionalList) {
		switch ([addition stringForKey:@"additionalType"].intValue) {
			case 1: qq = [addition stringForKey:@"additionalValue"]; break;
			case 2: tb = [addition stringForKey:@"additionalValue"]; break;
			case 3: jd = [addition stringForKey:@"additionalValue"]; break;
		}
	}
	
	NSDictionary *basicInfo  = [dic dictionaryForKey:@"baseInfo"];
	NSDictionary *occupation = [dic dictionaryForKey:@"occupationInfo"];
	
	NSArray *homeTelComponents = [self convertPhoneNumber:[basicInfo stringForKey:@"homePhone"]];
	NSArray *empTelComponents  = [self convertPhoneNumber:[occupation stringForKey:@"empPhone"]];
	NSString *homeTelCode = @"";
	NSString *homeTel = @"";
	NSString *empTelCode = @"";
	NSString *empTel = @"";
	if (homeTelComponents.count == 2) {
		homeTelCode = homeTelComponents[0];
		homeTel		  = homeTelComponents[1];
	}
	if (empTelComponents.count == 2) {
		empTelCode  = empTelComponents[0];
		empTel	    = empTelComponents[1];
	}
	
	return @{@"homeCode"						: homeTelCode,
					 @"homeLine"						: homeTel,
					 @"email"								: [basicInfo stringForKey:@"email"],
					 @"currentProvinceCode" : [basicInfo stringForKey:@"abodeStateCode"],
					 @"currentCityCode"			: [basicInfo stringForKey:@"abodeCityCode"],
					 @"currentCountryCode"	: [basicInfo stringForKey:@"abodeZoneCode"],
					 @"abodeDetail"					: [basicInfo stringForKey:@"abodeDetail"],
					 @"houseType"						: [basicInfo stringForKey:@"houseCondition"],
					 @"maritalStatus"				: [basicInfo stringForKey:@"maritalStatus"],
					 @"qq"									: qq,
					 @"taobao"							: tb,
					 @"jdAccount"						: jd,
					 @"socialStatus"				: [occupation stringForKey:@"socialIdentity"],
					 @"education"						: [occupation stringForKey:@"qualification"],
					 @"unitName"						: [occupation stringForKey:@"unitName"],
					 @"empStandFrom"				: [occupation stringForKey:@"empStandFrom"],
					 @"programLength"				: [occupation stringForKey:@"lengthOfSchooling"],
					 @"workStartDate"				: [occupation stringForKey:@"workStartDate"],
					 @"income"							: [occupation stringForKey:@"monthIncome"],
					 @"otherIncome"					: [occupation stringForKey:@"otherIncome"],
					 @"familyExpense"				: [occupation stringForKey:@"otherLoan"],
					 @"department"					: [occupation stringForKey:@"empDepartment"],
					 @"professional"				: [occupation stringForKey:@"empPost"],
					 @"industry"						: [occupation stringForKey:@"empType"],
					 @"companyType"					: [occupation stringForKey:@"empStructure"],
					 @"workProvinceCode"		: [occupation stringForKey:@"empProvinceCode"],
					 @"workCityCode"				: [occupation stringForKey:@"empCityCode"],
					 @"workCountryCode"			: [occupation stringForKey:@"empZoneCode"],
					 @"empAdd"							: [occupation stringForKey:@"empAddr"],
					 @"unitAreaCode"				: empTelCode,
					 @"unitTelephone"				: empTel,
					 @"unitExtensionTelephone" : [occupation stringForKey:@"empPhoneExtNum"],
					 @"contrastList"				: [dic arrayForKey:@"contrastList"]};
}

- (NSDictionary *)convertToSubmit:(MSFApplicationForms *)forms {
	NSString *homePhone = @"";
	NSString *empPhone  = @"";
	if (forms.homeLine.length > 0 && forms.homeCode.length > 0) {
		homePhone = [NSString stringWithFormat:@"%@%@", forms.homeCode, forms.homeLine];
	}
	if (forms.unitAreaCode.length > 0 && forms.unitTelephone.length > 0) {
		empPhone  = [NSString stringWithFormat:@"%@%@", forms.unitAreaCode, forms.unitTelephone];
	}
	
	NSDictionary *basicInfo = @{@"homePhone"			: homePhone,
															@"email"					: [self trimString:forms.email],
															@"abodeStateCode" : [self trimString:forms.currentProvinceCode],
															@"abodeCityCode"  : [self trimString:forms.currentCityCode],
															@"abodeZoneCode"  : [self trimString:forms.currentCountryCode],
															@"abodeDetail"		: [self trimString:forms.abodeDetail],
															@"houseCondition" : [self trimString:forms.houseType],
															@"maritalStatus"	: [self trimString:forms.maritalStatus]
															};
	NSDictionary *occupation = @{
															 @"socialIdentity": [self trimString:forms.socialStatus],
															 @"qualification" : [self trimString:forms.education],
															 @"unitName"			: [self trimString:forms.unitName],
															 @"empStandFrom"	: [self trimString:forms.empStandFrom],
															 @"lengthOfSchooling" : [self trimString:forms.programLength],
															 @"workStartDate" : [self trimString:forms.workStartDate],
															 @"monthIncome"		: [self trimString:forms.income],
															 @"otherIncome"		: [self trimString:forms.otherIncome],
															 @"otherLoan"			: [self trimString:forms.familyExpense],
															 @"empDepartment" : [self trimString:forms.department],
															 @"empPost"				: [self trimString:forms.professional],
															 @"empType"				: [self trimString:forms.industry],
															 @"empStructure"	: [self trimString:forms.companyType],
															 @"empProvinceCode" : [self trimString:forms.workProvinceCode],
															 @"empCityCode"		: [self trimString:forms.workCityCode],
															 @"empZoneCode"		: [self trimString:forms.workCountryCode],
															 @"empAddr"				: [self trimString:forms.empAdd],
															 @"empPhone"			: empPhone,
															 @"empPhoneExtNum": [self trimString:forms.unitExtensionTelephone]};
	
	NSMutableArray *additionalList = [NSMutableArray array];
	if (forms.qq.length > 0) {
		[additionalList addObject:@{@"additionalType"  : @"1",
																@"additionalValue" : forms.qq}];
	}
	if (forms.taobao.length > 0) {
		[additionalList addObject:@{@"additionalType"  : @"2",
																@"additionalValue" : forms.taobao}];
	}
	if (forms.jdAccount.length > 0) {
		[additionalList addObject:@{@"additionalType"  : @"3",
																@"additionalValue" : forms.jdAccount}];
	}
	
	NSArray *contrastList = @[];
	if (forms.contrastList.count > 0) {
		contrastList = [MTLJSONAdapter JSONArrayFromModels:forms.contrastList];
	}
	
	NSString *jsonBasicInfo = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:basicInfo options:kNilOptions error:nil] encoding:NSUTF8StringEncoding];
	NSString *jsonOccupation = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:occupation options:kNilOptions error:nil] encoding:NSUTF8StringEncoding];
	NSString *jsonContrastList = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:contrastList options:kNilOptions error:nil] encoding:NSUTF8StringEncoding];
	NSString *jsonAdditionalList = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:additionalList options:kNilOptions error:nil] encoding:NSUTF8StringEncoding];
	
	return @{@"baseInfo"			 : jsonBasicInfo,
					 @"occupationInfo" : jsonOccupation,
					 @"contrastList"   : jsonContrastList,
					 @"additionalList" : jsonAdditionalList};
}

- (RACSignal *)fetchApplyInfoSubmit1:(NSString *)moneyNum months:(NSString *)months moneyUsed:(NSString *)moneyUsed isInsurancePlane:(NSString *)InsurancePlane applyStatus:(NSString *)status loanID:(NSString *)loanID {
	return nil;
}

- (RACSignal *)submitUserInfo:(MSFApplicationForms *)model infoType:(int)type {
	NSMutableDictionary *uploadDic = [NSMutableDictionary dictionaryWithDictionary:[self convertToSubmit:model]];
	[uploadDic setObject:self.user.uniqueId forKey:@"uniqueId"];
	[uploadDic setObject:@(type) forKey:@"infoType"];
	NSMutableURLRequest *request = [self requestWithMethod:@"POST" path:@"cust/saveInfo" parameters:uploadDic];
	return [[self enqueueRequest:request resultClass:nil] map:^id(MSFResponse *value) {
		NSLog(@"%@", value.parsedResult);
		self.user.complateCustInfo = value.parsedResult[@"complateCustInfo"];
		return value.parsedResult[@"complateCustInfo"];
	}];
}

@end
