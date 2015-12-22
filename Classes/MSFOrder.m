//
//  MSFOrder.m
//  Finance
//
//  Created by 赵勇 on 12/22/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFOrder.h"
#import "MSFOrderDetail.h"

@implementation MSFOrder

+ (NSValueTransformer *)cmdtyListJSONTransformer {
	return [MTLValueTransformer mtl_JSONArrayTransformerWithModelClass:MSFOrderDetail.class];
}

@end
