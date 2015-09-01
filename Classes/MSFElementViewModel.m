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

@interface MSFElementViewModel ()

@property (nonatomic, strong, readonly) MSFElement *model;

@end

@implementation MSFElementViewModel

- (instancetype)initWithServices:(id <MSFViewModelServices>)services model:(id)element {
  self = [super init];
  if (!self) {
    return nil;
  }
	_model = element;
	_attachments = NSArray.new;
	RAC(self, title) = RACObserve(self, model.plain);
	RAC(self, thumbURL) = RACObserve(self, model.thumbURL);
	RAC(self, validity) = self.attachmentsValidSignal;
	
	_executeUploadCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return self.uploadSignal;
	}];
	_executeDownloadCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return self.downloadSignal;
	}];
	
  return self;
}

#pragma mark - Private

- (RACSignal *)attachmentsValidSignal {
	return [RACSignal combineLatest:@[RACObserve(self, attachments)] reduce:^id(NSArray *attachments){
		return @(attachments.count > 0);
	}];
}

- (RACSignal *)uploadSignal {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		[self.attachments enumerateObjectsUsingBlock:^(MSFAttachment *obj, NSUInteger idx, BOOL *stop) {
			if (!obj.contentURL.isFileURL) return ;
			[[[self.services.httpClient uploadAttachmentFileURL:obj.contentURL] doNext:^(id x) {
				[obj mergeValueForKey:@"name" fromModel:x];
				[obj mergeValueForKey:@"objectID" fromModel:x];
			}] subscribe:subscriber];
		}];
		return [RACDisposable disposableWithBlock:^{
		}];
	}];
}

- (RACSignal *)downloadSignal {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		[self.attachments enumerateObjectsUsingBlock:^(MSFAttachment *obj, NSUInteger idx, BOOL *stop) {
			if (!obj.contentURL.isFileURL) [[self.services.httpClient downloadAttachment:obj] subscribe:subscriber];
		}];
		return [RACDisposable disposableWithBlock:^{
		}];
	}];
}

@end
