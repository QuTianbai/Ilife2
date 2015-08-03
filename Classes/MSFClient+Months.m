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
  
	return [self enqueueRequest:request resultClass:nil];
}

@end
