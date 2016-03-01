//
// MSFHomePageViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "RVMViewModel.h"
#import "MSFViewModelServices.h"

@class RACCommand;
@class MSFHomePageItemViewModel;

@interface MSFHomepageViewModel : RVMViewModel

@property (nonatomic, weak, readonly) id<MSFViewModelServices> services;
@property (nonatomic, strong, readonly) RACCommand *loanInfoRefreshCommand;

@property (nonatomic, strong, readonly) MSFHomePageItemViewModel *cellModel;
@property (nonatomic, strong, readonly) NSArray *banners;

@property (nonatomic, strong, readonly) NSArray *orders;
@property (nonatomic, assign, readonly) BOOL hasOrders;

- (instancetype)initWithModel:(id)viewModel services:(id<MSFViewModelServices>)services;
- (NSInteger)numberOfItemsInSection:(NSInteger)section;
- (NSString *)reusableIdentifierForIndexPath:(NSIndexPath *)indexPath;
- (id)viewModelForIndexPath:(NSIndexPath *)indexPath;
- (void)pushInfo:(NSInteger)index;

@end
