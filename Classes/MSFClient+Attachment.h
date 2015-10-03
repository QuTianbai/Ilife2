//
// MSFClient+Attachment.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFClient.h"

@class MSFAttachment;

@interface MSFClient (Attachment)

- (RACSignal *)uploadAttachment:(MSFAttachment *)attachment __deprecated_msg("Use uploadAttachment:applicationNumber:");
- (RACSignal *)uploadAttachment:(MSFAttachment *)attachment applicationNumber:(NSString *)applicationNumber;
- (RACSignal *)downloadAttachment:(MSFAttachment *)attachment;

@end
