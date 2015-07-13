//
// MSFSelectionViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFSelectionViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFProduct.h"
#import "MSFTeams.h"
#import "MSFSelectionItem.h"
#import "MSFMarket.h"
#import "MSFSelectKeyValues.h"

@interface MSFSelectionViewModel ()

@property(nonatomic,strong) NSArray *models;

@end

@implementation MSFSelectionViewModel

#pragma mark - Lifecycle

+ (MSFSelectionViewModel *)areaViewModel:(NSArray *)items {
  MSFSelectionViewModel *viewModel = [[MSFSelectionViewModel alloc] init];
  viewModel.models = items;

  return viewModel;
}

+ (MSFSelectionViewModel *)selectKeyValuesViewModel:(NSArray *)items {
  MSFSelectionViewModel *viewModel = [[MSFSelectionViewModel alloc] init];
  viewModel.models = items;

  return viewModel;
}

+ (MSFSelectionViewModel *)monthsViewModelWithProducts:(MSFMarket *)products total:(NSInteger)amount {
  MSFSelectionViewModel *viewModel = [[MSFSelectionViewModel alloc] init];
  viewModel.models = [[[products.teams.rac_sequence filter:^BOOL(MSFTeams *terms) {
    return (terms.minAmount.integerValue <= amount) && (terms.maxAmount.integerValue >=  amount);
    }]
   flattenMap:^RACStream *(MSFTeams *value) {
     return value.team.rac_sequence;
   }].array sortedArrayUsingComparator:^NSComparisonResult(MSFProduct *obj1, MSFProduct *obj2) {
     if (obj1.period.integerValue < obj2.period.integerValue) {
       return NSOrderedAscending;
     }
     else if (obj1.period.integerValue > obj2.period.integerValue) {
       return NSOrderedDescending;
     }
     
     return NSOrderedSame;
   }];
  
  return viewModel;
}

+ (MSFSelectionViewModel *)selectViewModelWithFilename:(NSString *)filename {
	return [self.class selectKeyValuesViewModel:[MSFSelectKeyValues getSelectKeys:filename]];
}

#pragma mark - Public

- (NSInteger)numberOfSections {
  return 1;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
  return self.models.count;
}

- (NSString *)titleForIndexPath:(NSIndexPath *)indexPath {
  return [self itemForIndexPath:indexPath].title;
}

- (NSString *)subtitleForIndexPath:(NSIndexPath *)indexPath {
  return [self itemForIndexPath:indexPath].subtitle;
}

- (id)modelForIndexPath:(NSIndexPath *)indexPath {
  return [self itemForIndexPath:indexPath];
}

#pragma mark - Private

- (NSObject <MSFSelectionItem> *)itemForIndexPath:(NSIndexPath *)indexPath {
  return self.models[indexPath.row];
}

@end
