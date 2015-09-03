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
	model = [[MSFAttachment alloc] initWithPlaceholderThumbURL:[NSURL URLWithString:@"file://temp"]];
	viewModel = [[MSFAttachmentViewModel alloc] initWthAttachment:model services:services];
	[given([services takePicture]) willReturn:[RACSignal return:[UIImage imageNamed:@"tmp.jpg"]]];
	
	// when
	[[viewModel.takePhotoCommand execute:nil] asynchronousFirstOrDefault:nil success:nil error:nil];
	
	// then
	expect(viewModel.attachment.fileURL).notTo(beNil());
});

it(@"should upload picture", ^{
	// given
	viewModel.attachment.fileURL = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"temp.jpg"]];
	[given([services httpClient]) willReturn:client];
	[given([client uploadAttachmentFileURL:viewModel.attachment.fileURL]) willDo:^id(NSInvocation *invocation) {
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
	expect(viewModel.attachment.fileURL).notTo(beNil());
	expect(@(viewModel.isUploaded)).to(beTruthy());
});

it(@"should download picture", ^{
	// given
	[given([services httpClient]) willReturn:client];
	[given([client downloadAttachment:viewModel.attachment]) willReturn:[RACSignal return:UIImageJPEGRepresentation([UIImage imageNamed:@"tmp.jpg"], 1)]];
	
	// when
	[[viewModel.downloadAttachmentCommand execute:nil] asynchronousFirstOrDefault:nil success:nil error:nil];
	
	// then
	expect(viewModel.attachment.thumbURL).notTo(beNil());
	expect(viewModel.attachment.fileURL).notTo(beNil());
});


it(@"should combine array", ^{
	// given
	NSArray *ar1 = @[@1, @2];
	NSArray *ar2 = @[@3, @4];
	
	NSArray *ar = @[ar1, ar2];
	
	// when
	NSArray *result;
	
	result = [[ar.rac_sequence flattenMap:^RACStream *(NSArray *value) {
		return value.rac_sequence;
	}] array];
	
	// then
	expect(result).to(equal(@[@1, @2, @3, @4]));
});

it(@"should can't take photo when attachment is not a placholder", ^{
	// when
	BOOL valid = [[viewModel.takePhotoValidSignal asynchronousFirstOrDefault:nil success:nil error:nil] boolValue];
	
	// then
	expect(@(valid)).to(beFalsy());
});

it(@"should take photo when attachment is a placeholder", ^{
	// given
	model = mock(MSFAttachment.class);
	stubProperty(model, isPlaceholder, @YES);
	viewModel = [[MSFAttachmentViewModel alloc] initWthAttachment:model services:services];
	
	// when
	BOOL valid = [[viewModel.takePhotoValidSignal asynchronousFirstOrDefault:nil success:nil error:nil] boolValue];
	BOOL upload = [[viewModel.uploadValidSignal asynchronousFirstOrDefault:nil success:nil error:nil] boolValue];
	BOOL download = [[viewModel.downloadValidSignal asynchronousFirstOrDefault:nil success:nil error:nil] boolValue];
	
	// then
	expect(@(valid)).to(beTruthy());
	expect(@(upload)).to(beFalsy());
	expect(@(download)).to(beFalsy());
});

it(@"should can download or upload when the attachment is not a placeholder", ^{
	// when
	BOOL upload = [[viewModel.uploadValidSignal asynchronousFirstOrDefault:nil success:nil error:nil] boolValue];
	BOOL download = [[viewModel.downloadValidSignal asynchronousFirstOrDefault:nil success:nil error:nil] boolValue];
	
	// then
	expect(@(upload)).to(beTruthy());
	expect(@(download)).to(beTruthy());
});

QuickSpecEnd
