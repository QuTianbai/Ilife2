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

@implementation MSFClient (MSFApplyInfo)

- (RACSignal *)fetchApplyInfo {
	//NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"userInfoApply" ofType:@"json"]]];
	NSURLRequest *request = [self requestWithMethod:@"GET" path:@"cust/getInfo" parameters:nil];
	return [[self enqueueRequest:request resultClass:nil] map:^id(MSFResponse *value) {
		NSLog(@"%@", value.parsedResult);
		MSFApplicationForms *forms = [MTLJSONAdapter modelOfClass:MSFApplicationForms.class fromJSONDictionary:[self convert:value.parsedResult] error:nil];
		return forms;
	}];
}

- (NSDictionary *)convert:(NSDictionary *)dic {
	
	NSArray *additionalList = dic[@"additionalList"];
	NSString *qq = @"";
	NSString *tb = @"";
	NSString *jd = @"";
	for (NSDictionary *addition in additionalList) {
		switch ([addition[@"additionalType"] intValue]) {
			case 0:
				qq = addition[@"additionalValue"];
				break;
			case 1:
				tb = addition[@"additionalValue"];
				break;
			case 2:
				jd = addition[@"additionalValue"];
				break;
		}
	}
	
	NSDictionary *basicInfo = dic[@"baseInfo"];
	NSDictionary *occupation = dic[@"occupationInfo"];
	
	NSString *homeTelFull = basicInfo[@"homePhone"];
	NSString *empTelFull  = occupation[@"empPhone"];
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
	
	return @{
					 @"homeCode" : homeTelCode,
					 @"homeLine" : homeTel,
					 @"email" : basicInfo[@"email"],
					 @"currentProvinceCode" : basicInfo[@"abodeStateCode"],
					 @"currentCityCode" : basicInfo[@"abodeCityCode"],
					 @"currentCountryCode" : basicInfo[@"abodeZoneCode"],
					 @"abodeDetail" : basicInfo[@"abodeDetail"],
					 @"houseType" : basicInfo[@"houseCondition"],
					 @"maritalStatus" : basicInfo[@"maritalStatus"],
					 @"qq" : qq,
					 @"taobao" : tb,
					 @"jdAccount" : jd,
					 @"socialStatus" : occupation[@"socialIdentity"],
					 @"education" : occupation[@"qualification"],
					 @"unitName" : occupation[@"unitName"],
					 @"empStandFrom" : occupation[@"empStandFrom"],
					 @"programLength" : occupation[@"lengthOfSchooling"],
					 @"workStartDate" : occupation[@"workStartDate"],
					 @"income" : occupation[@"monthIncome"],
					 @"otherIncome" : occupation[@"otherIncome"],
					 @"familyExpense" : occupation[@"otherLoan"],
					 @"department" : occupation[@"empDepapment"],
					 @"title" : occupation[@"empPost"],
					 @"industry" : occupation[@"empType"],
					 @"companyType" : occupation[@"empStructure"],
					 @"workProvinceCode" : occupation[@"empProvinceCode"],
					 @"workCityCode" : occupation[@"empCityCode"],
					 @"workCountryCode" : occupation[@"empZoneCode"],
					 @"empAdd" : occupation[@"empAdd"],
					 @"unitAreaCode" : empTelCode,
					 @"unitTelephone" : empTel,
					 @"unitExtensionTelephone" : empTelExtension,
					 @"infoType" : dic[@"infoType"],
					 @"contrastList" : dic[@"contrastList"]
					 };
}

- (NSDictionary *)convertToSubmit:(MSFApplicationForms *)forms {
	int infoType = forms.infoType;
	
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
	
	NSDictionary *dic = @{
												@"infoType" : @(infoType),
												@"baseInfo" : basicInfo,
												@"occupationInfo" : occupation,
												@"contrastList" : contrastList,
												@"additionalList" : additionalList
												};
	
	return dic;
	
}

- (RACSignal *)fetchApplyInfoSubmit1:(NSString *)moneyNum months:(NSString *)months moneyUsed:(NSString *)moneyUsed isInsurancePlane:(NSString *)InsurancePlane applyStatus:(NSString *)status loanID:(NSString *)loanID {
	return nil;
}

- (RACSignal *)submitUserInfo:(MSFApplicationForms *)model {
	
//	NSData *jsonData = [NSJSONSerialization dataWithJSONObject:uploadDic options:NSJSONWritingPrettyPrinted error:nil];
//	NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//	NSDictionary *paramDict = [NSDictionary dictionaryWithObject:jsonStr forKey:@"loans"];
	NSDictionary *uploadDic = [self convertToSubmit:model];
	NSMutableURLRequest *request = [self requestWithMethod:@"POST" path:@"cust/saveInfo" parameters:uploadDic];	
	return [[self enqueueRequest:request resultClass:nil] map:^id(id value) {
		NSLog(@"%@", value);
		return value;
	}];
}

@end
