//
// MSFElementViewModelSpec.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFElementViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFElement.h"
#import "MSFAttachment.h"
#import "MSFViewModelServices.h"
#import "MSFAttachmentViewModel.h"
#import "MSFClient+Attachment.h"

QuickSpecBegin(MSFElementViewModelSpec)

__block MSFElementViewModel *viewModel;
__block id <MSFViewModelServices> services;
__block MSFClient *client;
__block MSFElement *element;

beforeEach(^{
	services = mockProtocol(@protocol(MSFViewModelServices));
	client = mock([MSFClient class]);
	[given([services httpClient]) willReturn:client];
	element = mock(MSFElement.class);
	stubProperty(element, required, @YES);
	stubProperty(element, plain, @"身份证验证");
	stubProperty(element, type, @"bar");
	stubProperty(element, maximum, @1);
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
});

it(@"should associate attachments", ^{
	// given
	MSFAttachment *attachment = mock([MSFAttachment class]);
	stubProperty(attachment, type, @"bar");
	stubProperty(attachment, objectID, @"foo");
	
	// when
	[viewModel addAttachment:attachment];
	
	// then
	expect(@(viewModel.isCompleted)).to(beTruthy());
});

it(@"should has add attachment", ^{
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
	MSFAttachment *attachment = [[MSFAttachment alloc] initWithDictionary:@{@"type": @"bar"} error:nil];
	
	// when
	[viewModel addAttachment:attachment];
	[viewModel removeAttachment:attachment];
	
	// then
	expect(@(viewModel.viewModels.count)).to(equal(@1));
});

it(@"should has a sampleURL for example view", ^{
	// then
	expect(viewModel.sampleURL).notTo(beNil());
});

it(@"should has palcholder viewModel", ^{
	// given
	stubProperty(element, maximum, @2);
	
	MSFAttachment *attachment1 = mock([MSFAttachment class]);
	stubProperty(attachment1, type, @"bar");
	
	MSFAttachment *attachment2 = mock([MSFAttachment class]);
	stubProperty(attachment2, type, @"bar");
	// when
	[viewModel addAttachment:attachment1];
	
	// then
	MSFAttachmentViewModel *attachmentViewModel = viewModel.viewModels.lastObject;
	expect(@(attachmentViewModel.attachment.isPlaceholder)).to(beTruthy());
	expect(attachmentViewModel).notTo(beNil());
});

it(@"should upload attachments's file", ^{
	// given
	NSURL *URL = [[NSBundle bundleForClass:self.class] URLForResource:@"tmp" withExtension:@"jpg"];
	MSFAttachment *attachment = [[MSFAttachment alloc] initWithDictionary:@{@"fileURL": URL, @"type": element.type} error:nil];
	[viewModel addAttachment:attachment];
	
	[given([client uploadAttachment:attachment]) willDo:^id(NSInvocation *invocation) {
		MSFAttachment *result = [[MSFAttachment alloc] initWithDictionary:@{
			@"objectID": @"foo",
			@"type": @"image/jpg",
			@"name": @"foo.jpg",
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

it(@"should return a error when upload max number of attachments", ^{
	// given
	NSURL *URL = [[NSBundle bundleForClass:self.class] URLForResource:@"tmp" withExtension:@"jpg"];
	MSFAttachment *attachment = [[MSFAttachment alloc] initWithDictionary:@{@"fileURL": URL, @"type": element.type} error:nil];
	[viewModel addAttachment:attachment];
	
	NSURL *URL2 = [[NSBundle bundleForClass:self.class] URLForResource:@"tmp" withExtension:@"jpg"];
	MSFAttachment *attachment2 = [[MSFAttachment alloc] initWithDictionary:@{@"fileURL": URL2, @"type": element.type} error:nil];
	[viewModel addAttachment:attachment2];
	
	[given([client uploadAttachment:attachment2]) willDo:^id(NSInvocation *invocation) {
		NSError *error = [NSError errorWithDomain:@"" code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: @"max number image"}];
		return [RACSignal error:error];
	}];
	
	[given([client uploadAttachment:attachment]) willDo:^id(NSInvocation *invocation) {
		NSError *error = [NSError errorWithDomain:@"" code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: @"max number image"}];
		return [RACSignal error:error];
	}];
	
	// when
	NSError *error;
	[[viewModel.uploadCommand execute:nil] asynchronousFirstOrDefault:nil success:nil error:&error];
	
	// then
	expect(error).notTo(beNil());
	expect(error.userInfo[NSLocalizedFailureReasonErrorKey]).to(equal(@"max number image"));
});

it(@"should remove attachment in attachmentViewModel", ^{
	// given
	NSURL *URL = [[NSBundle bundleForClass:self.class] URLForResource:@"tmp" withExtension:@"jpg"];
	MSFAttachment *attachment = [[MSFAttachment alloc] initWithDictionary:@{@"fileURL": URL, @"type": element.type} error:nil];
	[viewModel addAttachment:attachment];
	
	// when
	MSFAttachmentViewModel *attachmentViewModel = viewModel.viewModels.firstObject;
	[[attachmentViewModel.removeCommand execute:nil] asynchronousFirstOrDefault:nil success:nil error:nil];
	
	// then
	MSFAttachmentViewModel *expectedViewModel = viewModel.viewModels.firstObject;
	expect(@(expectedViewModel.attachment.isPlaceholder)).to(beTruthy());
});

it(@"should complete when upload attachment successfully", ^{
	// given
	MSFAttachment *attachment = mock([MSFAttachment class]);
	stubProperty(attachment, type, element.type);
	stubProperty(attachment, objectID, @"foo");
	
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

QuickSpecEnd
