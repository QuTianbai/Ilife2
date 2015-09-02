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
	_viewModels = @[];
	_attachments = NSMutableArray.new;
	RAC(self, title) = RACObserve(self, element.plain);
	RAC(self, thumbURL) = RACObserve(self, element.thumbURL);
	RAC(self, isRequired) = RACObserve(self, element.required);
	RAC(self, isCompleted) = self.attachmentsUploadCompletedSignal;
	
  return self;
}

#pragma mark - Custom Accessors

- (void)addAttachment:(MSFAttachment *)attachment {
	[self.attachments addObject:attachment];
	if ([attachment.type isEqualToString:self.element.type])
		self.viewModels = [self.viewModels arrayByAddingObject:[[MSFAttachmentViewModel alloc] initWthAttachment:attachment services:self.services]];
}

- (void)removeAttachment:(MSFAttachment *)attachment {
	[self.attachments removeObject:attachment];
	__block	MSFAttachmentViewModel *viewModel;
	[self.viewModels enumerateObjectsUsingBlock:^(MSFAttachmentViewModel *obj, NSUInteger idx, BOOL *stop) {
		if ([obj.attachment isEqual:attachment]) viewModel = obj;
	}];
	[self.viewModels mtl_arrayByRemovingObject:viewModel];
}

#pragma mark - Private

- (RACSignal *)attachmentsUploadCompletedSignal {
	return [RACSignal combineLatest:@[
		RACObserve(self, viewModels),
		[self rac_signalForSelector:@selector(addAttachment:)]
	]
	reduce:^id (NSArray *viewModels, id invocation) {
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
