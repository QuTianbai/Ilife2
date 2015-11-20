//
// MSFClient+Attachment.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFClient.h"

@class MSFAttachment;

@interface MSFClient (Attachment)

- (RACSignal *)uploadAttachment:(MSFAttachment *)attachment;

// Upload attachment's photo.
//
// attachment				 - Wait for upload attachment.
// applicationNumber - The loan application number.
//
// Returns an attachement with `fileId` `fileName` which created by server.
- (RACSignal *)uploadAttachment:(MSFAttachment *)attachment applicationNumber:(NSString *)applicationNumber __deprecated;

// Download attachment picture file.
//
// This Method is unused.
//
// attachment -  The attachment base information which fetch from server.
//
// Returns UIImage data.
- (RACSignal *)downloadAttachment:(MSFAttachment *)attachment;

@end
