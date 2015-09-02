//
// MSFAttachmentViewModelSpec.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFAttachmentViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFAttachment.h"
#import "MSFClient+Attachment.h"

QuickSpecBegin(MSFAttachmentViewModelSpec)

__block MSFAttachmentViewModel *viewModel;
__block MSFAttachment *model;
__block id <MSFViewModelServices> services;
__block MSFClient *client;

beforeEach(^{
	client = mock(MSFClient.class);
	services = mockProtocol(@protocol(MSFViewModelServices));
	model = [[MSFAttachment alloc] initWithDictionary:@{} error:nil];
	viewModel = [[MSFAttachmentViewModel alloc] initWthAttachment:model services:services];
	expect(viewModel).notTo(beNil());
});

it(@"should initialize", ^{
  // then
	expect(viewModel.attachment).to(equal(model));
	expect(viewModel.takePhotoCommand).notTo(beNil());
	expect(@(viewModel.isUploaded)).to(beFalsy());
});

it(@"should take photo from camera and album", ^{
	// given
	[given([services takePicture]) willReturn:[RACSignal return:[UIImage imageNamed:@"tmp.jpg"]]];
	
	// when
	[[viewModel.takePhotoCommand execute:nil] asynchronousFirstOrDefault:nil success:nil error:nil];
	
	// then
	expect(viewModel.attachment.contentURL).notTo(beNil());
});

it(@"should upload picture", ^{
	// given
	viewModel.attachment.contentURL = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"temp.jpg"]];
	[given([services httpClient]) willReturn:client];
	[given([client uploadAttachmentFileURL:viewModel.attachment.contentURL]) willDo:^id(NSInvocation *invocation) {
		MSFAttachment *attachment = [[MSFAttachment alloc] initWithDictionary:@{
			@"objectID": @"3033",
			@"type": @"image/jpg",
			@"name": @"foo.jpg",
		} error:nil];
		return [RACSignal return:attachment];
	}];
	
	// when
	[[viewModel.uploadAttachmentCommand execute:nil] asynchronousFirstOrDefault:nil success:nil error:nil];
	
	// then
	expect(viewModel.attachment.objectID).to(equal(@"3033"));
	expect(viewModel.attachment.type).to(equal(@"image/jpg"));
	expect(viewModel.attachment.name).to(equal(@"foo.jpg"));
	expect(viewModel.attachment.contentURL).notTo(beNil());
	expect(@(viewModel.isUploaded)).to(beTruthy());
});

it(@"should download picture", ^{
	// given
	[given([services httpClient]) willReturn:client];
	[given([client downloadAttachment:viewModel.attachment]) willReturn:[RACSignal return:UIImageJPEGRepresentation([UIImage imageNamed:@"tmp.jpg"], 1)]];
	
	// when
	[[viewModel.downloadAttachmentCommand execute:nil] asynchronousFirstOrDefault:nil success:nil error:nil];
	
	// then
	expect(viewModel.attachment.contentURL).notTo(beNil());
});

QuickSpecEnd
