//
// MSFAttachmentSpec.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFAttachment.h"
#import "NSDateFormatter+MSFFormattingAdditions.h"

QuickSpecBegin(MSFAttachmentSpec)

NSDictionary *representation = @{
	@"fileId": @"3033",
	@"fileName": @"4b1bac5176264f0ca1be2c0ce8c5f52e.jpg",
};

__block MSFAttachment *attachment;

it(@"should create local attachment without upload", ^{
	// given
	NSURL *diskfileURL = [NSURL URLWithString:@"file://abc/attachment.jpg"];
	
	// when
	attachment = [[MSFAttachment alloc] initWithFileURL:diskfileURL applicationNo:@"303" elementType:@"W" elementName:@"foo"];
	
	// then
	expect(@(attachment.isUpload)).to(beFalsy());
	expect(attachment.fileURL).to(equal(diskfileURL));
	expect(attachment.thumbURL).to(equal(diskfileURL));
	expect(attachment.applicationNo).to(equal(@"303"));
	expect(attachment.type).to(equal(@"W"));
	expect(attachment.name).to(equal(@"foo"));
});

it(@"should merge response attachment when upload file to server", ^{
	// given
	NSURL *diskfileURL = [NSURL URLWithString:@"file://abc/attachment.jpg"];
	attachment = [[MSFAttachment alloc] initWithFileURL:diskfileURL applicationNo:@"303" elementType:@"W" elementName:@"foo"];
	
	// when
	MSFAttachment *result = [MTLJSONAdapter modelOfClass:MSFAttachment.class fromJSONDictionary:representation error:nil];
	[attachment mergeAttachment:result];
	
	// then
	expect(attachment.fileID).to(equal(@"3033"));
	expect(attachment.fileName).to(equal(@"4b1bac5176264f0ca1be2c0ce8c5f52e.jpg"));
	expect(@(attachment.isUpload)).to(beTruthy());
});

it(@"should create a blank attachment", ^{
	// when
	attachment = [[MSFAttachment alloc] initWithAssetsURL:[NSURL URLWithString:@"file://temp/url.jpg"] applicationNo:@"" elementType:@"" elementName:@""];
	
	// then
	expect(@(attachment.isPlaceholder)).to(beTruthy());
});

QuickSpecEnd
