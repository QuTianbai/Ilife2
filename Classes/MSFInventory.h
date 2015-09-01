//
// MSFInventory.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFObject.h"

// 附件清单
// applyId 对应对象的objectID
@interface MSFInventory : MSFObject

// 申请号
@property (nonatomic, copy, readonly) NSString *applyNo;

// 附件列表
@property (nonatomic, strong) NSArray *attachments;

@end
