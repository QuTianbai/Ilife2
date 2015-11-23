//
// MSFElementViewModelSpec.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFElementViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Mantle/EXTScope.h>
#import "MSFElement.h"
#import "MSFAttachment.h"
#import "MSFViewModelServices.h"
#import "MSFAttachmentViewModel.h"
#import "MSFClient+Attachment.h"
#import "MSFApplyCashVIewModel.h"
#import "MSFElement+Private.h"

QuickSpecBegin(MSFElementViewModelSpec)

__block MSFElementViewModel *viewModel;
__block id <MSFViewModelServices> services;
__block MSFClient *client;
__block MSFElement *element;

beforeEach(^{
	services = mockProtocol(@protocol(MSFViewModelServices));
	
	client = mock([MSFClient class]);
	[given([services httpClient]) willReturn:client];
	[given([services msf_takePictureSignal]) willReturn:RACSignal.empty];
	
	element = mock(MSFElement.class);
	
	stubProperty(element, required, @YES);
	stubProperty(element, title, @"身份证验证");
	stubProperty(element, type, @"bar");
	stubProperty(element, maximum, @1);
	stubProperty(element, applicationNo, @"");
	stubProperty(element, name, @"foo");
	stubProperty(element, sampleURL, [NSURL URLWithString:@"http://sample.png"]);
	stubProperty(element, thumbURL, [NSURL URLWithString:@"http://icon.png"]);
	
	viewModel = [[MSFElementViewModel alloc] initWithElement:element services:services];
	expect(viewModel).notTo(beNil());
});

it(@"should initialize", ^{
  // then
	expect(viewModel.title).to(equal(@"身份证验证"));
	expect(viewModel.thumbURL).to(equal([NSURL URLWithString:@"http://icon.png"]));
	expect(@(viewModel.isCompleted)).to(beFalsy());
	expect(@(viewModel.isRequired)).to(beTruthy());
	expect(@(viewModel.viewModels.count)).to(equal(@1));
	expect(viewModel.sampleURL).notTo(beNil());
});

it(@"should add attachment", ^{
	// given
	MSFAttachment *attachment = mock([MSFAttachment class]);
	stubProperty(attachment, type, @"bar");
	
	// when
	[viewModel addAttachment:attachment];
	
	// then
	expect(@(viewModel.viewModels.count)).to(equal(@1));
});

it(@"should remove attachment from viewmodels", ^{
	// given
	MSFAttachment *attachment = mock([MSFAttachment class]);
	stubProperty(attachment, type, @"bar");
	
	// when
	[viewModel addAttachment:attachment];
	[viewModel removeAttachment:attachment];
	
	MSFAttachmentViewModel *attachmentViewModel = viewModel.viewModels.firstObject;
	
	// then
	expect(@(attachmentViewModel.removeEnabled)).to(beFalsy());
});

it(@"should addition completed not over max number of attachments", ^{
	// given
	MSFAttachment *attachment = mock([MSFAttachment class]);
	stubProperty(attachment, type, @"bar");
	stubProperty(attachment, isUpload, @YES);
	
	// when
	[viewModel addAttachment:attachment];
	
	// then
	expect(@(viewModel.isCompleted)).to(beTruthy());
});

it(@"should not be completed when not uplaod attchment", ^{
	// given
	MSFAttachment *attachment = mock([MSFAttachment class]);
	stubProperty(attachment, type, element.type);
	
	// when
	[viewModel addAttachment:attachment];
	
	// then
	expect(@(viewModel.isCompleted)).to(beFalsy());
});

it(@"should has palcholder viewModel and normal elementViewModel", ^{
	// given
	stubProperty(element, maximum, @2);
	
	MSFAttachment *attachment1 = mock([MSFAttachment class]);
	stubProperty(attachment1, type, @"bar");
	
	// when
	[viewModel addAttachment:attachment1];
	
	// then
	MSFAttachmentViewModel *normalViewModel = viewModel.viewModels.firstObject;
	expect(@(normalViewModel.removeEnabled)).to(beTruthy());
	
	MSFAttachmentViewModel *placeholderViewModel = viewModel.viewModels.lastObject;
	expect(@(placeholderViewModel.removeEnabled)).to(beFalsy());
});

it(@"should upload attachments's file", ^{
	// given
	NSURL *URL = [[NSBundle bundleForClass:self.class] URLForResource:@"tmp" withExtension:@"jpg"];
	MSFAttachment *attachment = [[MSFAttachment alloc] initWithDictionary:@{@"fileURL": URL, @"type": element.type} error:nil];
	[viewModel addAttachment:attachment];
	
	[given([client uploadAttachment:attachment]) willDo:^id(NSInvocation *invocation) {
		MSFAttachment *result = [[MSFAttachment alloc] initWithFileURL:URL applicationNo:@"" elementType:@"bar" elementName:@""];
		result = [[MSFAttachment alloc] initWithDictionary:@{
			@keypath(MSFAttachment.new, objectID): @"foo",
			@keypath(MSFAttachment.new, fileID): @"2",
			@keypath(MSFAttachment.new, fileName): @"bar"
		} error:nil];
		return [RACSignal return:result];
	}];
	
	// when
	[[viewModel.uploadCommand execute:nil] asynchronousFirstOrDefault:nil success:nil error:nil];
	
	// then
	MSFAttachmentViewModel *expected = viewModel.viewModels.firstObject;
	expect(@(expected.attachment.isPlaceholder)).to(beFalsy());
	expect(expected.attachment).notTo(beNil());
	expect(expected.attachment.objectID).to(equal(@"foo"));
});

it(@"should get error when upload attachment", ^{
	// given
	NSURL *URL = [[NSBundle bundleForClass:self.class] URLForResource:@"tmp" withExtension:@"jpg"];
	MSFAttachment *attachment = [[MSFAttachment alloc] initWithDictionary:@{@"fileURL": URL, @"type": element.type} error:nil];
	[viewModel addAttachment:attachment];
	
	[given([client uploadAttachment:attachment]) willDo:^id(NSInvocation *invocation) {
		return [RACSignal error:[NSError errorWithDomain:@"ErrorDomain" code:0 userInfo:nil]];
	}];
	
	// when
	NSError *error;
	[[viewModel.uploadCommand execute:nil] asynchronousFirstOrDefault:nil success:nil error:&error];
	
	// then
	expect(error).notTo(beNil());
	expect(error.domain).to(equal(@"ErrorDomain"));
});

it(@"should remove attachment in attachmentViewModel", ^{
	// given
	NSURL *URL = [[NSBundle bundleForClass:self.class] URLForResource:@"tmp" withExtension:@"jpg"];
	MSFAttachment *attachment = [[MSFAttachment alloc] initWithDictionary:@{@"fileURL": URL, @"type": element.type} error:nil];
	[viewModel addAttachment:attachment];
	
	MSFAttachmentViewModel *attachmentViewModel = viewModel.viewModels.firstObject;
	expect(@(attachmentViewModel.removeEnabled)).to(beTruthy());
	
	// when
	[[attachmentViewModel.removeCommand execute:nil] asynchronousFirstOrDefault:nil success:nil error:nil];
	
	// then
	MSFAttachmentViewModel *expectedViewModel = viewModel.viewModels.firstObject;
	expect(@(expectedViewModel.attachment.isPlaceholder)).to(beTruthy());
});

QuickSpecEnd
