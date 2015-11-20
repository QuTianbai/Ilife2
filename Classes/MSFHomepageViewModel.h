//
// MSFHomePageViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "RVMViewModel.h"
#import "MSFViewModelServices.h"

@class RACCommand;
@class MSFFormsViewModel;
@class MSFHomePageCellModel;

@interface MSFHomepageViewModel : RVMViewModel

@property (nonatomic, strong, readonly) MSFFormsViewModel *viewModel;
@property (nonatomic, strong, readonly) MSFHomePageCellModel *cellModel;
@property (nonatomic, strong, readonly) RACCommand *refreshCommand;
@property (nonatomic, weak, readonly) id <MSFViewModelServices> services;

- (instancetype)initWithModel:(MSFFormsViewModel *)viewModel
										 services:(id <MSFViewModelServices>)services;
- (NSInteger)numberOfItemsInSection:(NSInteger)section;
- (NSString *)reusableIdentifierForIndexPath:(NSIndexPath *)indexPath;
- (id)viewModelForIndexPath:(NSIndexPath *)indexPath;

@end
