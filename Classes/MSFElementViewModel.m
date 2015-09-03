//
// MSFElementViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFElementViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/extobjc.h>
#import "MSFElement.h"
#import "MSFAttachment.h"
#import "MSFClient+Attachment.h"
#import "MSFAttachmentViewModel.h"

@interface MSFElementViewModel ()

// 下载服务器上已经存在的图片
@property (nonatomic, weak) id <MSFViewModelServices> services;
@property (nonatomic, strong, readwrite) NSArray *viewModels;
@property (nonatomic, strong, readwrite) NSMutableArray *attachments;
@property (nonatomic, strong, readonly) MSFAttachmentViewModel *placeholderViewModel;

@end

@implementation MSFElementViewModel

#pragma mark - Lifecycle

- (instancetype)initWithElement:(id)model services:(id <MSFViewModelServices>)services {
  self = [super init];
  if (!self) {
    return nil;
  }
	_services = services;
	_element = model;
	_attachments = NSMutableArray.new;
	
	NSURL *URL = [[NSBundle mainBundle] URLForResource:@"btn-attachment-take-photo@3x" withExtension:@"png"];
	MSFAttachment *placheholderAttchment = [[MSFAttachment alloc] initWithPlaceholderThumbURL:URL];
	_placeholderViewModel = [[MSFAttachmentViewModel alloc] initWthAttachment:placheholderAttchment services:self.services];
	_viewModels = @[self.placeholderViewModel];
	
	RAC(self, title) = RACObserve(self, element.plain);
	RAC(self, thumbURL) = RACObserve(self, element.thumbURL);
	RAC(self, sampleURL) = RACObserve(self, element.sampleURL);
	RAC(self, isRequired) = RACObserve(self, element.required);
	RAC(self, isCompleted) = self.attachmentsUploadCompletedSignal;
	
	@weakify(self)
	[RACObserve(self, placeholderViewModel.attachment.fileURL) subscribeNext:^(NSURL *URL) {
		@strongify(self)
		if (URL.isFileURL) {
			self.placeholderViewModel.attachment.fileURL = nil;
			MSFAttachment *attachment = [[MSFAttachment alloc] initWithDictionary:@{
				@"fileURL": URL,
				@"thumbURL": URL,
				@"type": self.element.type,
			} error:nil];
			[self addAttachment:attachment];
		}
	}];
	
  return self;
}

#pragma mark - Custom Accessors

- (void)addAttachment:(MSFAttachment *)attachment {
	[self.attachments addObject:attachment];
	if ([attachment.type isEqualToString:self.element.type]) {
		self.viewModels = [self.viewModels arrayByAddingObject:[[MSFAttachmentViewModel alloc] initWthAttachment:attachment services:self.services]];
	}
	if (self.viewModels.count - 1  == self.element.maximum) {
		self.viewModels = [self.viewModels mtl_arrayByRemovingObject:self.placeholderViewModel];
	} else {
		self.viewModels = [self.viewModels mtl_arrayByRemovingObject:self.placeholderViewModel];
		self.viewModels = [self.viewModels arrayByAddingObject:self.placeholderViewModel];
	}
}

- (void)removeAttachment:(MSFAttachment *)attachment {
	[self.attachments removeObject:attachment];
	__block	MSFAttachmentViewModel *viewModel;
	[self.viewModels enumerateObjectsUsingBlock:^(MSFAttachmentViewModel *obj, NSUInteger idx, BOOL *stop) {
		if ([obj.attachment isEqual:attachment]) viewModel = obj;
	}];
	if (viewModel) self.viewModels = [self.viewModels mtl_arrayByRemovingObject:viewModel];
	
	if ([self.viewModels containsObject:self.placeholderViewModel]) {
		self.viewModels =  [self.viewModels mtl_arrayByRemovingObject:self.placeholderViewModel];
		self.viewModels = [self.viewModels arrayByAddingObject:self.placeholderViewModel];
	} else {
		self.viewModels = [self.viewModels arrayByAddingObject:self.placeholderViewModel];
	}
}

#pragma mark - Private

- (RACSignal *)attachmentsUploadCompletedSignal {
	return [RACSignal combineLatest:@[
		RACObserve(self, viewModels),
	]
	reduce:^id (NSArray *viewModels) {
		if (viewModels.count == 0) return @NO;
		__block BOOL completed = YES;
		[viewModels enumerateObjectsUsingBlock:^(MSFAttachmentViewModel *obj, NSUInteger idx, BOOL *stop) {
			if (!obj.isUploaded) {
				completed = NO;
				*stop = YES;
			}
		}];
		return @(completed);
	}];
}

@end
