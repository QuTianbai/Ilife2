//
// MSFAttachmentViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFAttachmentViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFAttachment.h"
#import "MSFClient+Attachment.h"
#import <NSString-Hashes/NSString+Hashes.h>

@interface MSFAttachmentViewModel ()

@property (nonatomic, weak) id <MSFViewModelServices> services;

@end

@implementation MSFAttachmentViewModel

#pragma mark - Lifecycle

- (instancetype)initWthAttachment:(MSFAttachment *)attachment services:(id <MSFViewModelServices>)services {
  self = [super init];
  if (!self) {
    return nil;
  }
	_services = services;
	_attachment = attachment;
	RAC(self, thumbURL) = RACObserve(self, attachment.contentURL);
	RAC(self, isUploaded) = [RACObserve(self, attachment.objectID) map:^id(id value) {
		return @([value boolValue]);
	}];
	
	_takePhotoCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return [self takePhotoSignal];
	}];
	_uploadAttachmentCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return [[self.services.httpClient uploadAttachmentFileURL:self.attachment.contentURL] doNext:^(id x) {
			[self.attachment mergeValueForKey:@"objectID" fromModel:x];
			[self.attachment mergeValueForKey:@"name" fromModel:x];
			[self.attachment mergeValueForKey:@"type" fromModel:x];
		}];
	}];
	_downloadAttachmentCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return [[self.services.httpClient downloadAttachment:self.attachment] doNext:^(id x) {
			NSString *name = [@([[NSDate date] timeIntervalSince1970]) stringValue].md5;
			NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", name]];
			[[NSFileManager defaultManager] createFileAtPath:path contents:UIImageJPEGRepresentation(x, .7) attributes:nil];
			self.attachment.contentURL = [NSURL fileURLWithPath:path];
		}];
	}];
  
  return self;
}

#pragma mark - Private

- (RACSignal *)takePhotoSignal {
	return [[self.services takePicture] doNext:^(id x) {
		NSString *name = [@([[NSDate date] timeIntervalSince1970]) stringValue].md5;
		NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", name]];
		[[NSFileManager defaultManager] createFileAtPath:path contents:UIImageJPEGRepresentation(x, .7) attributes:nil];
		self.attachment.contentURL = [NSURL fileURLWithPath:path];
	}];
}

@end
