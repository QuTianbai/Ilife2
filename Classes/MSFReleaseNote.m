//
// MSFReleaseNote.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFReleaseNote.h"
#import "MSFVersion.h"

@implementation MSFReleaseNote

+ (NSValueTransformer *)versionJSONTransformer {
	return [MTLValueTransformer mtl_JSONDictionaryTransformerWithModelClass:MSFVersion.class];
}

@end
