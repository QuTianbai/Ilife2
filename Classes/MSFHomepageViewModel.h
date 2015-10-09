//
// MSFHomePageViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "RVMViewModel.h"
#import "MSFViewModelServices.h"

@interface MSFHomepageDisplayModel : NSObject

@end

@class RACCommand;
@class MSFCirculateCashViewModel;
@class MSFFormsViewModel;

@interface MSFHomepageViewModel : RVMViewModel

@property (nonatomic, strong, readonly) MSFFormsViewModel *viewModel;
@property (nonatomic, readonly) NSArray *viewModels;
@property (nonatomic, readonly) RACCommand *refreshCommand;
@property (nonatomic, readonly) MSFCirculateCashViewModel *circulateCashViewModel;


- (NSInteger)numberOfItemsInSection:(NSInteger)section;
- (id)viewModelForIndexPath:(NSIndexPath *)indexPath;
- (NSString *)reusableIdentifierForIndexPath:(NSIndexPath *)indexPath;

- (instancetype)initWithModel:(MSFFormsViewModel *)viewModel
										 services:(id <MSFViewModelServices>)services;

@end
