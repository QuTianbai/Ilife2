//
// MSFTradeViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFTradeViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFTrade.h"
#import "NSDateFormatter+MSFFormattingAdditions.h"

@interface MSFTradeViewModel ()

@property (nonatomic, readonly) MSFTrade *model;

@end

@implementation MSFTradeViewModel

- (instancetype)initWithModel:(MSFTrade *)model {
  self = [super init];
  if (!self) {
    return nil;
  }
	_model = model;
	
	
	RAC(self, describe) = RACObserve(self, model.tradeDescription);
	RAC(self, amount) = RACObserve(self, model.tradeAmount);
	RAC(self, date) = [RACObserve(self, model.tradeDate) map:^id(id value) {
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
		formatter.dateFormat = @"yyyy/MM/dd";
		formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
		return [formatter stringFromDate:value];
	}];
	
  return self;
}

@end
