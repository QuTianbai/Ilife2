//
// MSFIntergrant.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFObject.h"

@interface MSFIntergrant : MSFObject

@property (nonatomic, readonly) BOOL isUpgrade;
@property (nonatomic, readonly) NSURL *HTMLURL;

- (instancetype)initWithUpgrade:(BOOL)upgrade HTMLURL:(NSURL *)URL;

@end
