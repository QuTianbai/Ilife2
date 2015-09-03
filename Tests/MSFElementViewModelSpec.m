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

beforeEach(^{
	MSFElement *element = mock(MSFElement.class);
	stubProperty(element, required, @YES);
	stubProperty(element, plain, @"身份证验证");
	stubProperty(element, type, @"bar");
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
	expect(viewModel.viewModels).to(equal(@[]));
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
	MSFAttachment *attachment = [[MSFAttachment alloc] initWithDictionary:@{} error:nil];
	
	// when
	[viewModel addAttachment:attachment];
	[viewModel removeAttachment:attachment];
	
	// then
	expect(@(viewModel.viewModels.count)).to(equal(@0));
});

it(@"should has a sampleURL for example view", ^{
	// then
	expect(viewModel.sampleURL).notTo(beNil());
});

QuickSpecEnd
