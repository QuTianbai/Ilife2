//
// MSFLoanViewModelSpec.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFLoanViewModel.h"
#import "MSFApplyList.h"

QuickSpecBegin(MSFLoanViewModelSpec)

__block MSFLoanViewModel *viewModel;

beforeEach(^{
  NSURL *URL = [[NSBundle bundleForClass:self.class] URLForResource:@"applyList" withExtension:@"json"];
  NSData *data = [NSData dataWithContentsOfURL:URL];
  NSDictionary *representation = [[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil] firstObject];
  MSFApplyList *model = [MTLJSONAdapter modelOfClass:MSFApplyList.class fromJSONDictionary:representation error:nil];
  viewModel = [[MSFLoanViewModel alloc] initWithModel:model services:nil];
});

it(@"should initialize", ^{
  // then
  expect(viewModel).notTo(beNil());
  expect(viewModel.status).to(equal(@"无效"));
  expect(viewModel.applyDate).to(equal(@"2015年05月03日"));
  expect(viewModel.repaidAmount).to(equal(@"200"));
  expect(viewModel.totalAmount).to(equal(@"300"));
  expect(viewModel.mothlyRepaymentAmount).to(equal(@"400"));
  expect(viewModel.totalInstallments).to(equal(@"10"));
  expect(viewModel.currentInstallment).to(equal(@"4"));
});

QuickSpecEnd
