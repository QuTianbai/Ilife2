//
// MSFElement.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFObject.h"

@interface MSFElement : MSFObject

// type `IDCARD`
@property (nonatomic, copy, readonly) NSString *type;

// Title
@property (nonatomic, copy, readonly) NSString *title;

// The elment name.
@property (nonatomic, copy, readonly) NSString *name;

// The element's comment use to display on headers subtitle.
@property (nonatomic, copy, readonly) NSString *comment;

// The Example's image URL
@property (nonatomic, copy, readonly) NSURL *sampleURL;

// The thumb image URL.
@property (nonatomic, copy, readonly) NSURL *thumbURL;

@property (nonatomic, copy, readonly) NSString *relativeSamplePath;
@property (nonatomic, copy, readonly) NSString *relativeThumbPath;

// The element property is required or not.
@property (nonatomic, assign, readonly) BOOL required;

// The Max contain attachments.
@property (nonatomic, assign, readonly) NSUInteger maximum;

// The sort number.
@property (nonatomic, assign, readonly) NSInteger sort;

@end
