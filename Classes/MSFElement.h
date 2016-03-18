//
// MSFElement.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFObject.h"

// 获取的服务器清单元素对象
@interface MSFElement : MSFObject

// The element Type `IDCARD` parsed from response JSON key `code`
@property (nonatomic, copy, readonly) NSString *type;

// The element Name
@property (nonatomic, copy, readonly) NSString *name;

// The element Title
@property (nonatomic, copy, readonly) NSString *title;

// The element's comment use to display on headers subtitle.
@property (nonatomic, copy, readonly) NSString *comment;

// The Element image path parsed from JSON `exampleUrl` `iconUrl`
@property (nonatomic, copy, readonly) NSString *relativeSamplePath;
@property (nonatomic, copy, readonly) NSString *relativeThumbPath;

// The element property is required or not, parsed from JSON `status`
@property (nonatomic, assign, readonly) BOOL required;

// The Max contain attachments.
@property (nonatomic, assign, readonly) NSUInteger maximum;

// The sort number.
@property (nonatomic, assign, readonly) NSInteger sort;

// The Example's image URL, Base on self server baseURL
@property (nonatomic, strong, readonly) NSURL *sampleURL;

// The thumb image URL, Base on self server baseURL
@property (nonatomic, strong, readonly) NSURL *thumbURL;

@end
