//
//  MSFCart.m
//  Finance
//
//  Created by 赵勇 on 12/24/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFCart.h"
#import "MSFCommodity.h"

@implementation MSFCart

- (NSValueTransformer *)cmdtyListJSONTransformer {
	return [MTLValueTransformer mtl_JSONArrayTransformerWithModelClass:MSFCommodity.class];
}

@end
