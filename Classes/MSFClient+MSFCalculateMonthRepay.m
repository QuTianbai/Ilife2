//
//  MSFClient+MSFCalculateMonthRepay.m
//  Finance
//
//  Created by xbm on 15/10/2.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFClient+MSFCalculateMonthRepay.h"
#import "MSFCalculatemMonthRepayModel.h"
#import "RACSignal+MSFClientAdditions.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "MSFCommandView.h"
#import "MSFXBMCustomHeader.h"
#import "MSFUtils.h"

@implementation MSFClient (MSFCalculateMonthRepay)

- (RACSignal *)fetchCalculateMonthRepayWithAppLmt:(NSString *)appLmt AndLoanTerm:(NSString *)loanTerm AndProductCode:(NSString *)productCode AndJionLifeInsurance:(NSString *)jionLifeInsurance {
	[SVProgressHUD setBackgroundColor:[UIColor clearColor]];
	[SVProgressHUD setOffsetFromCenter:UIOffsetMake(0, 130)];
	[SVProgressHUD setForegroundColor:[MSFCommandView getColorWithString:POINTCOLOR]];
	[SVProgressHUD showWithStatus:@""];
	//NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"repay" ofType:@"json"]]];
	
	NSURLRequest *request = [self requestWithMethod:@"POST" path:@"loan/count" parameters:@{@"appLmt": appLmt?:@"", @"loanTerm": loanTerm, @"productCode": productCode, @"jionLifeInsurance": @"0"?:@"", @"uniqueId":MSFUtils.uniqueId}];

	return [[self enqueueRequest:request resultClass:MSFCalculatemMonthRepayModel.class] msf_parsedResults];
}

@end
