//
// MSFUser.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFUser.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFPersonal.h"
#import "MSFProfessional.h"
#import "MSFSocialProfile.h"
#import "MSFSocialInsurance.h"
#import "MSFContact.h"

@implementation MSFUser

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
		@keypath(MSFUser.new, objectID): @"userId",
		@keypath(MSFUser.new, hasTransactionalCode): @"hasTransPwd",
		@keypath(MSFUser.new, personal): @"baseInfo",
		@keypath(MSFUser.new, professional): @"occupationInfo",
		@keypath(MSFUser.new, profiles): @"additionalList",
		@keypath(MSFUser.new, contacts): @"contrastList",
	};
}

#pragma mark - Lifecycle

+ (instancetype)userWithServer:(MSFServer *)server {
	NSMutableDictionary *userDict = [NSMutableDictionary dictionary];
	if (server != nil) {
	 userDict[@keypath(MSFUser.new, server)] = server;
	}
	
	return [self modelWithDictionary:userDict error:NULL];
}

+ (NSValueTransformer *)hasTransactionalCodeJSONTransformer {
	return [MTLValueTransformer transformerWithBlock:^id(NSString *value) {
		return [value isEqualToString:@"NO"] ? @NO : @YES;
	}];
}

+ (NSValueTransformer *)personalJSONTransformer {
	return [MTLValueTransformer mtl_JSONDictionaryTransformerWithModelClass:MSFPersonal.class];
}

+ (NSValueTransformer *)professionalJSONTransformer {
	return [MTLValueTransformer mtl_JSONDictionaryTransformerWithModelClass:MSFProfessional.class];
}

+ (NSValueTransformer *)profilesJSONTransformer {
	return [MTLValueTransformer mtl_JSONArrayTransformerWithModelClass:MSFSocialProfile.class];
}

+ (NSValueTransformer *)contactsJSONTransformer {
	return [MTLValueTransformer mtl_JSONArrayTransformerWithModelClass:MSFContact.class];
}

#pragma mark - Custom Accessors

- (BOOL)isAuthenticated {
	return self.hasChecked.integerValue != 0;
}

- (NSString *)completeness {
	NSInteger progress = 0;
	if (self.personal) progress+=20;
	if (self.professional) progress+=20;
	if (self.profiles) progress+=20;
	if (self.contacts) progress+=20;
	if (self.insurance) progress+=20;
	
	return [NSString stringWithFormat:@"%ld%%", (long)progress];
}

@end
