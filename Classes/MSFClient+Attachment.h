//
// MSFClient+Attachment.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFClient.h"

@class MSFAttachment;

@interface MSFClient (Attachment)

// Upload attachment image data to server
//
// attachment - MSFAttachment instance which fileURL is a local file URL
//
// Returns a signal which sends a new attachment that has fileID/fileName
- (RACSignal *)uploadAttachment:(MSFAttachment *)attachment;

@end
