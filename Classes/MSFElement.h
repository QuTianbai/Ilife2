//
// MSFElement.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFObject.h"

@interface MSFElement : MSFObject

@property (nonatomic, copy, readonly) NSString *type;
@property (nonatomic, copy, readonly) NSString *plain;
@property (nonatomic, copy, readonly) NSString *comment;
@property (nonatomic, copy, readonly) NSURL *exampleURL;
@property (nonatomic, copy, readonly) NSURL *thumbURL;
@property (nonatomic, assign, readonly) BOOL required;
@property (nonatomic, assign, readonly) NSUInteger maximum;

@end
