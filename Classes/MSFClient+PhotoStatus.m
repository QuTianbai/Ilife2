//
//	MSFClient+PhotoStatus.m
//	Cash
//
//	Created by xbm on 15/6/11.
//	Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFClient+PhotoStatus.h"
#import "MSFPhoto.h"
#import "RACSignal+MSFClientAdditions.h"

@implementation MSFClient (PhotoStatus)

- (RACSignal *)updateBankCardAvatarWithFileURL:(NSURL *)URL ownURL:(NSURL *)ownURL {
	NSString *path = [NSString stringWithFormat:@"/msfinanceapi/v1/identphotos"];
	NSMutableURLRequest *request =
	[self requestWithMethod:@"POST" path:path parameters:nil
	constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
		[formData appendPartWithFormData:[NSData dataWithContentsOfURL:URL] name:@"idPhoto"];
		[formData appendPartWithFormData:[NSData dataWithContentsOfURL:ownURL] name:@"ownerPhoto"];
	}];
	
	return [[self enqueueRequest:request resultClass:MSFPhoto.class] msf_parsedResults];
}

@end
