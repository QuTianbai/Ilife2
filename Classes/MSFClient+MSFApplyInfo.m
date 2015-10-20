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
	NSArray *additionalList = [dic[@"additionalList"] validArray];
	NSString *qq = @"";
	NSString *tb = @"";
	NSString *jd = @"";
	for (NSDictionary *addition in additionalList) {
		switch ([addition[@"additionalType"] validString].intValue) {
			case 1: qq = [addition[@"additionalValue"] validString]; break;
			case 2: tb = [addition[@"additionalValue"] validString]; break;
			case 3: jd = [addition[@"additionalValue"] validString]; break;
		}
	}
	
	NSDictionary *basicInfo  = [dic[@"baseInfo"] validDictionary];
	NSDictionary *occupation = [dic[@"occupationInfo"] validDictionary];
	
	NSArray *homeTelComponents = [self convertPhoneNumber:
																[basicInfo[@"homePhone"] validString]];
	NSArray *empTelComponents  = [self convertPhoneNumber:
																[occupation[@"empPhone"] validString]];
	NSString *homeTelCode = @"";
	NSString *homeTel			= @"";
	NSString *empTelCode  = @"";
	NSString *empTel			= @"";
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
					 @"email"								: [basicInfo[@"email"]							validString],
					 @"currentProvinceCode" : [basicInfo[@"abodeStateCode"]			validString],
					 @"currentCityCode"			: [basicInfo[@"abodeCityCode"]			validString],
					 @"currentCountryCode"	: [basicInfo[@"abodeZoneCode"]			validString],
					 @"abodeDetail"					: [basicInfo[@"abodeDetail"]				validString],
					 @"houseType"						: [basicInfo[@"houseCondition"]			validString],
					 @"maritalStatus"				: [basicInfo[@"maritalStatus"]			validString],
					 @"qq"									: qq,
					 @"taobao"							: tb,
					 @"jdAccount"						: jd,
					 @"socialStatus"				: [occupation[@"socialIdentity"]		validString],
					 @"education"						: [occupation[@"qualification"]			validString],
					 @"unitName"						: [occupation[@"unitName"]					validString],
					 @"empStandFrom"				: [occupation[@"empStandFrom"]			validString],
					 @"programLength"				: [occupation[@"lengthOfSchooling"] validString],
					 @"workStartDate"				: [occupation[@"workStartDate"]			validString],
					 @"income"							: [occupation[@"monthIncome"]				validString],
					 @"otherIncome"					: [occupation[@"otherIncome"]				validString],
					 @"familyExpense"				: [occupation[@"otherLoan"]					validString],
					 @"department"					: [occupation[@"empDepartment"]			validString],
					 @"title"								: [occupation[@"empPost"]						validString],
					 @"professional"				: [occupation[@"empPost"]						validString],
					 @"industry"						: [occupation[@"empType"]						validString],
					 @"companyType"					: [occupation[@"empStructure"]			validString],
					 @"workProvinceCode"		: [occupation[@"empProvinceCode"]		validString],
					 @"workCityCode"				: [occupation[@"empCityCode"]				validString],
					 @"workCountryCode"			: [occupation[@"empZoneCode"]				validString],
					 @"empAdd"							: [occupation[@"empAddr"]						validString],
					 @"unitAreaCode"				: empTelCode,
					 @"unitTelephone"				: empTel,
					 @"unitExtensionTelephone" : [occupation[@"empPhoneExtNum"] validString],
					 @"contrastList"				: [dic[@"contrastList"]							validArray]};
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
															@"email"					: forms.email.trimmedString,
															@"abodeStateCode" : forms.currentProvinceCode.trimmedString,
															@"abodeCityCode"  : forms.currentCityCode.trimmedString,
															@"abodeZoneCode"  : forms.currentCountryCode.trimmedString,
															@"abodeDetail"		: forms.abodeDetail.trimmedString,
															@"houseCondition" : forms.houseType.trimmedString,
															@"maritalStatus"	: forms.maritalStatus.trimmedString
															};
	NSDictionary *occupation = @{
															 @"socialIdentity": forms.socialStatus.trimmedString,
															 @"qualification" : forms.education.trimmedString,
															 @"unitName"			: forms.unitName.trimmedString,
															 @"empStandFrom"	: forms.empStandFrom.trimmedString,
															 @"lengthOfSchooling" : forms.programLength.trimmedString,
															 @"workStartDate" : forms.workStartDate.trimmedString,
															 @"monthIncome"		: forms.income.trimmedString,
															 @"otherIncome"		: forms.otherIncome.trimmedString,
															 @"otherLoan"			: forms.familyExpense.trimmedString,
															 @"empDepartment" : forms.department.trimmedString,
															 @"empPost"				: forms.professional.trimmedString,
															 @"empType"				: forms.industry.trimmedString,
															 @"empStructure"	: forms.companyType.trimmedString,
															 @"empProvinceCode" : forms.workProvinceCode.trimmedString,
															 @"empCityCode"		: forms.workCityCode.trimmedString,
															 @"empZoneCode"		: forms.workCountryCode.trimmedString,
															 @"empAddr"				: forms.empAdd.trimmedString,
															 @"empPhone"			: empPhone,
															 @"empPhoneExtNum": forms.unitExtensionTelephone.trimmedString};
	
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
