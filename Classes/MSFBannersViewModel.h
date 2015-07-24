//
// MSFBannersViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "RVMViewModel.h"
#import "MSFViewModelServices.h"

@interface MSFBannersViewModel : RVMViewModel

@property (nonatomic, strong, readonly) RACSignal *updateContentSignal;

- (instancetype)initWithServices:(id <MSFViewModelServices>)services;

- (NSInteger)numberOfSections;
- (NSInteger)numberOfItemsInSection:(NSInteger)section;
- (NSURL *)imageURLAtIndexPath:(NSIndexPath *)indexPath;
- (NSString *)imageNameAtIndexPath:(NSIndexPath *)indexPath;
- (NSURL *)HTMLURLAtIndexPath:(NSIndexPath *)indexPath;

@end
