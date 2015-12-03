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
#import "MSFElement.h"
#import "MSFElementViewModel.h"
#import "MSFApplicationForms.h"
#import "MSFResponse.h"
#import "MSFAttachment.h"
#import "MSFElement+Private.h"
#import "MSFApplyCashVIewModel.h"
#import "MSFLoanType.h"
#import "NSFileManager+Temporary.h"
#import "MSFClient+Inventory.h"

QuickSpecBegin(MSFInventoryViewModelSpec)

__block MSFInventoryViewModel *viewModel;
__block id <MSFViewModelServices> services;
__block MSFClient *client;
__block MSFElement *mockRequiredElement;
__block id <MSFApplicationViewModel> insuranceViewModel;

beforeEach(^{
	client = mock(MSFClient.class);

	services = mockProtocol(@protocol(MSFViewModelServices));
	[given([services httpClient]) willReturn:client];
	[given([services msf_takePictureSignal]) willReturn:RACSignal.empty];

	mockRequiredElement = mock([MSFElement class]);
	stubProperty(mockRequiredElement, applicationNo, @"");
	stubProperty(mockRequiredElement, name, @"");
	stubProperty(mockRequiredElement, type, @"");
	stubProperty(mockRequiredElement, required, @YES);

	[[NSFileManager defaultManager] cleanupTemporaryFiles];
});

describe(@"re-upload attachments", ^{
	beforeEach(^{
		MSFLoanType *loanType = mock([MSFLoanType class]);
		stubProperty(loanType, typeID, @"");

		//TODO: Remove insuranceViewModel from this spec
		insuranceViewModel = mock([MSFApplyCashVIewModel class]);
		[given([insuranceViewModel services]) willReturn:services];
		[given([insuranceViewModel applicationNo]) willReturn:@""];
		[given([insuranceViewModel loanType]) willReturn:loanType];

		viewModel = [[MSFInventoryViewModel alloc] initWithApplicaitonNo:@"" productID:@"" services:services];
		expect(viewModel).notTo(beNil());

		[given([client fetchSupplementalElementsApplicationNo:@"" productID:@""]) willReturn:[RACSignal return:mockRequiredElement]];
		viewModel.active = YES;
	});

	it(@"should fetch viewmodels", ^{
		expect(viewModel.viewModels).notTo(beNil());
	});

	it(@"should has required elementViewModel", ^{
		// when
		MSFElementViewModel *elementViewModel = viewModel.requiredViewModels.firstObject;

		// then
		expect(@(elementViewModel.isRequired)).to(beTruthy());
	});

	it(@"should update valid", ^{
		// given
		MSFAttachment *attachment = mock([MSFAttachment class]);
		stubProperty(attachment, type, mockRequiredElement.type);
		stubProperty(attachment, name, mockRequiredElement.name);
		stubProperty(attachment, applicationNo, mockRequiredElement.applicationNo);
		stubProperty(attachment, isUpload, @YES);

		MSFElementViewModel *elementViewModel = viewModel.requiredViewModels.firstObject;
		[elementViewModel addAttachment:attachment];

		// when
		NSError *error;
		BOOL valid = [viewModel.updateValidSignal asynchronousFirstOrDefault:nil success:nil error:&error];

		// then
		expect(@(valid)).to(beTruthy());
	});

	it(@"should update attachments when finish upload required elements", ^{
		// given
		MSFAttachment *attachment = mock([MSFAttachment class]);
		stubProperty(attachment, type, mockRequiredElement.type);
		stubProperty(attachment, name, mockRequiredElement.name);
		stubProperty(attachment, applicationNo, mockRequiredElement.applicationNo);
		stubProperty(attachment, isUpload, @YES);
		stubProperty(attachment, fileID, @"bar");
		stubProperty(attachment, fileName, @"");

		MSFElementViewModel *elementViewModel = viewModel.requiredViewModels.firstObject;
		[elementViewModel addAttachment:attachment];

		// when
		NSArray *attachments = [[viewModel.executeUpdateCommand execute:nil] asynchronousFirstOrDefault:nil success:nil error:nil];

		// then
		expect(attachments).notTo(beNil());
		expect(attachments.firstObject[@"fileId"]).to(equal(@"bar"));
	});
});

it(@"should clean cache image files when submitted inventory to server successfully", ^{
	// given
	viewModel = [[MSFInventoryViewModel alloc] initWithApplicaitonNo:@"" productID:@"" services:services];

	UIImage *image = [UIImage imageNamed:@"tmp.jpg"];
	NSData *data = UIImageJPEGRepresentation(image, 1);
	NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"tmp.jpg"];
	NSURL *URL = [NSURL fileURLWithPath:path];
	[[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:nil];

	MSFAttachment *attachment = mock([MSFAttachment class]);
	stubProperty(attachment, type, mockRequiredElement.type);
	stubProperty(attachment, name, mockRequiredElement.name);
	stubProperty(attachment, applicationNo, mockRequiredElement.applicationNo);
	stubProperty(attachment, isUpload, @YES);
	stubProperty(attachment, fileID, @"bar");
	stubProperty(attachment, fileName, @"");
	stubProperty(attachment, fileURL, URL);

	MSFElementViewModel *elementViewModel = viewModel.requiredViewModels.firstObject;
	[elementViewModel addAttachment:attachment];

	NSArray *attachments = [[viewModel.executeUpdateCommand execute:nil] asynchronousFirstOrDefault:nil success:nil error:nil];
	[given([client submitInventoryWithApplicaitonNo:@"" accessories:attachments]) willReturn:[RACSignal return:mock(MSFResponse.class)]];

	NSArray *tmpDirectory = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:NSTemporaryDirectory() error:NULL];
	expect(@(tmpDirectory.count != 0)).to(beTruthy());

	// when
	[[viewModel.executeSubmitCommand execute:nil] asynchronousFirstOrDefault:nil success:nil error:nil];
	tmpDirectory = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:NSTemporaryDirectory() error:NULL];

	// then
	expect(@(tmpDirectory.count == 0)).to(beTruthy());
});

QuickSpecEnd
