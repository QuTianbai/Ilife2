//
// MSFAlertViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFAlertViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Mantle/EXTScope.h>
#import "MSFUser.h"
#import "MSFSelectKeyValues.h"

#import "MSFApplyCashViewModel.h"

@interface MSFAlertViewModel ()

@property (nonatomic, strong, readwrite) RACSubject *buttonClickedSignal;

@end

@implementation MSFAlertViewModel

- (instancetype)initWithFormsViewModel:(MSFApplyCashViewModel *)cashViewModel user:(MSFUser *)user {
  self = [super init];
  if (!self) {
    return nil;
  }
	self.buttonClickedSignal = [[RACSubject subject] setNameWithFormat:@"MSFAlertViewModel `buttonClickedSignal`"];
	_terms = [NSString stringWithFormat:@"%@个月", cashViewModel.loanTerm];
		
	NSArray *items = [MSFSelectKeyValues getSelectKeys:@"moneyUse"];
	[items enumerateObjectsUsingBlock:^(MSFSelectKeyValues *obj, NSUInteger idx, BOOL *stop) {
		if ([obj.code isEqualToString:cashViewModel.loanPurpose]) {
			_useage = obj.text;
		}
	}];
	
	_amount = [NSString stringWithFormat:@"%@元", cashViewModel.appLmt];
	_repayment = [NSString stringWithFormat:@"%@元", cashViewModel.loanFixedAmt];
	
	//TODO: 获取银行卡号，并显示
	//RAC(self, bankNumber) = RACObserve(cashViewModel, formViewModel.masterBankCardNO);
	//if (cashViewModel.formViewModel.masterBankCardNO.length == 0) {
	//	cashViewModel.formViewModel.active = NO;
	//	cashViewModel.formViewModel.active = YES;
	//}
	
  return self;
}

@end
