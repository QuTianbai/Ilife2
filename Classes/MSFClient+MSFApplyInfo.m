//
//	MSFClient+MSFApplyInfo.m
//	Cash
//
//	Created by xbm on 15/5/16.
//	Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFClient+MSFApplyInfo.h"
#import "MSFApplicationForms.h"
#import "RACSignal+MSFClientAdditions.h"
#import "MSFResponse.h"
#import "MSFUser.h"
#import "NSDateFormatter+MSFFormattingAdditions.h"

@implementation MSFClient (MSFApplyInfo)

- (RACSignal *)fetchApplyInfo {
	NSMutableURLRequest *request = [self requestWithMethod:@"GET" path:@"cust/getInfo" parameters:@{@"uniqueId" : self.user.objectID}];
	return [[self enqueueRequest:request resultClass:nil] map:^id(MSFResponse *value) {
		NSLog(@"%@", value.parsedResult);
		MSFApplicationForms *forms = [MTLJSONAdapter modelOfClass:MSFApplicationForms.class fromJSONDictionary:[self convertDictionary:value.parsedResult] error:nil];
		return forms;
	}];
}

- (id)msf_filter:(id)obj class:(Class)class {
	if ([obj isKindOfClass:class]) {
		return obj;
	} else {
		if (class == NSString.class) {
			if ([obj isKindOfClass:NSNumber.class]) {
				return [obj stringValue];
			}
			return @"";
		} else if (class == NSArray.class) {
			return @[];
		} else if (class == NSDictionary.class) {
			return @{};
		}
		return nil;
	}
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
	NSArray *additionalList = [self msf_filter:dic[@"additionalList"] class:NSArray.class];
	NSString *qq = @"";
	NSString *tb = @"";
	NSString *jd = @"";
	for (NSDictionary *addition in additionalList) {
		switch ([[self msf_filter:addition[@"additionalType"] class:NSString.class] intValue]) {
			case 1:
				qq = [self msf_filter:addition[@"additionalValue"] class:NSString.class];
				break;
			case 2:
				tb = [self msf_filter:addition[@"additionalValue"] class:NSString.class];
				break;
			case 3:
				jd = [self msf_filter:addition[@"additionalValue"] class:NSString.class];
				break;
		}
	}
	
	NSDictionary *basicInfo = [self msf_filter:dic[@"baseInfo"]
																	 class:NSDictionary.class];
	NSDictionary *occupation = [self msf_filter:dic[@"occupationInfo"]
																		class:NSDictionary.class];
	
	NSArray *homeTelComponents = [self convertPhoneNumber:[self msf_filter:basicInfo[@"homePhone"] class:NSString.class]];
	NSArray *empTelComponents = [self convertPhoneNumber:[self msf_filter:occupation[@"empPhone"] class:NSString.class]];
	NSString *homeTelCode = @"";
	NSString *homeTel = @"";
	NSString *empTelCode = @"";
	NSString *empTel = @"";
	if (homeTelComponents.count == 2) {
		homeTelCode = homeTelComponents[0];
		homeTel = homeTelComponents[1];
	}
	if (empTelComponents.count == 2) {
		empTelCode = empTelComponents[0];
		empTel = empTelComponents[1];
	}
	
	return @{@"homeCode" : homeTelCode,
					 @"homeLine" : homeTel,
					 @"email" : [self msf_filter:basicInfo[@"email"] class:NSString.class],
					 @"currentProvinceCode" : [self msf_filter:basicInfo[@"abodeStateCode"] class:NSString.class],
					 @"currentCityCode" : [self msf_filter:basicInfo[@"abodeCityCode"] class:NSString.class],
					 @"currentCountryCode" : [self msf_filter:basicInfo[@"abodeZoneCode"] class:NSString.class],
					 @"abodeDetail" : [self msf_filter:basicInfo[@"abodeDetail"] class:NSString.class],
					 @"houseType" : [self msf_filter:basicInfo[@"houseCondition"] class:NSString.class],
					 @"maritalStatus" : [self msf_filter:basicInfo[@"maritalStatus"] class:NSString.class],
					 @"qq" : qq,
					 @"taobao" : tb,
					 @"jdAccount" : jd,
					 @"socialStatus" : [self msf_filter:occupation[@"socialIdentity"] class:NSString.class],
					 @"education" : [self msf_filter:occupation[@"qualification"] class:NSString.class],
					 @"unitName" : [self msf_filter:occupation[@"unitName"] class:NSString.class],
					 @"empStandFrom" : [self msf_filter:occupation[@"empStandFrom"] class:NSString.class],
					 @"programLength" : [self msf_filter:occupation[@"lengthOfSchooling"] class:NSString.class],
					 @"workStartDate" : [self msf_filter:occupation[@"workStartDate"] class:NSString.class],
					 @"income" : [self msf_filter:occupation[@"monthIncome"] class:NSString.class],
					 @"otherIncome" : [self msf_filter:occupation[@"otherIncome"] class:NSString.class],
					 @"familyExpense" : [self msf_filter:occupation[@"otherLoan"] class:NSString.class],
					 @"department" : [self msf_filter:occupation[@"empDepartment"] class:NSString.class],
					 @"title" : [self msf_filter:occupation[@"empPost"] class:NSString.class],
					 @"professional" : [self msf_filter:occupation[@"empPost"] class:NSString.class],
					 @"industry" : [self msf_filter:occupation[@"empType"] class:NSString.class],
					 @"companyType" : [self msf_filter:occupation[@"empStructure"] class:NSString.class],
					 @"workProvinceCode" : [self msf_filter:occupation[@"empProvinceCode"] class:NSString.class],
					 @"workCityCode" : [self msf_filter:occupation[@"empCityCode"] class:NSString.class],
					 @"workCountryCode" : [self msf_filter:occupation[@"empZoneCode"] class:NSString.class],
					 @"empAdd" : [self msf_filter:occupation[@"empAddr"] class:NSString.class],
					 @"unitAreaCode" : empTelCode,
					 @"unitTelephone" : empTel,
					 @"unitExtensionTelephone" : [self msf_filter:occupation[@"empPhoneExtNum"] class:NSString.class],
					 @"contrastList" : [self msf_filter:dic[@"contrastList"] class:NSArray.class]
					 };
}

- (NSDictionary *)convertToSubmit:(MSFApplicationForms *)forms {
	NSString *homePhone = @"";
	NSString *empPhone = @"";
	if (forms.homeLine.length > 0 && forms.homeCode.length > 0) {
		homePhone = [NSString stringWithFormat:@"%@%@", forms.homeCode, forms.homeLine];
	}
	if (forms.unitAreaCode.length > 0 && forms.unitTelephone.length > 0) {
		empPhone = [NSString stringWithFormat:@"%@%@", forms.unitAreaCode, forms.unitTelephone];
	}
	
	NSDictionary *basicInfo = @{
															@"homePhone" : homePhone,
															@"email" : forms.email ?: @"",
															@"abodeStateCode" : forms.currentProvinceCode ?: @"",
															@"abodeCityCode" : forms.currentCityCode ?: @"",
															@"abodeZoneCode" : forms.currentCountryCode ?: @"",
															@"abodeDetail" : forms.abodeDetail ?: @"",
															@"houseCondition" : forms.houseType ?: @"",
															@"maritalStatus" : forms.maritalStatus ?: @""
															};
	NSDictionary *occupation = @{
															 @"socialIdentity" : forms.socialStatus ?: @"",
															 @"qualification" : forms.education ?: @"",
															 @"unitName" : forms.unitName ?: @"",
															 @"empStandFrom" : forms.empStandFrom ?: @"",
															 @"lengthOfSchooling" : forms.programLength ?: @"",
															 @"workStartDate" : forms.workStartDate ?: @"",
															 @"monthIncome" : forms.income ?: @"",
															 @"otherIncome" : forms.otherIncome ?: @"",
															 @"otherLoan" : forms.familyExpense ?: @"",
															 @"empDepartment" : forms.department ?: @"",
															 @"empPost" : forms.professional ?: @"",
															 @"empType" : forms.industry ?: @"",
															 @"empStructure" : forms.companyType ?: @"",
															 @"empProvinceCode" : forms.workProvinceCode ?: @"",
															 @"empCityCode" : forms.workCityCode ?: @"",
															 @"empZoneCode" : forms.workCountryCode ?: @"",
															 @"empAddr" : forms.empAdd ?: @"",
															 @"empPhone" : empPhone,
															 @"empPhoneExtNum" : forms.unitExtensionTelephone ?: @""
															 };
	
	NSMutableArray *additionalList = [NSMutableArray array];
	if (forms.qq.length > 0) {
		[additionalList addObject:@{@"additionalType" : @"1",
																@"additionalValue" : forms.qq}];
	}
	if (forms.taobao.length > 0) {
		[additionalList addObject:@{@"additionalType" : @"2",
																@"additionalValue" : forms.taobao}];
	}
	if (forms.jdAccount.length > 0) {
		[additionalList addObject:@{@"additionalType" : @"3",
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
	
	return @{@"baseInfo" : jsonBasicInfo,
					 @"occupationInfo" : jsonOccupation,
					 @"contrastList" : jsonContrastList,
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
