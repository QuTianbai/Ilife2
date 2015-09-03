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
	RAC(self, thumbURL) = RACObserve(self, attachment.thumbURL);
	RAC(self, isUploaded) = [RACObserve(self, attachment.objectID) map:^id(id value) {
		return @([value boolValue]);
	}];
	
	_takePhotoCommand = [[RACCommand alloc] initWithEnabled:self.takePhotoValidSignal signalBlock:^RACSignal *(id input) {
		return [self takePhotoSignal];
	}];
	_uploadAttachmentCommand = [[RACCommand alloc] initWithEnabled:self.uploadValidSignal signalBlock:^RACSignal *(id input) {
		return [[self.services.httpClient uploadAttachmentFileURL:self.attachment.fileURL] doNext:^(id x) {
			[self.attachment mergeValueForKey:@"objectID" fromModel:x];
			[self.attachment mergeValueForKey:@"name" fromModel:x];
			[self.attachment mergeValueForKey:@"type" fromModel:x];
		}];
	}];
	_downloadAttachmentCommand = [[RACCommand alloc] initWithEnabled:self.downloadValidSignal signalBlock:^RACSignal *(id input) {
		return [[self.services.httpClient downloadAttachment:self.attachment] doNext:^(id x) {
			NSString *name = [@([[NSDate date] timeIntervalSince1970]) stringValue].md5;
			NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", name]];
			[[NSFileManager defaultManager] createFileAtPath:path contents:UIImageJPEGRepresentation(x, .7) attributes:nil];
			self.attachment.thumbURL = [NSURL fileURLWithPath:path];
			self.attachment.fileURL = [NSURL URLWithString:path];
		}];
	}];
  
  return self;
}

#pragma mark - Custom Accessors 

- (RACSignal *)takePhotoValidSignal {
	return [RACSignal combineLatest:@[RACObserve(self, attachment.isPlaceholder)] reduce:^id(NSNumber *placeholder){
		return @(placeholder.boolValue);
	}];
}

- (RACSignal *)uploadValidSignal {
	return [RACSignal combineLatest:@[RACObserve(self, attachment.isPlaceholder)] reduce:^id(NSNumber *placeholder){
		return @(!placeholder.boolValue);
	}];
}

- (RACSignal *)downloadValidSignal {
	return [RACSignal combineLatest:@[RACObserve(self, attachment.isPlaceholder)] reduce:^id(NSNumber *placeholder){
		return @(!placeholder.boolValue);
	}];
}

#pragma mark - Private

- (RACSignal *)takePhotoSignal {
	return [[self.services takePicture] doNext:^(id x) {
		NSString *name = [@([[NSDate date] timeIntervalSince1970]) stringValue].md5;
		NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", name]];
		[[NSFileManager defaultManager] createFileAtPath:path contents:UIImageJPEGRepresentation(x, .7) attributes:nil];
		self.attachment.fileURL = [NSURL fileURLWithPath:path];
	}];
}

@end
