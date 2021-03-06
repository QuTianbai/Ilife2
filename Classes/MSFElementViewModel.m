//
// MSFElementViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFElementViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Mantle/EXTScope.h>
#import "MSFElement.h"
#import "MSFAttachment.h"
#import "MSFClient+Attachment.h"
#import "MSFAttachmentViewModel.h"
#import "MSFElement+Private.h"

@interface MSFElementViewModel ()

// 下载服务器上已经存在的图片
@property (nonatomic, weak) id <MSFViewModelServices> services;
@property (nonatomic, strong, readwrite) NSArray *viewModels;
@property (nonatomic, strong, readwrite) NSArray *attachments;

// 只有一个placeholder,用于添加附件ViewModel,当满足最大附件的时候从viewmodels中删除，
// 当小于最大附件数量的时候添加到viewmodels中
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
	MSFAttachment *placheholderAttchment = [[MSFAttachment alloc] initWithAssetsURL:URL applicationNo:self.element.applicationNo elementType:self.element.type elementName:self.element.name];
	_placeholderViewModel = [[MSFAttachmentViewModel alloc] initWithModel:placheholderAttchment services:self.services];
	_viewModels = @[self.placeholderViewModel];
	
	RAC(self, title) = RACObserve(self, element.title);
	RAC(self, name) = RACObserve(self, element.name);
	RAC(self, thumbURL) = RACObserve(self, element.thumbURL);
	RAC(self, sampleURL) = RACObserve(self, element.sampleURL);
	RAC(self, isRequired) = RACObserve(self, element.required);
	
	@weakify(self)
	[self.placeholderViewModel.takePhotoCommand.executionSignals subscribeNext:^(RACSignal *signal) {
		@strongify(self)
		[signal subscribeNext:^(MSFAttachment *attachment) {
			[self addAttachment:attachment];
		}];
	}];
	
	_uploadCommand = [[RACCommand alloc] initWithEnabled:self.uploadValidSignal signalBlock:^RACSignal *(id input) {
		@strongify(self)
		return self.uploadSignal;
	}];
	
  return self;
}

#pragma mark - Public

- (void)addAttachment:(MSFAttachment *)attachment {
	self.attachments = [self.attachments arrayByAddingObject:attachment];
	if ([attachment.type isEqualToString:self.element.type]) {
		MSFAttachmentViewModel *viewModel = [[MSFAttachmentViewModel alloc] initWithModel:attachment services:self.services];
		[viewModel.removeCommand.executionSignals subscribeNext:^(id x) {
			[self removeAttachment:attachment];
		}];
		self.viewModels = [self.viewModels arrayByAddingObject:viewModel];
	}
	if (self.viewModels.count - 1  == self.element.maximum) {
		self.viewModels = [self.viewModels mtl_arrayByRemovingObject:self.placeholderViewModel];
	} else {
		self.viewModels = [self.viewModels mtl_arrayByRemovingObject:self.placeholderViewModel];
		self.viewModels = [self.viewModels arrayByAddingObject:self.placeholderViewModel];
	}
}

- (void)removeAttachment:(MSFAttachment *)attachment {
	self.attachments = [self.attachments mtl_arrayByRemovingObject:attachment];
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

#pragma mark - Custom Accessors

- (BOOL)isCompleted {
	NSArray *models = [self.viewModels mtl_arrayByRemovingObject:self.placeholderViewModel];
	if (models.count == 0) return NO;
	__block BOOL completed = YES;
	[models enumerateObjectsUsingBlock:^(MSFAttachmentViewModel *obj, NSUInteger idx, BOOL *stop) {
		if (!obj.isUploaded) {
			completed = NO;
		}
	}];
	return completed;
}

#pragma mark - Private

- (RACSignal *)uploadValidSignal {
	return [RACSignal combineLatest:@[
		RACObserve(self, viewModels),
	]
	reduce:^id (NSArray *viewModels) {
		__block BOOL hasUpload = NO;
		[viewModels enumerateObjectsUsingBlock:^(MSFAttachmentViewModel *obj, NSUInteger idx, BOOL *stop) {
			if (!obj.isUploaded && !obj.attachment.isPlaceholder) {
				hasUpload = YES;
				*stop = YES;
			}
		}];
		return @(hasUpload);
	}];
}

- (RACSignal *)uploadSignal {
	return [[self.viewModels.rac_sequence.signal flattenMap:^RACStream *(MSFAttachmentViewModel *attachmentViewModel) {
		return [[attachmentViewModel.uploadAttachmentCommand execute:nil] catch:^RACSignal *(NSError *error) {
			return [error.domain isEqualToString:RACCommandErrorDomain] ? [RACSignal empty] : [RACSignal error:error];
		}];
	}] collect];
}

@end
