//
// NSCharacterSet+MSFCharacterSetAdditions.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "NSCharacterSet+MSFCharacterSetAdditions.h"

@implementation NSCharacterSet (MSFCharacterSetAdditions)

+ (NSCharacterSet *)chineseCharacterSet {
	return [NSCharacterSet characterSetWithRange:NSMakeRange(0x4e00, 0x9fa5 - 0x4e00)];
}

+ (NSCharacterSet *)identifyCardCharacterSet {
	return [NSCharacterSet characterSetWithCharactersInString:@"0123456789xX"];
}

+ (NSCharacterSet *)numberCharacterSet {
	return [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
}

@end
