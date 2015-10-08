//
// MSFAttachmentSpec.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFAttachment.h"
#import "NSDateFormatter+MSFFormattingAdditions.h"

QuickSpecBegin(MSFAttachmentSpec)

NSDictionary *representation = @{
	@"attachmentName": @"111.jpg",
	@"attachmentType": @"IDCARD",
	@"attachmentTypePlain": @"身份证",
	@"fileId": @100001
};

NSDictionary *info = @{
	@"applyId": @528,
	@"applyNo": @"20150727000528",
	@"attachmentName": @"QQ截图20150727110907.png",
	@"attachmentType": @"IDCARD",
	@"attachmentTypePlain": @"身份证",
	@"comment": @"http://192.168.2.41:8160/file/download?sysCode=105&bizCode=105005&fileId=3230",
	@"fileId": @100001,
	@"id": @1289,
	@"rawAddTime": @"2015-07-27 20:00:26",
	@"rawUpdateTime": @"2015-07-27 20:00:03",
	@"status": @"I",
	
	@"type": @"image/jpg",
};

__block MSFAttachment *attachment;

beforeEach(^{
	attachment = [MTLJSONAdapter modelOfClass:MSFAttachment.class fromJSONDictionary:representation error:nil];
	expect(attachment).notTo(beNil());
});

it(@"should initialize", ^{
  // then
	expect(attachment.name).to(equal(@"111.jpg"));
	expect(attachment.type).to(equal(@"IDCARD"));
	expect(attachment.plain).to(equal(@"身份证"));
	expect(attachment.fileID).to(equal(@"100001"));
});

it(@"should fetch uploaded attachment information", ^{
	// when
 attachment = [MTLJSONAdapter modelOfClass:MSFAttachment.class fromJSONDictionary:info error:nil];
	
	// then
	expect(attachment.applyID).to(equal(@"528"));
	expect(attachment.applyNo).to(equal(@"20150727000528"));
	expect(attachment.name).to(equal(@"QQ截图20150727110907.png"));
	expect(attachment.type).to(equal(@"IDCARD"));
	expect(attachment.plain).to(equal(@"身份证"));
	expect(attachment.commentURL).to(equal([NSURL URLWithString:@"http://192.168.2.41:8160/file/download?sysCode=105&bizCode=105005&fileId=3230"]));
	expect(attachment.objectID).to(equal(@"100001"));
	expect(attachment.additionDate).to(equal([NSDateFormatter msf_dateFromString:@"2015-07-27 20:00:26"]));
	expect(attachment.updatedDate).to(equal([NSDateFormatter msf_dateFromString:@"2015-07-27 20:00:03"]));
	expect(attachment.status).to(equal(@"I"));
});

it(@"should create placeholder attachment", ^{
	// when
	NSURL *URL = [[NSBundle bundleForClass:self.class] URLForResource:@"tmp" withExtension:@"jpg"];
	attachment = [[MSFAttachment alloc] initWithDictionary:@{@"isPlaceholder": @YES, @"thumbURL": URL} error:nil];
	
	// then
	expect(@(attachment.isPlaceholder)).to(beTruthy());
	expect(attachment.thumbURL).to(equal(URL));
});

QuickSpecEnd
