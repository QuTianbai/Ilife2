//
//  MSFRelationViewModelSpec.m
//  Cash
//
//  Created by xutian on 15/6/15.
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFRelationMemberViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <OHHTTPStubs/OHHTTPStubs.h>

QuickSpecBegin(MSFRelationViewModelSpec)

__block MSFRelationMemberViewModel *viewModel;

beforeEach(^{
  viewModel = [[MSFRelationMemberViewModel alloc] init];
});

it(@"should initialize", ^{
  // then
  expect(viewModel).notTo(beNil());
});



QuickSpecEnd