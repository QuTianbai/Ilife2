//
// MSFCashHomePageViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>
#import "MSFViewModelServices.h"

@class RACCommand;
@class MSFFormsViewModel;

__attribute__((deprecated("This class is unavailable")))

@interface MSFCashHomePageViewModel : RVMViewModel

@property (nonatomic, strong, readonly) NSString *usableLmt;
@property (nonatomic, strong, readonly) NSString *usedLmt;

@property (nonatomic, weak, readonly) id <MSFViewModelServices> services;
@property (nonatomic, strong, readonly) id formViewModel __deprecated_msg("Use MSFUser intead");

//TODO: 更新绑定的主卡信息
@property (nonatomic, assign, readonly) BOOL hasMasterCard;

// 马上贷款
@property (nonatomic, strong, readonly) RACCommand *executeAllowMSCommand;

// 麻辣贷
@property (nonatomic, strong, readonly) RACCommand *executeAllowMLCommand;

// 提现
@property (nonatomic, strong, readonly) RACCommand *executeWithdrawCommand;

// 还款
@property (nonatomic, strong, readonly) RACCommand *executeRepayCommand;

- (void)refreshCirculate;
- (RACSignal *)fetchProductType;
- (instancetype)initWithFormViewModel:(id)formViewModel services:(id <MSFViewModelServices>)services __deprecated_msg("Use initWithServices:");
- (instancetype)initWithServices:(id <MSFViewModelServices>)services;

@end
