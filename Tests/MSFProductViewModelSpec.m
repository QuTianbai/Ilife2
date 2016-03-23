//
// MSFAFRequestViewModelSpec.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFProductViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFApplicationForms.h"
#import "MSFProduct.h"
#import "MSFClient+Months.h"
#import "MSFClient.h"
#import "MSFResponse.h"
#import "MSFSelectKeyValues.h"
#import "MSFApplicationResponse.h"
#import "MSFClient+MSFApplyCash.h"
#import "MSFFormsViewModel.h"
#import "MSFUser.h"
#import "MSFServer.h"

QuickSpecBegin(MSFProductViewModelSpec)

__block MSFProductViewModel *viewModel;
__block MSFClient *client;

beforeEach(^{
	NSURL *URL = [[NSBundle bundleForClass:self.class] URLForResource:@"loadinfo" withExtension:@"json"];
	NSData *data = [NSData dataWithContentsOfURL:URL];
	expect(data).notTo(beNil());
	
	NSDictionary *representation = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
	MSFApplicationForms *forms = [MTLJSONAdapter modelOfClass:[MSFApplicationForms class] fromJSONDictionary:representation error:nil];
	expect(forms).notTo(beNil());
	
	MSFUser *user = mock([MSFUser class]);
	stubProperty(user, server, MSFServer.dotComServer);
	client = [MSFClient authenticatedClientWithUser:user token:@"" session:@""];
	
	id <MSFViewModelServices> services  = mockProtocol(@protocol(MSFViewModelServices));
	[given([services httpClient]) willReturn:client];
	
	MSFFormsViewModel *formsViewModel = [[MSFFormsViewModel alloc] initWithServices:services];
	stubProperty(formsViewModel, model, forms);
	viewModel = [[MSFProductViewModel alloc] initWithFormsViewModel:formsViewModel];
});

it(@"should initialize", ^{
	// then
	expect(viewModel).notTo(beNil());
});


QuickSpecEnd
