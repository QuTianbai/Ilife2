//
// MSFSelectionViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "RVMViewModel.h"

@class MSFMarket;
@class RACCommand;
@class MSFAmortize;

@interface MSFSelectionViewModel : RVMViewModel

@property (nonatomic, strong, readonly) RACSignal *selectedSignal;
@property (nonatomic, strong, readonly) RACSignal *cancelSignal;

+ (MSFSelectionViewModel *)selectKeyValuesViewModel:(NSArray *)items;
+ (MSFSelectionViewModel *)areaViewModel:(NSArray *)items;
+ (MSFSelectionViewModel *)selectViewModelWithFilename:(NSString *)filename;

- (NSInteger)numberOfSections;
- (NSInteger)numberOfItemsInSection:(NSInteger)section;
- (NSString *)titleForIndexPath:(NSIndexPath *)indexPath;
- (NSString *)subtitleForIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathForModel:(id)model;
- (id)modelForIndexPath:(NSIndexPath *)indexPath;

+ (MSFSelectionViewModel *)monthsVIewModelWithMarkets:(MSFAmortize *)markts total:(NSInteger)amount;

@end