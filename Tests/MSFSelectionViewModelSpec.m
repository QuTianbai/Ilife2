//
// MSFSelectionViewModelSpec.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFSelectionViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

QuickSpecBegin(MSFSelectionViewModelSpec)

__block MSFSelectionViewModel *viewModel;

beforeEach(^{
  viewModel = [[MSFSelectionViewModel alloc] init];
});

it(@"should initialize", ^{
  // then
  expect(viewModel).notTo(beNil());
});

it(@"should has number of sections", ^{
  // then
  expect(@(viewModel.numberOfSections)).to(equal(@1));
});

it(@"should has number of items in section", ^{
  // then
  expect(@([viewModel numberOfItemsInSection:0])).to(equal(@0));
});

QuickSpecEnd
