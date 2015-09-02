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

@end

@implementation MSFElementViewModel

- (instancetype)initWithModel:(id)model services:(id <MSFViewModelServices>)services {
  self = [super init];
  if (!self) {
    return nil;
  }
	_services = services;
	_model = model;
	RAC(self, title) = RACObserve(self, model.plain);
	RAC(self, thumbURL) = RACObserve(self, model.thumbURL);
	RAC(self, required) = RACObserve(self, model.required);
	RAC(self, validity) = self.attachmentsValidSignal;
	
  return self;
}

#pragma mark - Private

- (RACSignal *)attachmentsValidSignal {
	return [RACSignal return:@YES];
}

@end
