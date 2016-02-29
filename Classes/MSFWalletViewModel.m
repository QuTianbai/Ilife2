//
// MSFWalletViewModel.m
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFWalletViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFPhoto.h"

@interface MSFWalletViewModel ()

@property (nonatomic, strong, readwrite) NSString *title;
@property (nonatomic, strong, readwrite) NSString *subtitle;

@property (nonatomic, strong, readwrite) NSString *repayAmounts;
@property (nonatomic, strong, readwrite) NSString *repayDates;

@property (nonatomic, strong, readwrite) NSArray *photos;

@property (nonatomic, strong, readwrite) NSString *totalAmounts;
@property (nonatomic, strong, readwrite) NSString *validAmounts;
@property (nonatomic, strong, readwrite) NSString *usedAmounts;
@property (nonatomic, strong, readwrite) NSString *loanRates;
@property (nonatomic, strong, readwrite) NSString *repayDate;

@end

@implementation MSFWalletViewModel

- (instancetype)init {
  self = [super init];
  if (!self) {
    return nil;
  }
	//TODO: services获取网络数据
//	_status = MSFWalletVerifying;
	
	@weakify(self)
	[RACObserve(self, status) subscribeNext:^(NSNumber *status) {
		@strongify(self)
		switch (status.integerValue) {
			case MSFWalletVerifying:
				self.title = @"申请审核中";
				self.subtitle = @"请稍后...";
				break;
			case MSFWalletRepaying: {
					self.title = @"";
					self.subtitle = @"";
					self.repayAmounts = @"2300.00";
					self.repayDates = @"剩余8天可随时还款";
				
					self.totalAmounts = @"80000";
					self.validAmounts = @"2000";
					self.usedAmounts = @"6000";
					self.loanRates = @"60.00%";
					self.repayDate = @"每月31日";
				}
				break;
			default:
				self.title = @"可借现金额度";
				self.subtitle = @"未激活";
				self.totalAmounts = @"0";
				self.validAmounts = @"0";
				self.usedAmounts = @"0";
				self.loanRates = @"00.00%";
				self.repayDate = @"";
				break;
		}
	}];
	
	//TODO: services获取网络数据
	self.photos = @[
		[[MSFPhoto alloc] initWithURL:[NSURL URLWithString:@"http://www.msxf.com/res/images/banner6.jpg"]],
		[[MSFPhoto alloc] initWithURL:[NSURL URLWithString:@"http://www.msxf.com/res/images/banner5.jpg"]]
	];
	
	
  return self;
}

@end
