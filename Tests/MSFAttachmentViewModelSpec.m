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
	model = mock([MSFAttachment class]);
	
	viewModel = [[MSFAttachmentViewModel alloc] initWithModel:model services:services];
	expect(viewModel).notTo(beNil());
});

afterEach(^{
	NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"tmp.jpg"];
	[[NSFileManager defaultManager] removeItemAtPath:path error:nil];
});

it(@"should initialize", ^{
  // then
	expect(viewModel.attachment).to(equal(model));
	expect(viewModel.thumbURL).to(beNil());
	expect(viewModel.takePhotoCommand).notTo(beNil());
	expect(viewModel.uploadAttachmentCommand).notTo(beNil());
	expect(@(viewModel.isUploaded)).to(beFalsy());
	expect(@(viewModel.removeEnabled)).to(beTruthy());
});

it(@"should create placholder attachment viewModel", ^{
	// given
	stubProperty(model, isPlaceholder, @YES);
	
	// when
	viewModel = [[MSFAttachmentViewModel alloc] initWithModel:model services:services];
	
	// then
	expect(@(viewModel.removeEnabled)).to(beFalsy());
});

it(@"should create attachment viewModel", ^{
	// when
	viewModel = [[MSFAttachmentViewModel alloc] initWithModel:model services:services];
	
	// then
	expect(@(viewModel.removeEnabled)).to(beTruthy());
	expect(@(viewModel.isUploaded)).to(beFalsy());
});

it(@"should upload attachemnt's file to server", ^{
	// given
	stubProperty(model, applicationNo, @"");
	stubProperty(model, name, @"");
	stubProperty(model, isUpload, @NO);
	
	MSFAttachment *responseAttachment = mock([MSFAttachment class]);
	
	[givenVoid([model mergeAttachment:responseAttachment]) willDo:^id(NSInvocation *invocation) {
		stubProperty(model, isUpload, @YES);
		return nil;
	}];
	
	[given([services httpClient]) willReturn:client];
	[given([client uploadAttachment:model]) willReturn:[RACSignal return:responseAttachment]];
	
	viewModel = [[MSFAttachmentViewModel alloc] initWithModel:model services:services];
	
	// when
	[[viewModel.uploadAttachmentCommand execute:nil] asynchronousFirstOrDefault:nil success:nil error:nil];
	
	// then
	expect(@(model.isUpload)).to(beTruthy());
});

it(@"should change fileURL when had take photo from camera", ^{
	// given
	stubProperty(model, isPlaceholder, @YES);
	stubProperty(model, type, @"W");
	stubProperty(model, name, @"foo");
	stubProperty(model, applicationNo, @"bar");
	
	[given([services msf_takePictureSignal]) willReturn:[RACSignal return:[UIImage imageNamed:@"tmp.jpg"]]];
	
	viewModel = [[MSFAttachmentViewModel alloc] initWithModel:model services:services];
	
	// when
	BOOL success;
	NSError *error;
	MSFAttachment *attachmet = [[viewModel.takePhotoCommand execute:nil] asynchronousFirstOrDefault:nil success:&success error:&error];
	
	// then
	expect(error).to(beNil());
	expect(@(success)).to(beTruthy());
	expect(attachmet.thumbURL).notTo(beNil());
	expect(attachmet.fileURL).notTo(beNil());
	expect(attachmet.type).to(equal(@"W"));
	expect(attachmet.name).to(equal(@"foo"));
	expect(attachmet.applicationNo).to(equal(@"bar"));
});

QuickSpecEnd
