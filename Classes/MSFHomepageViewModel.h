//
// MSFHomePageViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "RVMViewModel.h"
#import "MSFViewModelServices.h"

@class RACCommand;
@class MSFBannersViewModel;

@interface MSFHomepageViewModel : RVMViewModel

@property (nonatomic, readonly) NSArray *viewModels;
@property (nonatomic, readonly) RACCommand *refreshCommand;
@property (nonatomic, readonly) MSFBannersViewModel *bannersViewModel;

- (NSInteger)numberOfItemsInSection:(NSInteger)section;
- (id)viewModelForIndexPath:(NSIndexPath *)indexPath;
- (NSString *)reusableIdentifierForIndexPath:(NSIndexPath *)indexPath;

- (instancetype)initWithServices:(id <MSFViewModelServices>)services;

@end
