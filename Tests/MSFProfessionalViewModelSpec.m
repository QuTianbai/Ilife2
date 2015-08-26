//
// MSFProfessionalViewModelSpec.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFTestProfessionalViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFFormsViewModel.h"
#import "MSFApplicationForms.h"
#import "MSFTestAddressViewModel.h"
#import "MSFApplicationResponse.h"

QuickSpecBegin(MSFProfessionalViewModelSpec)

__block MSFTestProfessionalViewModel *viewModel;
__block MSFFormsViewModel *formsViewModel;
__block MSFApplicationForms *model;
__block MSFAddressViewModel *addressViewModel;

beforeEach(^{
	model = [[MSFApplicationForms alloc] initWithDictionary:@{} error:nil];
	formsViewModel = mock([MSFFormsViewModel class]);
	stubProperty(formsViewModel, model, model);
	addressViewModel = [[MSFTestAddressViewModel alloc] initWithAddress:nil services:nil];
	viewModel = [[MSFTestProfessionalViewModel alloc] initWithFormsViewModel:formsViewModel addressViewModel:addressViewModel];
});

it(@"should initialize", ^{
  // then
	expect(viewModel).notTo(beNil());
	expect(viewModel.formsViewModel).notTo(beNil());
	expect(viewModel.model).notTo(beNil());
});

it(@"should execute education command", ^{
	// when
	[viewModel.executeEducationCommand execute:nil];
	
	// then
	expect(viewModel.degrees).notTo(beNil());
	expect(viewModel.degreesTitle).to(equal(@"bar"));
	expect(viewModel.model.education).to(equal(@"1"));
});

it(@"should execute social status command", ^{
	// when
	[viewModel.executeSocialStatusCommand execute:nil];
	
	// then
	expect(viewModel.socialstatus).notTo(beNil());
	expect(viewModel.socialstatusTitle).to(equal(@"foo"));
	expect(viewModel.model.socialStatus).to(equal(@"1"));
});

describe(@"education", ^{
	it(@"should udpate school name", ^{
		// when
		viewModel.school = @"bar";
		
		// then
		expect(viewModel.model.universityName).to(equal(@"bar"));
	});

	it(@"should execute in school year", ^{
		// when
		viewModel.enrollmentYear = @"2015";
		
		// then
		expect(viewModel.model.enrollmentYear).to(equal(@"2015"));
	});

	it(@"should execute education system command", ^{
		// when
		[viewModel.executeEductionalSystmeCommand execute:nil];
		
		// then
		expect(viewModel.eductionalSystme).notTo(beNil());
		expect(viewModel.eductionalSystmeTitle).to(equal(@"bar"));
		expect(viewModel.model.programLength).to(equal(@"1"));
	});
});

describe(@"work", ^{
	it(@"should execute working length command", ^{
		// when
		[viewModel.executeWorkingLengthCommand execute:nil];
		
		// then
		expect(viewModel.seniority).notTo(beNil());
		expect(viewModel.seniorityTitle).to(equal(@"11"));
		expect(viewModel.model.workingLength).to(equal(@"1"));
	});
	
	it(@"should update company name", ^{
		// when
		viewModel.company = @"bar";
		
		// then
		expect(viewModel.model.company).to(equal(@"bar"));
	});

	it(@"should execute industry command", ^{
		// when
		[viewModel.executeIndustryCommand execute:nil];
		
		// then
		expect(viewModel.model.industry).to(equal(@"1"));
		expect(viewModel.industryTitle).to(equal(@"bar"));
	});

	it(@"should execute nature command", ^{
		// when
		[viewModel.executeNatureCommand execute:nil];
		
		// then
		expect(viewModel.model.companyType).to(equal(@"1"));
	});
	
	it(@"should update department title", ^{
		// when
		viewModel.departmentTitle = @"foo";
		
		// then
		expect(viewModel.model.department).to(equal(@"foo"));
	});
	
	it(@"should update start work date", ^{
		// when
		viewModel.startedDate = @"2015-05";
		
		// then
		expect(viewModel.model.currentJobDate).to(equal(@"2015-05"));
	});
	
	it(@"should update telephone informations", ^{
		// given
		
		// when
		viewModel.unitAreaCode = @"023";
		viewModel.unitTelephone = @"6445";
		viewModel.unitExtensionTelephone = @"1234";
		
		// then
		expect(viewModel.model.unitAreaCode).to(equal(@"023"));
		expect(viewModel.model.unitTelephone).to(equal(@"6445"));
		expect(viewModel.model.unitExtensionTelephone).to(equal(@"1234"));
	});
	
	it(@"should has unit address", ^{
		// when
		[viewModel.executeAddressCommand execute:nil];
		
		// then
		expect(viewModel.address).to(equal(@"重庆市直辖市沙坪坝区"));
	});
	
	it(@"should has workTown", ^{
		// when
		viewModel.model.workTown = @"foo";
		
		// then
		expect(viewModel.model.workTown).to(equal(@"foo"));
	});
});

it(@"should commit professional information", ^{
	// given
	[given([viewModel.formsViewModel submitSignalWithPage:3]) willDo:^id(NSInvocation *invocation) {
		MSFApplicationResponse *model = [MTLJSONAdapter modelOfClass:[MSFApplicationResponse class] fromJSONDictionary:@{
			@"applyNo": @"20150821000368",
			@"id": @368,
			@"personId": @388
		} error:nil];
		return [RACSignal return:model];
	}];
	
	BOOL sucess = NO;
	NSError *error = nil;
	
	// when
	[viewModel.executeEducationCommand execute:nil];
	[viewModel.executeSocialStatusCommand execute:nil];
	[[viewModel.executeCommitCommand execute:nil] asynchronousFirstOrDefault:nil success:&sucess error:&error];
	
	// then
	expect(@(sucess)).to(beTruthy());
	expect(error).to(beNil());
});

QuickSpecEnd
