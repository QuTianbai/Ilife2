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
#import "MSFPoster.h"
#import "NSDate+UTC0800.h"

@implementation MSFUtils

#pragma mark - Custom Accessors

+ (RACSignal *)setupSignal {
	MSFClient *client = [[MSFClient alloc] initWithServer:MSFServer.dotComServer];
	return [[client fetchReleaseNote] doNext:^(MSFReleaseNote *releasenote) {
//		MSFCipher *cipher = [[MSFCipher alloc] initWithTimestamp:[releasenote.timestamp longLongValue]];
//		[MSFClient setCipher:cipher];
		[MSFUtils savePosters:releasenote.posters];
	}];
}

#pragma mark - Private

+ (void)savePosters:(NSArray *)posters {
	if (posters.count == 0) posters = @[];
	NSString *path = [NSTemporaryDirectory() stringByAppendingString:@"posters.plist"];
	NSSet *items = [NSSet setWithArray:posters];
	[NSKeyedArchiver archiveRootObject:items toFile:path];
}

#pragma mark - Persistent values

+ (void)setSignInMobile:(NSString *)_phone {
	[[NSUserDefaults standardUserDefaults] setObject:_phone?:@"" forKey:@"user-phone"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)signInMobile {
	return [[NSUserDefaults standardUserDefaults] stringForKey:@"user-phone"];
}

+ (MSFPoster *)poster {
	__block MSFPoster *poster;
	NSString *path = [NSTemporaryDirectory() stringByAppendingString:@"posters.plist"];
	NSSet *items = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
	if (!items) return nil;

	[items enumerateObjectsUsingBlock:^(MSFPoster *obj, BOOL *stop) {
		NSTimeInterval start = [obj.startDate timeIntervalSinceNow];
		NSTimeInterval end = [obj.endDate timeIntervalSinceNow];
		NSTimeInterval now = [NSDate.date timeIntervalSinceNow];
		if (start < now && end > now) {
			poster = obj;
			*stop = YES;
		}
	}];
	
	return poster;
}

@end
