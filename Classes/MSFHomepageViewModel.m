//
// MSFHomePageViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFHomepageViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/extobjc.h>
#import "MSFClient+ApplyList.h"
#import "MSFLoanViewModel.h"
#import "MSFBannersViewModel.h"

@interface MSFHomepageViewModel ()

@property(nonatomic,readwrite) NSArray *viewModels;

@end

@implementation MSFHomepageViewModel

- (instancetype)initWithClient:(MSFClient *)client {
  self = [super init];
  if (!self) {
    return nil;
  }
  _client = client;
	_bannersViewModel = [[MSFBannersViewModel alloc] initWithClient:client];
  
  @weakify(self)
  _refreshCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
    @strongify(self)
		self.bannersViewModel.active = NO;
		self.bannersViewModel.active = YES;
    if (!self.client.isAuthenticated) {
      return [RACSignal return:nil];
    }
    
    return [[[self.client fetchApplyList]
      map:^id(id value) {
        return [[MSFLoanViewModel alloc] initWithModel:value];
      }]
      collect];
  }];
  
  [self.didBecomeActiveSignal subscribeNext:^(id x) {
    @strongify(self)
    [self.refreshCommand execute:nil];
  }];
  
  RAC(self,viewModels) = [[self.refreshCommand.executionSignals switchToLatest] ignore:nil];
  [self.refreshCommand.errors subscribeNext:^(id x) {
    @strongify(self)
    self.viewModels = nil;
  }];
  
  return self;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
  return self.viewModels.count == 0 ? 1 : self.viewModels.count;
}

- (MSFLoanViewModel *)viewModelForIndexPath:(NSIndexPath *)indexPath {
  if (self.viewModels.count > indexPath.item) {
    return self.viewModels[indexPath.item];
  }
  
  return nil;
}

- (NSString *)reusableIdentifierForIndexPath:(NSIndexPath *)indexPath {
  MSFLoanViewModel *viewModel = [self viewModelForIndexPath:indexPath];
  if (!viewModel) {
    return @"MSFPlaceholderCollectionViewCell";
  }
  if ([viewModel.status isEqualToString:@"还款中"]) {
    return @"MSFPepaymentCollectionViewCell";
  }
  else {
    return @"MSFRequisitionCollectionViewCell";
  }
}

@end