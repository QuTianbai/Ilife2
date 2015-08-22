//
// MSFPersonalViewModelSpec.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFPersonalViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFFormsViewModel.h"
#import "MSFApplicationForms.h"
#import "MSFTestAddressViewModel.h"
#import "MSFApplicationResponse.h"

QuickSpecBegin(MSFPersonalViewModelSpec)

__block MSFPersonalViewModel *viewModel;
__block MSFApplicationForms *model;

beforeEach(^{
	NSURL *URL = [[NSBundle bundleForClass:self.class] URLForResource:@"form" withExtension:@"json"];
	NSData *data = [NSData dataWithContentsOfURL:URL];
	NSDictionary *representation = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
	model = [MTLJSONAdapter modelOfClass:[MSFApplicationForms class] fromJSONDictionary:representation error:nil];
	
	MSFFormsViewModel *formsViewModel = mock([MSFFormsViewModel class]);
	id <MSFViewModelServices> services = mockProtocol(@protocol(MSFViewModelServices));
	stubProperty(formsViewModel, services, services);
	stubProperty(formsViewModel, model, model);
	MSFTestAddressViewModel *addressViewModel = [[MSFTestAddressViewModel alloc] initWithAddress:nil services:nil];
	viewModel = [[MSFPersonalViewModel alloc] initWithFormsViewModel:formsViewModel addressViewModel:addressViewModel];
});

it(@"should initialize", ^{
  // then
	expect(viewModel).notTo(beNil());
	expect(viewModel.address).to(equal(@""));
	expect(viewModel.formsViewModel).notTo(beNil());
	expect(viewModel.addressViewModel).notTo(beNil());
	expect(viewModel.services).notTo(beNil());
	expect(viewModel.model).notTo(beNil());
});

it(@"should update address", ^{
	// when
	[[viewModel.executeAlterAddressCommand execute:nil] asynchronousFirstOrDefault:nil success:nil error:nil];
	
	// then
	expect(viewModel.address).to(equal(@"重庆市直辖市沙坪坝区"));
});

it(@"should submit personal information", ^{
	// given
	[given([viewModel.formsViewModel submitSignalWithPage:2]) willDo:^id(NSInvocation *invocation) {
		MSFApplicationResponse *model = [MTLJSONAdapter modelOfClass:[MSFApplicationResponse class] fromJSONDictionary:@{
			@"applyNo": @"20150821000368",
			@"id": @368,
			@"personId": @388
		} error:nil];
		return [RACSignal return:model];
	}];
	
	model.income = @"1000";
	model.familyExpense = @"0";
	model.otherIncome = @"100";
	model.homeCode = @"023";
	model.homeLine = @"64649999";
	model.email = @"gitmac@qq.com";
	model.currentTown = @"foo";
	model.currentStreet = @"bar";
	
	[[viewModel.executeAlterAddressCommand execute:nil] asynchronousFirstOrDefault:nil success:nil error:nil];
	
	BOOL success = NO;
	NSError *error = nil;
	
	// when
	MSFApplicationResponse *response = [[viewModel.executeCommitCommand execute:nil] asynchronousFirstOrDefault:nil success:&success error:&error];
	
	// then
	expect(@(success)).to(beTruthy());
	expect(error).to(beNil());
	expect(response.applyNo).to(equal(@"20150821000368"));
	expect(response.applyID).to(equal(@"368"));
	expect(response.personId).to(equal(@"388"));
});

it(@"should not accept with error QQ", ^{
	// given
	NSError *error = nil;
	
	model.income = @"1000";
	model.familyExpense = @"0";
	model.otherIncome = @"100";
	model.homeCode = @"023";
	model.homeLine = @"64649999";
	model.email = @"gitmac@qq.com";
	model.currentTown = @"foo";
	model.currentStreet = @"bar";
	
	// when
	model.qq = @"123";
	[[viewModel.executeAlterAddressCommand execute:nil] asynchronousFirstOrDefault:nil success:nil error:nil];
	[[viewModel.executeCommitCommand execute:nil] asynchronousFirstOrDefault:nil success:nil error:&error];
	
	// then
	expect(error.userInfo[NSLocalizedFailureReasonErrorKey]).to(equal(@"请输入正确的QQ号"));
});

it(@"should accept none home telephone", ^{
	// given
	[given([viewModel.formsViewModel submitSignalWithPage:2]) willDo:^id(NSInvocation *invocation) {
		MSFApplicationResponse *model = [MTLJSONAdapter modelOfClass:[MSFApplicationResponse class] fromJSONDictionary:@{
			@"applyNo": @"20150821000368",
			@"id": @368,
			@"personId": @388
		} error:nil];
		return [RACSignal return:model];
	}];
	
	NSError *error = nil;
	
	model.income = @"1000";
	model.familyExpense = @"0";
	model.otherIncome = @"100";
	model.email = @"gitmac@qq.com";
	model.currentTown = @"foo";
	model.currentStreet = @"bar";
	model.qq = @"12345";
	
	// when
	model.homeCode = @"";
	model.homeLine = @"";
	
	[[viewModel.executeAlterAddressCommand execute:nil] asynchronousFirstOrDefault:nil success:nil error:nil];
	[[viewModel.executeCommitCommand execute:nil] asynchronousFirstOrDefault:nil success:nil error:&error];
	
	// then
	expect(error).to(beNil());
});

QuickSpecEnd
