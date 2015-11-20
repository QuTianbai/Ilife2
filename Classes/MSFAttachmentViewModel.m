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
@property (nonatomic, assign, readwrite) BOOL isUploaded;

@end

@implementation MSFAttachmentViewModel

#pragma mark - Lifecycle

- (instancetype)initWithModel:(MSFAttachment *)model services:(id <MSFViewModelServices>)services {
  self = [super init];
  if (!self) {
    return nil;
  }
	_services = services;
	_attachment = model;
	_removeEnabled = !self.attachment.isPlaceholder;
	RAC(self, thumbURL) = RACObserve(self, attachment.thumbURL);
	
	@weakify(self)
	[RACObserve(self, attachment.isUpload) subscribeNext:^(id x) {
		@strongify(self)
		self.isUploaded = [x boolValue];
	}];
	
	_takePhotoCommand = [[RACCommand alloc] initWithEnabled:self.takePhotoValidSignal signalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self takePhotoSignal];
	}];
	_takePhotoCommand.allowsConcurrentExecution = YES;
	_uploadAttachmentCommand = [[RACCommand alloc] initWithEnabled:self.uploadValidSignal signalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [[self.services.httpClient uploadAttachment:self.attachment] doNext:^(id x) {
			[self.attachment mergeAttachment:x];
		}];
	}];
	_removeCommand = [[RACCommand alloc] initWithEnabled:RACObserve(self, removeEnabled) signalBlock:^RACSignal *(id input) {
		return [RACSignal empty];
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
	return [RACSignal combineLatest:@[
		RACObserve(self, isUploaded),
		RACObserve(self, removeEnabled),
	]
	reduce:^id(NSNumber *uploaded, NSNumber *enabled){
		return @(!uploaded.boolValue && enabled.boolValue);
	}];
}

#pragma mark - Private

- (RACSignal *)takePhotoSignal {
	return [[self.services msf_takePictureSignal] map:^id(UIImage *image) {
		NSString *name = [@([[NSDate date] timeIntervalSince1970]) stringValue].md5;
		NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", name]];
		CGSize size = image.size;
		if (size.width > 800 || size.height > 800) {
			CGFloat scale = size.width > size.height ? 800.0 / size.width : 800.0 / size.height;
			size = size.width > size.height ? CGSizeMake(800, size.height * scale) : CGSizeMake(size.width * scale, 800);
		}
		UIImage *x = [image resizedImage:size interpolationQuality:kCGInterpolationDefault];
		[[NSFileManager defaultManager] createFileAtPath:path contents:UIImageJPEGRepresentation(x, .7) attributes:nil];
		NSURL *fileURL = [NSURL fileURLWithPath:path];
		
		return [[MSFAttachment alloc] initWithFileURL:fileURL
			applicationNo:self.attachment.applicationNo
			elementType:self.attachment.type
			elementName:self.attachment.name];
	}];
}

@end
