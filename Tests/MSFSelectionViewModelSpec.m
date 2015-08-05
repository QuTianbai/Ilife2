//
// MSFSelectionViewModelSpec.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFSelectionViewModel.h"
#import "MSFMarket.h"
#import "MSFTeams.h"
#import "MSFProduct.h"

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

it(@"should get terms items", ^{
  // given
  NSURL *URL = [[NSBundle bundleForClass:self.class] URLForResource:@"checkemployee" withExtension:@"json"];
  NSData *data = [NSData dataWithContentsOfURL:URL];
  NSDictionary *representation = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
  expect(representation).to(beAKindOf(NSDictionary.class));
  
  MSFMarket *employee = [MTLJSONAdapter modelOfClass:MSFMarket.class fromJSONDictionary:representation error:nil];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
  
  // when
  viewModel = [MSFSelectionViewModel monthsViewModelWithProducts:employee total:3000];
  
  // then
  expect(@(employee.teams.count)).notTo(equal(@0));
  expect(employee.teams.firstObject).to(beAKindOf(MSFTeams.class));
  MSFTeams *team = employee.teams.firstObject;
  expect(@(team.team.count)).notTo(equal(@0));
	MSFProduct *product = team.team.firstObject;
	expect(product.productId).to(equal(@"59"));
	expect(product.period).to(equal(@"9"));
	
  expect(@([viewModel numberOfItemsInSection:0])).notTo(equal(@0));
  expect([viewModel titleForIndexPath:indexPath]).to(equal(@"3个月"));
  expect([viewModel modelForIndexPath:indexPath]).notTo(beNil());
});

QuickSpecEnd
