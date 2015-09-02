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
#import "MSFFormsViewModel.h"
#import "MSFApplicationForms.h"
#import "MSFResponse.h"
#import "MSFClient+Inventory.h"
#import "MSFAttachment.h"
#import "MSFInventory.h"

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
	[given([client updateInventory:viewModel.model]) willReturn:[RACSignal return:resposne]];
	
	// when
	viewModel.active = YES;
	MSFResponse *result = [[viewModel.executeUpdateCommand execute:nil] asynchronousFirstOrDefault:nil success:nil error:nil];
	
	// then
	expect(viewModel.model.attachments.firstObject).to(beAKindOf(MSFAttachment.class));
	expect(result.parsedResult[@"message"]).to(equal(@"success"));
});

QuickSpecEnd
