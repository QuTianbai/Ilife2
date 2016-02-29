//
// MSFWalletViewModel.h
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>

typedef NS_ENUM(NSUInteger, MSFWalletStatus) {
	MSFWalletNone,
	MSFWalletVerifying,
	MSFWalletRepaying,
};

@interface MSFWalletViewModel : RVMViewModel

@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSString *subtitle;

@property (nonatomic, strong, readonly) NSString *repayAmounts;
@property (nonatomic, strong, readonly) NSString *repayDates;

@property (nonatomic, strong, readonly) NSArray *photos;

@property (nonatomic, assign, readonly) MSFWalletStatus status;

@property (nonatomic, strong, readonly) NSString *totalAmounts;
@property (nonatomic, strong, readonly) NSString *validAmounts;
@property (nonatomic, strong, readonly) NSString *usedAmounts;
@property (nonatomic, strong, readonly) NSString *loanRates;
@property (nonatomic, strong, readonly) NSString *repayDate;

@end
