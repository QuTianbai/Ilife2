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
	viewModel = [[MSFAttachmentViewModel alloc] initWthAttachment:model services:services];
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
	expect(@(viewModel.isUploaded)).to(beFalsy());
	expect(viewModel.takePhotoCommand).notTo(beNil());
	expect(viewModel.uploadAttachmentCommand).notTo(beNil());
	expect(viewModel.downloadAttachmentCommand).notTo(beNil());
	expect(@(viewModel.isUploaded)).to(beFalsy());
	expect(@(viewModel.removeEnabled)).to(beTruthy());
});

describe(@"attachment from server", ^{
	it(@"should download picture", ^{
		// given
		NSURL *URL = [[NSBundle bundleForClass:self.class] URLForResource:@"tmp" withExtension:@"jpg"];
		[given([services httpClient]) willReturn:client];
		[given([client downloadAttachment:model]) willDo:^id(NSInvocation *invocation) {
			stubProperty(model, thumbURL, URL);
			stubProperty(model, fileURL, URL);
			return [RACSignal return:UIImageJPEGRepresentation([UIImage imageNamed:@"tmp.jpg"], 1)];
		}];
		
		// when
		[[viewModel.downloadAttachmentCommand execute:nil] asynchronousFirstOrDefault:nil success:nil error:nil];
		
		// then
		expect(viewModel.attachment.thumbURL).notTo(beNil());
		expect(viewModel.attachment.fileURL).notTo(beNil());
	});
});

describe(@"attachment from camera", ^{
	it(@"should upload picture", ^{
		// given
		MSFAttachment *attachment = [[MSFAttachment alloc] initWithDictionary:@{
			@"objectID": @"3033",
			@"type": @"image/jpg",
			@"name": @"foo.jpg",
		} error:nil];
		
		NSURL *URL = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"temp.jpg"]];
		stubProperty(model, fileURL, URL);
		stubProperty(model, thumbURL, URL);
		
		
		[given([services httpClient]) willReturn:client];
		[given([client uploadAttachment:model]) willDo:^id(NSInvocation *invocation) {
			[givenVoid([model mergeValueForKey:@"objectID" fromModel:attachment]) willDo:^id(NSInvocation *invocation) {
				stubProperty(model, objectID, @"3033");
				return nil;
			}];
			[givenVoid([model mergeValueForKey:@"type" fromModel:attachment]) willDo:^id(NSInvocation *invocation) {
				stubProperty(model, contentType, @"image/jpg");
				return nil;
			}];
			[givenVoid([model mergeValueForKey:@"name" fromModel:attachment]) willDo:^id(NSInvocation *invocation) {
				stubProperty(model, name, @"foo.jpg");
				return nil;
			}];
			return [RACSignal return:attachment];
		}];
		
		// when
		[[viewModel.uploadAttachmentCommand execute:nil] asynchronousFirstOrDefault:nil success:nil error:nil];
		
		// then
		expect(viewModel.attachment.objectID).to(equal(@"3033"));
		expect(viewModel.attachment.contentType).to(equal(@"image/jpg"));
		expect(viewModel.attachment.name).to(equal(@"foo.jpg"));
		expect(viewModel.attachment.fileURL).to(equal(URL));
		expect(viewModel.attachment.thumbURL).to(equal(URL));
	});
});

describe(@"attachment placholder", ^{
	it(@"should take photo from camera and album", ^{
		// given
		stubProperty(model, isPlaceholder, @YES);
		stubProperty(model, thumbURL, [[NSBundle bundleForClass:self.class] URLForResource:@"tmp" withExtension:@"jpg"]);
		
		viewModel = [[MSFAttachmentViewModel alloc] initWthAttachment:model services:services];
		[given([services takePicture]) willReturn:[RACSignal return:[UIImage imageNamed:@"tmp.jpg"]]];
		
		// when
		[[viewModel.takePhotoCommand execute:nil] asynchronousFirstOrDefault:nil success:nil error:nil];
		
		// then
		expect(viewModel.fileURL).notTo(beNil());
	});
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

it(@"should can't upload when attachent is downloaded file", ^{
	// given
	stubProperty(model, objectID, @"foo");
	
	// when
	BOOL upload = [[viewModel.uploadValidSignal asynchronousFirstOrDefault:nil success:nil error:nil] boolValue];
	
	// then
	expect(@(upload)).to(beFalsy());
});

it(@"should can't download when attachment file download", ^{
	// given
	NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"tmp.jpg"];
	[[NSFileManager defaultManager] createFileAtPath:path contents:UIImageJPEGRepresentation([UIImage imageNamed:@"tmp.jpg"], 1) attributes:nil];
	
	expect(@([[NSFileManager defaultManager] fileExistsAtPath:path])).to(beTruthy());
	
	stubProperty(model, name, @"tmp.jpg");
	
	// when
	BOOL download = [[viewModel.downloadValidSignal asynchronousFirstOrDefault:nil success:nil error:nil] boolValue];
	
	// then
	expect(@(download)).to(beFalsy());
});

QuickSpecEnd
