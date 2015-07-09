//
// MSFSelectionViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "RVMViewModel.h"

@class MSFCheckEmployee;

@interface MSFSelectionViewModel : RVMViewModel

+ (MSFSelectionViewModel *)monthsViewModelWithProducts:(MSFCheckEmployee *)products total:(NSInteger)amount;
+ (MSFSelectionViewModel *)selectKeyValuesViewModel:(NSArray *)items;
+ (MSFSelectionViewModel *)areaViewModel:(NSArray *)items;
+ (MSFSelectionViewModel *)selectViewModelWithFilename:(NSString *)filename;

- (NSInteger)numberOfSections;
- (NSInteger)numberOfItemsInSection:(NSInteger)section;
- (NSString *)titleForIndexPath:(NSIndexPath *)indexPath;
- (NSString *)subtitleForIndexPath:(NSIndexPath *)indexPath;
- (id)modelForIndexPath:(NSIndexPath *)indexPath;

@end