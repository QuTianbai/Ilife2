//
//  MSFRepayPlayMode.m
//  Finance
//
//  Created by Wyc on 16/3/17.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFRepayPlanViewModle.h"
#import <objc/runtime.h>
#import "MSFRepaymentSchedules.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface MSFRepayPlanViewModle ()

@property (nonatomic, strong) MSFRepaymentSchedules *model;

@end

@implementation MSFRepayPlanViewModle

- (instancetype)initWithModel:(id)model {
    
    self = [super init];
    
    if (!self) {
        return nil;
    }
	
	self = [super init];
	
	if (!self) {
		return nil;
	}
	_model = model;
	
	unsigned int propertyCount = 0;
	objc_property_t *properties = class_copyPropertyList([self class], &propertyCount);
	for (unsigned int i = 0; i < propertyCount; i ++ ) {
		objc_property_t property = properties[i];
		const char *name = property_getName(property);
		const char *attributes = property_getAttributes(property);
		NSString *key = [NSString stringWithUTF8String:name];
		NSString *type = [NSString stringWithUTF8String:attributes];
		if ([type rangeOfString:@"NSString"].location != NSNotFound ) {
			[self setValue:@"" forKey:key];
		}
	}
	
	RAC(self, loanExpireDate) = [[RACObserve(self, model.loanExpireDate) ignore:nil] map:^id(id value) {
		return [NSString stringWithFormat:@"%@期", value];
	}];
	RAC(self, repaymentTotalAmount) = [RACObserve(self, model.totalOverdueMoney) map:^id(id value) {
		return [NSString stringWithFormat:@"¥%@", value];
	}];
	RAC(self, repaymentTime) = [RACObserve(self, model.repaymentTime) ignore:nil];
	RAC(self, contractStatus) = [RACObserve(self, model.contractStatus) ignore:nil];
	
	RAC(self, status) = [[RACObserve(self, model) ignore:nil] map:^id(MSFRepaymentSchedules *value) {
		return [NSString stringWithFormat:@"%@%@", value.repaymentTime, value.contractStatus];
	}];
    
    return self;
}

@end