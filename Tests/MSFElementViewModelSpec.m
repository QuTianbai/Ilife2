//
// MSFElementViewModelSpec.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFElementViewModel.h"
#import "MSFElement.h"
#import "MSFAttachment.h"
#import "MSFViewModelServices.h"

QuickSpecBegin(MSFElementViewModelSpec)

__block MSFElementViewModel *viewModel;
__block id <MSFViewModelServices> services;

beforeEach(^{
	MSFElement *element = mock(MSFElement.class);
	stubProperty(element, plain, @"身份证验证");
	stubProperty(element, thumbURL, [NSURL URLWithString:@"http://icon.png"]);
	viewModel = [[MSFElementViewModel alloc] initWithServices:services model:element];
	expect(viewModel).notTo(beNil());
});

it(@"should initialize", ^{
  // then
	expect(viewModel.title).to(equal(@"身份证验证"));
	expect(viewModel.thumbURL).to(equal([NSURL URLWithString:@"http://icon.png"]));
	expect(@(viewModel.validity)).to(beFalsy());
});

it(@"should associate attachments", ^{
	// when
	viewModel.attachments = @[[[MSFAttachment alloc] init]];
	
	// then
	expect(@(viewModel.validity)).to(beTruthy());
});

QuickSpecEnd
