//
// MSFUtils.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFUtils.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFServer.h"
#import "MSFCipher.h"
#import "MSFClient+ReleaseNote.h"
#import "MSFReleaseNote.h"

@implementation MSFUtils

#pragma mark - Custom Accessors

+ (RACSignal *)setupSignal {
	MSFClient *client = [[MSFClient alloc] initWithServer:MSFServer.dotComServer];
	return [[client fetchReleaseNote] doNext:^(MSFReleaseNote *releasenote) {
		MSFCipher *cipher = [[MSFCipher alloc] initWithTimestamp:[releasenote.timestamp longLongValue]];
		[MSFClient setCipher:cipher];
	}];
}

#pragma mark - Persistent values

+ (void)setSignInMobile:(NSString *)_phone {
	[[NSUserDefaults standardUserDefaults] setObject:_phone?:@"" forKey:@"user-phone"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)signInMobile {
	return [[NSUserDefaults standardUserDefaults] stringForKey:@"user-phone"];
}

@end
