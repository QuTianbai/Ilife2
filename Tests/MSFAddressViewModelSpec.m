//
// MSFAddressViewModelSpec.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFTestAddressViewModel.h"
#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFAreas.h"
#import "MSFAddress.h"

QuickSpecBegin(MSFAddressViewModelSpec)

__block MSFTestAddressViewModel *viewModel;
__block UIViewController *contentViewContrller;

beforeEach(^{
	contentViewContrller = mock(UIViewController.class);
	id <MSFViewModelServices> services = mockProtocol(@protocol(MSFViewModelServices));
	viewModel = [[MSFTestAddressViewModel alloc] initWithServices:services];
});

it(@"should initialize", ^{
	expect(viewModel).notTo(beNil());
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
	expect(viewModel.address).to(equal(@"重庆市直辖市"));
});

it(@"should has right address", ^{
	// when
	[viewModel.selectCommand execute:nil];
	
	// then
	expect(viewModel.address).to(equal(@"重庆市直辖市"));
	expect(viewModel.provinceName).to(equal(@"重庆市"));
	expect(viewModel.cityName).to(equal(@"直辖市"));
	expect(viewModel.areaName).to(beNil());
});

it(@"should create viewmodel with initialize address", ^{
	// given
	MSFAddress *address = mock([MSFAddress class]);
	stubProperty(address, province, @"0");
	stubProperty(address, city, @"1");
	stubProperty(address, area, @"2");
	
	// when
	viewModel = [[MSFTestAddressViewModel alloc] initWithAddress:address services:nil];
	
	// then
	expect(viewModel.address).to(equal(@"重庆市直辖市沙坪坝区"));
	expect(viewModel.provinceCode).to(equal(@"0"));
	expect(viewModel.cityCode).to(equal(@"1"));
	expect(viewModel.areaCode).to(equal(@"2"));
});

QuickSpecEnd
