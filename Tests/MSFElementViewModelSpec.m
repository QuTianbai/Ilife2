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

QuickSpecBegin(MSFElementViewModelSpec)

__block MSFElementViewModel *viewModel;
__block id <MSFViewModelServices> services;
__block MSFElement *element;

beforeEach(^{
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
	stubProperty(attachment, objectID, @"10");
	
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

QuickSpecEnd
