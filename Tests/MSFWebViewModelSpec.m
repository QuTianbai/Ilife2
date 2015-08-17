//
// MSFWebViewModelSpec.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFWebViewModel.h"

QuickSpecBegin(MSFWebViewModelSpec)

__block MSFWebViewModel *viewModel;

beforeEach(^{
	viewModel = [[MSFWebViewModel alloc] initWithURL:[NSURL URLWithString:@"http://api.com"]];
});

it(@"should initialize", ^{
  // given
	NSURL *expectedURL = [NSURL URLWithString:@"http://api.com"];
	
  // then
	expect(viewModel).notTo(beNil());
	expect(viewModel.URL).to(equal(expectedURL));
});

QuickSpecEnd
