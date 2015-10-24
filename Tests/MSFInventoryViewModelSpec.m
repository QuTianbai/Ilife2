//
// MSFInventoryViewModelSpec.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFInventoryViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFViewModelServices.h"
#import "MSFClient.h"
#import "MSFClient+Elements.h"
#import "MSFProduct.h"
#import "MSFElement.h"
#import "MSFElementViewModel.h"
#import "MSFFormsViewModel.h"
#import "MSFApplicationForms.h"
#import "MSFResponse.h"
#import "MSFAttachment.h"
#import "MSFClient+MSFApplyCash.h"
#import "MSFApplicationResponse.h"
#import "MSFApplyCashVIewModel.h"

QuickSpecBegin(MSFInventoryViewModelSpec)

__block MSFInventoryViewModel *viewModel;
__block id <MSFViewModelServices> services;
__block MSFClient *client;
__block MSFFormsViewModel *formsViewModel;
__block MSFApplicationForms *form;
__block MSFApplyCashVIewModel *cashViewModel;

beforeEach(^{
	client = mock(MSFClient.class);
	services = mockProtocol(@protocol(MSFViewModelServices));
	[given([services httpClient]) willReturn:client];
	
	form = mock(MSFApplicationForms.class);
	
	formsViewModel = mock(MSFFormsViewModel.class);
	stubProperty(formsViewModel, model, form);
	[given([formsViewModel services]) willReturn:services];
	
	cashViewModel = mock([MSFApplyCashVIewModel class]);
	stubProperty(cashViewModel, services, services);
	stubProperty(cashViewModel, formViewModel, formsViewModel);
	
	viewModel = [[MSFInventoryViewModel alloc] initWithCashViewModel:cashViewModel];
	expect(viewModel).notTo(beNil());
});

afterEach(^{
	[NSFileManager.defaultManager removeItemAtPath:NSTemporaryDirectory() error:nil];
});

it(@"should initialize", ^{
	// then
	expect(viewModel).notTo(beNil());
	expect(viewModel.executeUpdateCommand).notTo(beNil());
});

it(@"should fetch required element viewmodels", ^{
	// given
	MSFElement *element = mock([MSFElement class]);
	stubProperty(element, required, @YES);
	[given([client fetchElementsWithProduct:nil amount:cashViewModel.appLmt term:cashViewModel.loanTerm]) willReturn:[RACSignal return:element]];
	
	// when
	viewModel.active = YES;
	
	// then
	expect(viewModel.viewModels).notTo(beNil());
	expect(@(viewModel.requiredViewModels.count)).to(equal(@1));
});

it(@"should fetch optional element viewmodels", ^{
	// given
	MSFElement *element = mock([MSFElement class]);
	stubProperty(element, required, @NO);
	[given([client fetchElementsWithProduct:nil amount:cashViewModel.appLmt term:cashViewModel.loanTerm]) willReturn:[RACSignal return:element]];
	
	// when
	viewModel.active = YES;
	
	// then
	expect(viewModel.viewModels).notTo(beNil());
	expect(@(viewModel.optionalViewModels.count)).to(equal(@1));
});

it(@"should update inventory to server", ^{
	// given
	MSFElement *element = [[MSFElement alloc] initWithDictionary:@{@"type": @"IMG"} error:nil];
	[given([client fetchElementsWithProduct:nil amount:cashViewModel.appLmt term:cashViewModel.loanTerm]) willReturn:[RACSignal return:element]];
	
	MSFAttachment *attachment = mock(MSFAttachment.class);
	stubProperty(attachment, fileID, @"foo");
	stubProperty(attachment, type, @"IMG");
	stubProperty(attachment, objectID, @"foo"); // 附件已上传标志
	
	// when
	viewModel.active = YES;
	MSFElementViewModel *elementViewModel = viewModel.viewModels.firstObject;
	expect(elementViewModel).notTo(beNil());
	
	[elementViewModel addAttachment:attachment];
	
	expect(@(elementViewModel.viewModels.count)).to(equal(@2));
	
	NSError *error;
	NSArray *attachments = [[viewModel.executeUpdateCommand execute:nil] asynchronousFirstOrDefault:nil success:nil error:&error];
	
	// then
	expect(error).to(beNil());
	
	expect(@(attachments.count)).to(equal(@1));
});

QuickSpecEnd
