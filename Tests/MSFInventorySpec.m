//
// MSFInventorySpec.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFInventory.h"
#import "MSFAttachment.h"

QuickSpecBegin(MSFInventorySpec)

NSDictionary *representation = @{
	@"applyId": @1,
	@"applyNo": @"2015000001",
	@"fileList": @[@{
			@"attachmentName": @"111.jpg",
			@"attachmentType": @"IDCARD",
			@"attachmentTypePlain": @"身份证",
			@"fileId": @100001
		}, @{
			@"attachmentName": @"222.jpg",
			@"attachmentType": @"IDCARD",
			@"attachmentTypePlain": @"身份证",
			@"fileId": @100002
		}, @{
			@"attachmentName": @"333.jpg",
			@"attachmentType": @"PHOTO",
			@"attachmentTypePlain": @"本人现场照片",
			@"fileId": @100003
		}
	]
};

__block MSFInventory *inventory;

beforeEach(^{
inventory = [MTLJSONAdapter modelOfClass:MSFInventory.class fromJSONDictionary:representation error:nil];
	expect(inventory).notTo(beNil());
});

it(@"should initialize", ^{
  // then
	expect(inventory.objectID).to(equal(@"1"));
	expect(inventory.applyNo).to(equal(@"2015000001"));
	expect(@(inventory.attachments.count)).to(equal(@3));
});

it(@"should has attachements list", ^{
	// when
	MSFAttachment *attachment = inventory.attachments.firstObject;
	
	// then
	expect(attachment).to(beAKindOf(MSFAttachment.class));
	expect(attachment.name).to(equal(@"111.jpg"));
});

QuickSpecEnd
