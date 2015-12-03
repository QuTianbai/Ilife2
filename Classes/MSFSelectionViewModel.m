//
// MSFSelectionViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFSelectionViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFSelectionItem.h"
#import "MSFSelectKeyValues.h"

#import "MSFMarkets.h"
#import "MSFTeams2.h"
#import "MSFTeam.h"

@interface MSFSelectionViewModel ()

@property (nonatomic, strong) NSArray *models;
@property (nonatomic, strong, readwrite) RACSubject *selectedSignal;

@end

@implementation MSFSelectionViewModel

#pragma mark - Lifecycle

- (instancetype)init {
  self = [super init];
  if (!self) {
    return nil;
  }
	
	self.selectedSignal = [[RACSubject subject] setNameWithFormat:@"MSFSelectionViewModel -selectedSignal"];
	
  return self;
}

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

+ (MSFSelectionViewModel *)monthsVIewModelWithMarkets:(MSFMarkets *)markts total:(NSInteger)amount {
	MSFSelectionViewModel *viewModel = [[MSFSelectionViewModel alloc] init];
	viewModel.models = [[[markts.teams.rac_sequence filter:^BOOL(MSFTeams2 *terms) {
		return (terms.minAmount.integerValue <= amount) && (terms.maxAmount.integerValue >=	 amount);
	}]
	flattenMap:^RACStream *(MSFTeams2 *value) {
			return value.team.rac_sequence;
											 }].array sortedArrayUsingComparator:^NSComparisonResult(MSFTeam *obj1, MSFTeam *obj2) {
												 if (obj1.loanTeam.integerValue < obj2.loanTeam.integerValue) {
													 return NSOrderedAscending;
												 } else if (obj1.loanTeam.integerValue > obj2.loanTeam.integerValue) {
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
