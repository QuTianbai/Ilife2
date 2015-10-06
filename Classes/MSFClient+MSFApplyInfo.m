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

@implementation MSFClient (MSFApplyInfo)

- (RACSignal *)fetchApplyInfo {
	//NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"userInfoApply" ofType:@"json"]]];
	//NSMutableURLRequest *request =
	NSMutableURLRequest *request = [self requestWithMethod:@"GET" path:@"cust/getInfo" parameters:nil];
	//[request setValue:self.user.objectID forHTTPHeaderField:@"uniqueId"];
	return [[self enqueueRequest:request resultClass:nil] map:^id(MSFResponse *value) {
		NSLog(@"%@", value.parsedResult);
		MSFApplicationForms *forms = [MTLJSONAdapter modelOfClass:MSFApplicationForms.class fromJSONDictionary:[self convertDictionary:value.parsedResult] error:nil];
		return forms;
	}];
}

- (id)filter:(id)obj class:(Class)class {
	if ([obj isKindOfClass:class]) {
		return obj;
	} else {
		if (class == NSString.class) {
			return @"";
		} else if (class == NSArray.class) {
			return @[];
		} else if (class == NSDictionary.class) {
			return @{};
		}
		return nil;
	}
}

- (NSDictionary *)convertDictionary:(NSDictionary *)dic {
	
	NSArray *additionalList = [self filter:dic[@"additionalList"] class:NSArray.class];
	NSString *qq = @"";
	NSString *tb = @"";
	NSString *jd = @"";
	for (NSDictionary *addition in additionalList) {
		switch ([[self filter:addition[@"additionalType"] class:NSString.class] intValue]) {
			case 0:
				qq = [self filter:addition[@"additionalValue"] class:NSString.class];
				break;
			case 1:
				tb = [self filter:addition[@"additionalValue"] class:NSString.class];
				break;
			case 2:
				jd = [self filter:addition[@"additionalValue"] class:NSString.class];
				break;
		}
	}
	
	NSDictionary *basicInfo = [self filter:dic[@"baseInfo"]
																	 class:NSDictionary.class];
	NSDictionary *occupation = [self filter:dic[@"occupationInfo"]
																		class:NSDictionary.class];
	
	NSString *homeTelFull = [self filter:basicInfo[@"homePhone"] class:NSString.class];
	NSString *empTelFull  = [self filter:occupation[@"empPhone"] class:NSString.class];
	NSArray *homeTelComponents = [homeTelFull componentsSeparatedByString:@"-"];
	NSArray *empTelComponents = [empTelFull componentsSeparatedByString:@"-"];
	NSString *homeTelCode = @"";
	NSString *homeTel = @"";
	NSString *empTelCode = @"";
	NSString *empTel = @"";
	NSString *empTelExtension = @"";
	if (homeTelComponents.count == 2) {
		homeTelCode = homeTelComponents[0];
		homeTel = homeTelComponents[1];
	}
	if (empTelComponents.count == 3) {
		empTelCode = empTelComponents[0];
		empTel = empTelComponents[1];
		empTelExtension = empTelComponents[2];
	}
	
	return @{@"homeCode" : homeTelCode,
					 @"homeLine" : homeTel,
					 @"email" : [self filter:basicInfo[@"email"] class:NSString.class],
					 @"currentProvinceCode" : [self filter:basicInfo[@"abodeStateCode"] class:NSString.class],
					 @"currentCityCode" : [self filter:basicInfo[@"abodeCityCode"] class:NSString.class],
					 @"currentCountryCode" : [self filter:basicInfo[@"abodeZoneCode"] class:NSString.class],
					 @"abodeDetail" : [self filter:basicInfo[@"abodeDetail"] class:NSString.class],
					 @"houseType" : [self filter:basicInfo[@"houseCondition"] class:NSString.class],
					 @"maritalStatus" : [self filter:basicInfo[@"maritalStatus"] class:NSString.class],
					 @"qq" : qq,
					 @"taobao" : tb,
					 @"jdAccount" : jd,
					 @"socialStatus" : [self filter:occupation[@"socialIdentity"] class:NSString.class],
					 @"education" : [self filter:occupation[@"qualification"] class:NSString.class],
					 @"unitName" : [self filter:occupation[@"unitName"] class:NSString.class],
					 @"empStandFrom" : [self filter:occupation[@"empStandFrom"] class:NSString.class],
					 @"programLength" : [self filter:occupation[@"lengthOfSchooling"] class:NSString.class],
					 @"workStartDate" : [self filter:occupation[@"workStartDate"] class:NSString.class],
					 @"income" : [self filter:occupation[@"monthIncome"] class:NSString.class],
					 @"otherIncome" : [self filter:occupation[@"otherIncome"] class:NSString.class],
					 @"familyExpense" : [self filter:occupation[@"otherLoan"] class:NSString.class],
					 @"department" : [self filter:occupation[@"empDepapment"] class:NSString.class],
					 @"title" : [self filter:occupation[@"empPost"] class:NSString.class],
					 @"industry" : [self filter:occupation[@"empType"] class:NSString.class],
					 @"companyType" : [self filter:occupation[@"empStructure"] class:NSString.class],
					 @"workProvinceCode" : [self filter:occupation[@"empProvinceCode"] class:NSString.class],
					 @"workCityCode" : [self filter:occupation[@"empCityCode"] class:NSString.class],
					 @"workCountryCode" : [self filter:occupation[@"empZoneCode"] class:NSString.class],
					 @"empAdd" : [self filter:occupation[@"empAdd"] class:NSString.class],
					 @"unitAreaCode" : empTelCode,
					 @"unitTelephone" : empTel,
					 @"unitExtensionTelephone" : empTelExtension,
					 @"contrastList" : [self filter:dic[@"contrastList"] class:NSArray.class]};
}

- (NSDictionary *)convertToSubmit:(MSFApplicationForms *)forms {
	NSString *homePhone = @"";
	NSString *empPhone = @"";
	if (forms.homeLine.length > 0 && forms.homeCode.length > 0) {
		homePhone = [NSString stringWithFormat:@"%@-%@", forms.homeCode, forms.homeLine];
	}
	if (forms.unitAreaCode.length > 0 && forms.unitTelephone.length > 0 && forms.unitExtensionTelephone.length > 0) {
		empPhone = [NSString stringWithFormat:@"%@-%@-%@", forms.unitAreaCode, forms.unitTelephone, forms.unitExtensionTelephone];
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
															 @"empDepapment" : forms.department ?: @"",
															 @"empPost" : forms.title ?: @"",
															 @"empType" : forms.industry ?: @"",
															 @"empStructure" : forms.companyType ?: @"",
															 @"empProvinceCode" : forms.workProvinceCode ?: @"",
															 @"empCityCode" : forms.workCityCode ?: @"",
															 @"empZoneCode" : forms.workCountryCode ?: @"",
															 @"empAdd" : forms.empAdd ?: @"",
															 @"empPhone" : empPhone
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
