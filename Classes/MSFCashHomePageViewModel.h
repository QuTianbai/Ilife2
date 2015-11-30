//
// MSFCashHomePageViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>
#import "MSFViewModelServices.h"

@class RACCommand;
@class MSFFormsViewModel;

@interface MSFCashHomePageViewModel : RVMViewModel

@property (nonatomic, strong, readonly) NSString *usableLmt;
@property (nonatomic, strong, readonly) NSString *usedLmt;

@property (nonatomic, weak, readonly) id <MSFViewModelServices> services;
@property (nonatomic, strong, readonly) MSFFormsViewModel *formViewModel;

@property (nonatomic, strong, readonly) RACCommand *executeAllowMSCommand;
@property (nonatomic, strong, readonly) RACCommand *executeAllowMLCommand;
@property (nonatomic, strong, readonly) RACCommand *executeWithdrawCommand;
@property (nonatomic, strong, readonly) RACCommand *executeRepayCommand;

- (void)refreshCirculate;
- (RACSignal *)fetchProductType;
- (instancetype)initWithFormViewModel:(MSFFormsViewModel *)formViewModel
														 services:(id <MSFViewModelServices>)services;

@end
