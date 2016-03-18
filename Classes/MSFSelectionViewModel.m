//
// MSFSelectionViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFSelectionViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFSelectionItem.h"
#import "MSFSelectKeyValues.h"

#import "MSFAmortize.h"
#import "MSFOrganize.h"
#import "MSFPlan.h"

@interface MSFSelectionViewModel ()

@property (nonatomic, strong) NSArray *models;
@property (nonatomic, strong, readwrite) RACSubject *selectedSignal;
@property (nonatomic, strong, readwrite) RACSignal *cancelSignal;

@end

@implementation MSFSelectionViewModel

#pragma mark - Lifecycle

- (instancetype)init {
  self = [super init];
  if (!self) {
    return nil;
  }
	
	self.selectedSignal = [[RACSubject subject] setNameWithFormat:@"MSFSelectionViewModel -selectedSignal"];
	self.cancelSignal = [[RACSubject subject] setNameWithFormat:@"MSFSelectionViewModel -cancelSignal"];
	
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

+ (MSFSelectionViewModel *)monthsVIewModelWithMarkets:(MSFAmortize *)markts total:(NSInteger)amount {
	MSFSelectionViewModel *viewModel = [[MSFSelectionViewModel alloc] init];
	viewModel.models = [[[markts.teams.rac_sequence filter:^BOOL(MSFOrganize *terms) {
		return (terms.minAmount.integerValue <= amount) && (terms.maxAmount.integerValue >=	 amount);
	}]
	flattenMap:^RACStream *(MSFOrganize *value) {
			return value.team.rac_sequence;
											 }].array sortedArrayUsingComparator:^NSComparisonResult(MSFPlan *obj1, MSFPlan *obj2) {
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

- (NSIndexPath *)indexPathForModel:(id)model {
	return [NSIndexPath indexPathForRow:[self.models indexOfObject:model] inSection:0];
}

- (id)modelForIndexPath:(NSIndexPath *)indexPath {
	return [self itemForIndexPath:indexPath];
}

#pragma mark - Private

- (NSObject <MSFSelectionItem> *)itemForIndexPath:(NSIndexPath *)indexPath {
	return self.models[indexPath.row];
}

@end
