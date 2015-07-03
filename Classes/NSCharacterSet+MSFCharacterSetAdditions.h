//
// NSCharacterSet+MSFCharacterSetAdditions.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSCharacterSet (MSFCharacterSetAdditions)

+ (NSCharacterSet *)chineseCharacterSet;
+ (NSCharacterSet *)identifyCardCharacterSet;
+ (NSCharacterSet *)numberCharacterSet;

@end
