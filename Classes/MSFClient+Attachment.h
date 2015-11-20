//
// MSFClient+Attachment.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFClient.h"

@class MSFAttachment;

@interface MSFClient (Attachment)

- (RACSignal *)uploadAttachment:(MSFAttachment *)attachment;

@end
