//
// MSFSelectionViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "RVMViewModel.h"

@class MSFMarket;
@class RACCommand;
@class MSFMarkets;

@interface MSFSelectionViewModel : RVMViewModel

@property (nonatomic, strong, readonly) RACSignal *selectedSignal;

+ (MSFSelectionViewModel *)monthsViewModelWithProducts:(MSFMarket *)products total:(NSInteger)amount;
+ (MSFSelectionViewModel *)selectKeyValuesViewModel:(NSArray *)items;
+ (MSFSelectionViewModel *)areaViewModel:(NSArray *)items;
+ (MSFSelectionViewModel *)selectViewModelWithFilename:(NSString *)filename;

- (NSInteger)numberOfSections;
- (NSInteger)numberOfItemsInSection:(NSInteger)section;
- (NSString *)titleForIndexPath:(NSIndexPath *)indexPath;
- (NSString *)subtitleForIndexPath:(NSIndexPath *)indexPath;
- (id)modelForIndexPath:(NSIndexPath *)indexPath;

+ (MSFSelectionViewModel *)monthsVIewModelWithMarkets:(MSFMarkets *)markts total:(NSInteger)amount;

@end