//
// MSFAlertViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFAlertViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/extobjc.h>
#import "MSFFormsViewModel.h"
#import "MSFUser.h"
#import "MSFApplicationForms.h"
#import "MSFSelectKeyValues.h"

@interface MSFAlertViewModel ()

@property (nonatomic, strong, readwrite) RACSubject *buttonClickedSignal;

@end

@implementation MSFAlertViewModel

- (instancetype)initWithFormsViewModel:(MSFFormsViewModel *)formsViewModel user:(MSFUser *)user {
  self = [super init];
  if (!self) {
    return nil;
  }
	self.buttonClickedSignal = [[RACSubject subject] setNameWithFormat:@"MSFAlertViewModel `buttonClickedSignal`"];
	_terms = [NSString stringWithFormat:@"%@个月", formsViewModel.model.tenor];
		
	NSArray *items = [MSFSelectKeyValues getSelectKeys:@"moneyUse"];
	[items enumerateObjectsUsingBlock:^(MSFSelectKeyValues *obj, NSUInteger idx, BOOL *stop) {
		if ([obj.code isEqualToString:formsViewModel.model.usageCode]) {
			_useage = obj.text;
		}
	}];
	
	_amount = [NSString stringWithFormat:@"%@元", formsViewModel.model.principal];
	_repayment = [NSString stringWithFormat:@"%@元", formsViewModel.model.repayMoneyMonth];
	_bankNumber = user.passcard;
	
  return self;
}

@end
