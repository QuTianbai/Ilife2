//
// MSFClient+Months.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFClient+Months.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFResponse.h"
#import "MSFProduct.h"
#import "SVProgressHUD.h"
#import "MSFCommandView.h"
#import "MSFXBMCustomHeader.h"
#import <NSString-Hashes/NSString+Hashes.h>

static NSMutableDictionary *mouths;

@implementation MSFClient (Months)

- (RACSignal *)fetchTermPayWithProduct:(MSFProduct *)product totalAmount:(NSInteger)amount insurance:(BOOL)insurance {
	NSMutableDictionary *parameters = NSMutableDictionary.new;
	parameters[@"principal"] = @(amount);
	parameters[@"productId"] = product.productId;
	parameters[@"isSafePlan"] = @(insurance);
	NSURLRequest *request = [self requestWithMethod:@"POST" path:@"loans/product" parameters:parameters];
  [SVProgressHUD setBackgroundColor:[UIColor clearColor]];
  [SVProgressHUD setOffsetFromCenter:UIOffsetMake(0, 130)];
  [SVProgressHUD setForegroundColor:[MSFCommandView getColorWithString:POINTCOLOR]];
	[SVProgressHUD showWithStatus:@""];
	
	if (!mouths) {
		mouths = [[NSMutableDictionary alloc] init];
	}
	
	if ([mouths objectForKey:[request.URL.absoluteString md5]]) {
		return [RACSignal return:mouths[[request.URL.absoluteString md5]]];
	} else {
		return [[self enqueueRequest:request resultClass:nil] doNext:^(id x) {
			[mouths setObject:x forKey:[request.URL.absoluteString md5]];
		}];
	}
}

@end
