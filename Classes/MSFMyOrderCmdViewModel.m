//
//  MSFMyOrderCmdViewModel.m
//  Finance
//
//  Created by xbm on 16/3/4.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFMyOrderCmdViewModel.h"
#import "MSFCommodity.h"
#import <objc/runtime.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface MSFMyOrderCmdViewModel ()

@property (nonatomic, strong) MSFCommodity *model;

@end

@implementation MSFMyOrderCmdViewModel

- (instancetype)initWithModel:(id)model {
	self = [super init];
	if (!self) {
		return nil;
	}
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
	_model = model;
	
	RAC(self, catId) = RACObserve(self, model.catId);
	RAC(self, cmdtyId) = RACObserve(self, model.cmdtyId);
	RAC(self, brandName) = RACObserve(self, model.brandName);
	RAC(self, cmdtyName) = RACObserve(self, model.cmdtyName);
	RAC(self, pcsCount) = [[RACObserve(self, model.pcsCount) ignore:nil] map:^id(NSString *value) {
		return [NSString stringWithFormat:@"数量×%@", value];
	}];
	RAC(self, cmdtyPrice) = [[RACObserve(self, model.cmdtyPrice) ignore:nil] map:^id(id value) {
		return [NSString stringWithFormat:@"¥%@", value];
	}];
	
	return self;
}

@end
