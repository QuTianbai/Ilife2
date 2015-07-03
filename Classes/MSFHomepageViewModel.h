//
// MSFHomePageViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "RVMViewModel.h"

@class MSFClient;
@class RACCommand;
@class MSFBannersViewModel;

@interface MSFHomepageViewModel : RVMViewModel

@property(nonatomic,readonly) NSArray *viewModels;
@property(nonatomic,readonly) RACCommand *refreshCommand;
@property(nonatomic,readonly) MSFClient *client;
@property(nonatomic,readonly) MSFBannersViewModel *bannersViewModel;

- (instancetype)initWithClient:(MSFClient *)client;

- (NSInteger)numberOfItemsInSection:(NSInteger)section;
- (id)viewModelForIndexPath:(NSIndexPath *)indexPath;
- (NSString *)reusableIdentifierForIndexPath:(NSIndexPath *)indexPath;

@end
