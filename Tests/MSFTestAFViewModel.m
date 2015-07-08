//
// MSFTestAFViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFTestAFViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFApplyInfo.h"
#import "MSFCheckEmployee.h"

@implementation MSFTestAFViewModel


- (instancetype)initWithClient:(MSFClient *)client {
  self = [super initWithClient:client];
  if (!self) {
    return nil;
  }
	NSURL *URL = [[NSBundle bundleForClass:self.class] URLForResource:@"loadinfo" withExtension:@"json"];
	NSData *data = [NSData dataWithContentsOfURL:URL];
	NSDictionary *representation = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
	MSFApplyInfo *model = [MTLJSONAdapter modelOfClass:[MSFApplyInfo class] fromJSONDictionary:representation error:nil];

	RAC(self,model) = [RACSignal return:model];
	
	URL = [[NSBundle bundleForClass:self.class] URLForResource:@"checkemployee" withExtension:@"json"];
	data = [NSData dataWithContentsOfURL:URL];
	representation = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
	MSFCheckEmployee *market = [MTLJSONAdapter modelOfClass:[MSFCheckEmployee class] fromJSONDictionary:representation error:nil];
	RAC(self,market) = [RACSignal return:market];
  
  return self;
}

@end
