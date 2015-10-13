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
#import "MSFUser.h"

@implementation MSFClient (MSFCalculateMonthRepay)

- (RACSignal *)fetchCalculateMonthRepayWithAppLmt:(NSString *)appLmt AndLoanTerm:(NSString *)loanTerm AndProductCode:(NSString *)productCode AndJionLifeInsurance:(NSString *)jionLifeInsurance {
	[SVProgressHUD setBackgroundColor:[UIColor clearColor]];
	[SVProgressHUD setOffsetFromCenter:UIOffsetMake(0, 130)];
	[SVProgressHUD setForegroundColor:[MSFCommandView getColorWithString:POINTCOLOR]];
	[SVProgressHUD showWithStatus:@""];
	
	NSURLRequest *request = [self requestWithMethod:@"POST" path:@"loan/count" parameters:@{
		@"appLmt": appLmt?:@"",
		@"loanTerm": loanTerm,
		@"productCode": productCode,
		@"jionLifeInsurance": jionLifeInsurance.boolValue ? @"1" : @"0",
		@"uniqueId":self.user.uniqueId
	}];

	return [[[self enqueueRequest:request resultClass:MSFCalculatemMonthRepayModel.class]
		msf_parsedResults]
		doError:^(NSError *error) {
			[SVProgressHUD setBackgroundColor:[UIColor colorWithHue:0 saturation:0 brightness:0.95 alpha:0.8]];
			[SVProgressHUD setForegroundColor:[UIColor blackColor]];
			[SVProgressHUD resetOffsetFromCenter];
		}];
}

@end
