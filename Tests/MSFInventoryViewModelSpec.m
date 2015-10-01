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
#import "MSFClient+Inventory.h"
#import "MSFAttachment.h"
#import "MSFInventory.h"
#import "MSFClient+MSFApplyCash.h"
#import "MSFApplicationResponse.h"

QuickSpecBegin(MSFInventoryViewModelSpec)

__block MSFInventoryViewModel *viewModel;
__block id <MSFViewModelServices> services;
__block MSFClient *client;
__block MSFFormsViewModel *formsViewModel;
__block MSFApplicationForms *form;

beforeEach(^{
	client = mock(MSFClient.class);
	services = mockProtocol(@protocol(MSFViewModelServices));
	[given([services httpClient]) willReturn:client];
	
	form = mock(MSFApplicationForms.class);
	stubProperty(form, productId, @"102");
	stubProperty(form, applyNo, @"10000");
	
	formsViewModel = mock(MSFFormsViewModel.class);
	stubProperty(formsViewModel, model, form);
	[given([formsViewModel services]) willReturn:services];
	
	viewModel = [[MSFInventoryViewModel alloc] initWithFormsViewModel:formsViewModel];
	expect(viewModel).notTo(beNil());
});

afterEach(^{
	[NSFileManager.defaultManager removeItemAtPath:NSTemporaryDirectory() error:nil];
});

it(@"should initialize", ^{
	// then
	expect(viewModel).notTo(beNil());
	expect(viewModel.executeUpdateCommand).notTo(beNil());
	expect(viewModel.product.productId).to(equal(@"102"));
});

it(@"should fetch required element viewmodels", ^{
	// given
	MSFElement *element = mock([MSFElement class]);
	stubProperty(element, required, @YES);
	[given([client fetchElementsWithProduct:viewModel.product]) willReturn:[RACSignal return:element]];
	
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
	[given([client fetchElementsWithProduct:viewModel.product]) willReturn:[RACSignal return:element]];
	
	// when
	viewModel.active = YES;
	
	// then
	expect(viewModel.viewModels).notTo(beNil());
	expect(@(viewModel.optionalViewModels.count)).to(equal(@1));
});

it(@"should update inventory to server", ^{
	// given
	MSFElement *element = [[MSFElement alloc] initWithDictionary:@{@"type": @"IMG"} error:nil];
	[given([client fetchElementsWithProduct:viewModel.product]) willReturn:[RACSignal return:element]];
	
	MSFAttachment *attachment = [[MSFAttachment alloc] initWithDictionary:@{@"objectID": @"100", @"type": @"IMG"} error:nil];
	[given([client fetchAttachmentsWithCredit:viewModel.credit]) willReturn:[RACSignal return:attachment]];
	
	MSFResponse *resposne = mock([MSFResponse class]);
	stubProperty(resposne, parsedResult, @{@"message": @"success"});
	MSFApplicationResponse *credit = mock([MSFApplicationResponse class]);
	[given([client updateInventory:viewModel.model]) willReturn:[RACSignal return:resposne]];
	[given([formsViewModel submitSignalWithPage:5]) willReturn:[RACSignal return:credit]];
	
	NSError *error;
	// when
	viewModel.active = YES;
	RACTuple *tuple = [[viewModel.executeUpdateCommand execute:nil] asynchronousFirstOrDefault:nil success:nil error:&error];
	MSFResponse *result = tuple.first;
	
	// then
	expect(error).to(beNil());
	expect(tuple).notTo(beNil());
	expect(viewModel.model.attachments.firstObject).to(beAKindOf(MSFAttachment.class));
	expect(result.parsedResult[@"message"]).to(equal(@"success"));
});

it(@"should get error when required element doese not have attachment", ^{
	// given
	MSFResponse *resposne = mock([MSFResponse class]);
	stubProperty(resposne, parsedResult, @{@"message": @"success"});
	[given([client updateInventory:viewModel.model]) willReturn:[RACSignal return:resposne]];
	
	MSFApplicationResponse *credit = mock([MSFApplicationResponse class]);
	[given([formsViewModel submitSignalWithPage:5]) willReturn:[RACSignal return:credit]];
	
	MSFElement *mockElement = mock([MSFElement class]);
	stubProperty(mockElement, required, @YES);
	stubProperty(mockElement, type, @"foo");
	stubProperty(mockElement, plain, @"bar");
	
	MSFElement *mockElement2 = mock([MSFElement class]);
	stubProperty(mockElement2, required, @NO);
	stubProperty(mockElement2, type, @"foo");
	
	NSArray *elements = @[mockElement, mockElement2];
	[given([client fetchElementsWithProduct:viewModel.product]) willReturn:elements.rac_sequence.signal.replay];
	
	// when
	viewModel.active = YES;
	
	MSFElementViewModel *optionalViewModel = viewModel.optionalViewModels.firstObject;
	MSFAttachment *mockAttachment = mock([MSFAttachment class]);
	stubProperty(mockAttachment, type, @"foo");
	stubProperty(mockAttachment, objectID, @"123");
	[optionalViewModel addAttachment:mockAttachment];
	
	NSError *error;
	BOOL success = NO;
	[[viewModel.executeUpdateCommand execute:nil] asynchronousFirstOrDefault:nil success:&success error:&error];
	
	// then
	expect(@(viewModel.viewModels.count)).notTo(equal(@0));
	expect(@(success)).to(beFalsy());
	expect(error.userInfo[NSLocalizedFailureReasonErrorKey]).to(equal(@"请添加“bar”"));
	expect(@(viewModel.requiredViewModels.count)).to(equal(@1));
});

it(@"should update inventory when required elements have attachment", ^{
	// given
	MSFResponse *resposne = mock([MSFResponse class]);
	stubProperty(resposne, parsedResult, @{@"message": @"success"});
	[given([client updateInventory:viewModel.model]) willReturn:[RACSignal return:resposne]];
	
	MSFApplicationResponse *credit = mock([MSFApplicationResponse class]);
	[given([formsViewModel submitSignalWithPage:5]) willReturn:[RACSignal return:credit]];
	
	MSFElement *mockElement = mock([MSFElement class]);
	stubProperty(mockElement, required, @YES);
	stubProperty(mockElement, type, @"foo");
	stubProperty(mockElement, plain, @"bar");
	
	MSFElement *mockElement2 = mock([MSFElement class]);
	stubProperty(mockElement2, required, @NO);
	stubProperty(mockElement2, type, @"foo");
	
	NSArray *elements = @[mockElement, mockElement2];
	[given([client fetchElementsWithProduct:viewModel.product]) willReturn:elements.rac_sequence.signal.replay];
	
	// when
	viewModel.active = YES;
	
	MSFElementViewModel *requiredViewModel = viewModel.requiredViewModels.firstObject;
	MSFAttachment *mockAttachment = mock([MSFAttachment class]);
	stubProperty(mockAttachment, type, @"foo");
	stubProperty(mockAttachment, objectID, @"123");
	[requiredViewModel addAttachment:mockAttachment];
	
	NSError *error;
	[[viewModel.executeUpdateCommand execute:nil] asynchronousFirstOrDefault:nil success:nil error:&error];
	
	// then
	expect(error).to(beNil());
	expect(@(viewModel.requiredViewModels.count)).to(equal(@1));
});

QuickSpecEnd
