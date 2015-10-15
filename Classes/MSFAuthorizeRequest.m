//
// MSFAuthorizeRequest.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFAuthorizeRequest.h"
#import "NSValueTransformer+MSFPredefinedTransformerAdditions.h"
#import <Mantle/EXTScope.h>
#import <Mantle/EXTKeyPathCoding.h>

@implementation MSFAuthorizeRequest

#pragma mark - Lifecycle

- (instancetype)initWithRequestType:(MSFAuthorizeRequestType)requestType {
  self = [super init];
  if (!self) {
    return nil;
  }
	_requestType = requestType;
  
  return self;
}

#pragma mark - MTLJSONSerializing

+ (NSSet *)propertyKeys {
	NSMutableSet *keys = [super.propertyKeys mutableCopy];

	// This is a derived property.
	[keys removeObject:@keypath(MSFAuthorizeRequest.new, server)];
	[keys removeObject:@keypath(MSFAuthorizeRequest.new, objectID)];

	return keys;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
		@"requestType": @"logType",
		@"imei": @"imei",
		@"mobile": @"mobile",
		@"password": @"password",
		@"name": @"name",
		@"identifier": @"ident",
		@"smscode": @"smsCode",
		@"identifierExpiredDate": @"idLastDate",
		@"updatingPassword": @"newPassword",
		@"uniqueId": @"uniqueId",
		@"transactCode": @"transPassword",
		@"usingTransactCode": @"oldTransPassword",
		@"updatingTransactCode": @"newTransPassword",
		@"usingIdentifier": @"idCard",
		@"usingMobile": @"oldMobile",
	};
}

+ (NSValueTransformer *)identifierExpiredDateJSONTransformer {
	return [NSValueTransformer valueTransformerForName:MSFDateValueTransformerName];
}

#pragma mark - Custom Accessors

- (NSDictionary *)requestBody {
	return [MTLJSONAdapter JSONDictionaryFromModel:self];
}

@end
