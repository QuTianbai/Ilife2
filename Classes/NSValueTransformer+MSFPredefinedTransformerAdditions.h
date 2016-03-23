//
//  NSValueTransformer+MSFPredefinedTransformerAdditions.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <Foundation/Foundation.h>

// The name for a value transformer that converts GitHub API date strings into
// dates and back.
//
// For backwards compatibility reasons, the forward transformation accepts an
// NSString (which will be parsed) _or_ an NSDate (which will be passed through
// unmodified).
extern NSString *const MSFDateValueTransformerName;

@interface NSValueTransformer (MSFPredefinedTransformerAdditions)

@end
