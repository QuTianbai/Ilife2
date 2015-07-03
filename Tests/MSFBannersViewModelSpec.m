//
// MSFBannersViewModelSpec.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFBannersViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFClient.h"
#import "MSFClient+MSFAdver.h"
#import "MSFResponse.h"
#import "MSFAdver.h"

QuickSpecBegin(MSFBannersViewModelSpec)

__block MSFBannersViewModel *viewModel;
__block MSFClient *client;

beforeEach(^{
  client = mock(MSFClient.class);
  viewModel = [[MSFBannersViewModel alloc] initWithClient:client];
});

it(@"should initialize", ^{
  // then
  expect(viewModel).notTo(beNil());
  expect(viewModel.client).notTo(beNil());
});

it(@"should return number of section", ^{
  // given
  
  // when
  
  // then
  expect(@(viewModel.numberOfSections)).to(equal(@1));
});

it(@"should return 1 row in section 0", ^{
  // given
  MSFAdver *ad = mock(MSFAdver.class);
  RACSignal *signal = [RACSignal return:ad];
  
  [given([client fetchAdverWithCategory:@"1"]) willReturn:signal];
  
  // when
  [viewModel setActive:YES];
  NSInteger items = [viewModel numberOfItemsInSection:0];
  
  // then
  expect(@(items)).to(equal(@1));
});

it(@"should return image of the object at that index path", ^{
  // given
  MSFAdver *ad = mock(MSFAdver.class);
  stubProperty(ad, imgURL, [NSURL URLWithString:@"http://avatar.png"]);
  RACSignal *signal = [RACSignal return:ad];
  [given([client fetchAdverWithCategory:@"1"]) willReturn:signal];
  
  // when
  [viewModel setActive:YES];
  
  // then
  NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
  NSURL *imageURL = [viewModel imageURLAtIndexPath:indexPath];
  
  expect(imageURL).to(equal([NSURL URLWithString:@"http://avatar.png"]));
});

it(@"should return web html url of the object at that index path", ^{
  // given
  MSFAdver *ad = mock(MSFAdver.class);
  stubProperty(ad, adURL, [NSURL URLWithString:@"http://avatar.png"]);
  RACSignal *signal = [RACSignal return:ad];
  [given([client fetchAdverWithCategory:@"1"]) willReturn:signal];
  
  // when
  [viewModel setActive:YES];
  
  // then
  NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
  NSURL *HTMLURL = [viewModel HTMLURLAtIndexPath:indexPath];
  
  expect(HTMLURL).to(equal([NSURL URLWithString:@"http://avatar.png"]));
});

QuickSpecEnd
