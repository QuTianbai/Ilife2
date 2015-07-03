//
// MSFAddressViewModelSpec.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFTestAddressViewModel.h"
#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFAreas.h"

QuickSpecBegin(MSFAddressViewModelSpec)

__block MSFTestAddressViewModel *viewModel;
__block UIViewController *contentViewContrller;

beforeEach(^{
	contentViewContrller = mock(UIViewController.class);
	viewModel = [[MSFTestAddressViewModel alloc] initWithController:contentViewContrller];
});

it(@"should initialize", ^{
	expect(viewModel).notTo(beNil());
	expect(viewModel.viewController).notTo(beNil());
});

it(@"should has province", ^{
  // given
	MSFAreas *province = mock(MSFAreas.class);
	
  // when
	viewModel.province = province;
  
  // then
	expect(viewModel.province).notTo(beNil());
});

it(@"should has city", ^{
  // given
	MSFAreas *city = mock(MSFAreas.class);
	
  // when
	viewModel.city = city;
  
  // then
	expect(viewModel.city).notTo(beNil());
});

it(@"should has area", ^{
  // given
	MSFAreas *area = mock(MSFAreas.class);
	
  // when
	viewModel.area = area;
  
  // then
	expect(viewModel.area).notTo(beNil());
});

it(@"should has address", ^{
  // then
	expect(viewModel.address).to(equal(@""));
});

it(@"should execute select command", ^{
  // when
	[viewModel.selectCommand execute:nil];
	
  // then
	expect(viewModel.address).to(equal(@"重庆市直辖市沙坪坝区"));
});

QuickSpecEnd
