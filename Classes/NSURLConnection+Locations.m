//
// NSURLConnection+Locations.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "NSURLConnection+Locations.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Mantle/Mantle.h>
#import "MSFLocationModel.h"

@implementation NSURLConnection (Locations)

+ (RACSignal *)fetchLocationWithLatitude:(double)latitude longitude:(double)longitude {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.map.baidu.com/geocoder/v2/?ak=sTLArkR5mCiQrGcflln8li7c&location=%f,%f&output=json&pois=1", latitude, longitude]];
		[[NSURLConnection rac_sendAsynchronousRequest:[NSURLRequest requestWithURL:URL]] subscribeNext:^(id x) {
			RACTupleUnpack(NSHTTPURLResponse *response, NSData *data) = x;
			if (response.statusCode != 200) {
				[subscriber sendCompleted];
			} else {
				NSDictionary *representation = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
				MSFLocationModel *model = [MTLJSONAdapter modelOfClass:MSFLocationModel.class fromJSONDictionary:representation	error:nil];
				[subscriber sendNext:model];
				[subscriber sendCompleted];
			}
		}];
	
		return nil;
	}];
	return nil;
}

@end
