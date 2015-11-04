//
// MSFIntergrant.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFObject.h"

@interface MSFIntergrant : MSFObject

@property (nonatomic, readonly) BOOL isUpgrade;
@property (nonatomic, readonly) NSString *bref;

- (NSString *)relativeStringWithType:(NSString *)type;

@end
