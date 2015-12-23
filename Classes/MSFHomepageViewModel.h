//
// MSFHomePageViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "RVMViewModel.h"
#import "MSFViewModelServices.h"

@class RACCommand;
@class MSFHomePageCellModel;

@interface MSFHomepageViewModel : RVMViewModel

@property (nonatomic, weak, readonly) id<MSFViewModelServices> services;
@property (nonatomic, strong, readonly) RACCommand *loanInfoRefreshCommand;

@property (nonatomic, strong, readonly) MSFHomePageCellModel *cellModel;
@property (nonatomic, strong, readonly) NSArray *banners;

- (instancetype)initWithModel:(id)viewModel services:(id<MSFViewModelServices>)services;
- (NSInteger)numberOfItemsInSection:(NSInteger)section;
- (NSString *)reusableIdentifierForIndexPath:(NSIndexPath *)indexPath;
- (id)viewModelForIndexPath:(NSIndexPath *)indexPath;
- (void)pushInfo:(NSInteger)index;

@end
