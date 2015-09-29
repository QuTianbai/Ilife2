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
	NSURLRequest *request = [self requestWithMethod:@"GET" path:@"cust/getInfo" parameters:nil];
	return [[self enqueueRequest:request resultClass:nil] map:^id(MSFResponse *value) {
		NSLog(@"%@", value.parsedResult);
		MSFApplicationForms *forms = [MTLJSONAdapter modelOfClass:MSFApplicationForms.class fromJSONDictionary:[self convert:value.parsedResult] error:nil];
		return forms;
	}];
}

- (NSDictionary *)convert:(NSDictionary *)dic {
	NSDictionary *basicInfo = dic[@"baseInfo"];
	NSDictionary *occupation = dic[@"occupationInfo"];
	return @{
					 @"homeLine" : basicInfo[@"homePhone"],
					 @"email" : basicInfo[@"email"],
					 @"currentProvinceCode" : basicInfo[@"abodeStateCode"],
					 @"currentCityCode" : basicInfo[@"abodeCityCode"],
					 @"currentCountryCode" : basicInfo[@"abodeZoneCode"],
					 @"abodeDetail" : basicInfo[@"abodeDetail"],
					 @"houseType" : basicInfo[@"houseCondition"],
					 @"maritalStatus" : basicInfo[@"maritalStatus"],
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
					 @"empPhone" : occupation[@"empPhone"],
					 @"infoType" : occupation[@"infoType"],
					 @"contrastList" : occupation[@"contrastList"],
					 @"additionalList" : occupation[@"additionalList"]
					 };
}

- (RACSignal *)fetchApplyInfoSubmit1:(NSString *)moneyNum months:(NSString *)months moneyUsed:(NSString *)moneyUsed isInsurancePlane:(NSString *)InsurancePlane applyStatus:(NSString *)status loanID:(NSString *)loanID {
	return nil;
}

@end
