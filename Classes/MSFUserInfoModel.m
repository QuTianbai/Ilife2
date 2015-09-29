//
//  MSFUserInfoModel.m
//  Finance
//
//  Created by 赵勇 on 9/29/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFUserInfoModel.h"

@implementation MSFUserInfoModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{@"loanId":@"id"};
}

+ (NSValueTransformer *)contrastListJSONTransformer {
	return [MTLValueTransformer mtl_JSONArrayTransformerWithModelClass:MSFUserContact.class];
}

+ (NSValueTransformer *)additionalListJSONTransformer {
	return [MTLValueTransformer mtl_JSONArrayTransformerWithModelClass:MSFUserAdditional.class];
}

@end
