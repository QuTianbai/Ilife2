//
// MSFAttachmentViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFAttachmentViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Mantle/EXTScope.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "MSFAttachment.h"
#import "MSFClient+Attachment.h"
#import <NSString-Hashes/NSString+Hashes.h>
#import "UIImage+Resize.h"
#import "MSFApplyCashVIewModel.h"

@interface MSFAttachmentViewModel ()

@property (nonatomic, weak) id <MSFViewModelServices> services;
@property (nonatomic, strong, readwrite) NSURL *fileURL;
@property (nonatomic, strong, readwrite) NSURL *thumbURL;
@property (nonatomic, strong, readwrite) NSString *fileName;

@end

@implementation MSFAttachmentViewModel

#pragma mark - Lifecycle

- (instancetype)initWthAttachment:(MSFAttachment *)attachment viewModel:(MSFApplyCashVIewModel *)viewModel {
  self = [super init];
  if (!self) {
    return nil;
  }
	_services = viewModel.services;
	_attachment = attachment;
	_removeEnabled = !attachment.isPlaceholder;
	RACChannelTo(self, thumbURL) = RACChannelTo(self, attachment.thumbURL);
	RACChannelTo(self, fileURL) = RACChannelTo(self, attachment.fileURL);
	
	_takePhotoCommand = [[RACCommand alloc] initWithEnabled:self.takePhotoValidSignal signalBlock:^RACSignal *(id input) {
		return [self takePhotoSignal];
	}];
	_takePhotoCommand.allowsConcurrentExecution = YES;
	_uploadAttachmentCommand = [[RACCommand alloc] initWithEnabled:self.uploadValidSignal signalBlock:^RACSignal *(id input) {
		return [[self.services.httpClient uploadAttachment:self.attachment applicationNumber:viewModel.appNO] doNext:^(id x) {
			[self.attachment mergeValueForKey:@keypath(MSFAttachment.new, objectID) fromModel:x];
			[self.attachment mergeValueForKey:@keypath(MSFAttachment.new, fileID) fromModel:x];
			[self.attachment mergeValueForKey:@keypath(MSFAttachment.new, fileName) fromModel:x];
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
	
	_removeCommand = [[RACCommand alloc] initWithEnabled:[RACSignal return:@(self.removeEnabled)] signalBlock:^RACSignal *(id input) {
		return [RACSignal empty];
	}];
  
  return self;
}

- (instancetype)initWthAttachment:(MSFAttachment *)attachment services:(id <MSFViewModelServices>)services {
  self = [super init];
  if (!self) {
    return nil;
  }
	_services = services;
	_attachment = attachment;
	
  return self;
}

#pragma mark - Custom Accessors 

- (RACSignal *)takePhotoValidSignal {
	return [RACSignal combineLatest:@[RACObserve(self, attachment.isPlaceholder)] reduce:^id(NSNumber *placeholder){
		return @(placeholder.boolValue);
	}];
}

- (RACSignal *)uploadValidSignal {
	return [RACSignal combineLatest:@[
		RACObserve(self, attachment.isPlaceholder),
		RACObserve(self, attachment.objectID),
	]
	reduce:^id(NSNumber *placeholder, NSString *objectID){
		return @(!placeholder.boolValue && !objectID);
	}];
}

- (RACSignal *)downloadValidSignal {
	return [RACSignal combineLatest:@[
		RACObserve(self, attachment.isPlaceholder),
		RACObserve(self, attachment.name),
	]
	reduce:^id(NSNumber *placeholder, NSString *file){
		NSString *path = [NSTemporaryDirectory() stringByAppendingString:[NSString stringWithFormat:@"%@", file]];
		BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:path];
		return @(!placeholder.boolValue && !exist);
	}];
}

- (BOOL)isUploaded {
	return self.attachment.objectID != nil;
}

#pragma mark - Private

- (RACSignal *)takePhotoSignal {
	return [[self.services msf_takePictureSignal] doNext:^(UIImage *image) {
		NSString *name = [@([[NSDate date] timeIntervalSince1970]) stringValue].md5;
		NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", name]];
		CGSize size = image.size;
		if (size.width > 800 || size.height > 800) {
			CGFloat scale = size.width > size.height ? 800.0 / size.width : 800.0 / size.height;
			size = size.width > size.height ? CGSizeMake(800, size.height * scale) : CGSizeMake(size.width * scale, 800);
		}
		UIImage *x = [image resizedImage:size interpolationQuality:kCGInterpolationDefault];
		[[NSFileManager defaultManager] createFileAtPath:path contents:UIImageJPEGRepresentation(x, .7) attributes:nil];
		self.fileURL = [NSURL fileURLWithPath:path];
		if (!self.attachment.isPlaceholder)
			self.thumbURL = [NSURL fileURLWithPath:path];
	}];
}

@end
