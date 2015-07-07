//
// MSFBannersViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "RVMViewModel.h"

@class MSFClient;

@interface MSFBannersViewModel : RVMViewModel

@property(nonatomic,strong,readonly) RACSignal *updateContentSignal;
@property(nonatomic,strong,readonly) MSFClient *client;

- (instancetype)initWithClient:(MSFClient *)client;

- (NSInteger)numberOfSections;
- (NSInteger)numberOfItemsInSection:(NSInteger)section;
- (NSURL *)imageURLAtIndexPath:(NSIndexPath *)indexPath;
- (NSString *)imageNameAtIndexPath:(NSIndexPath *)indexPath;
- (NSURL *)HTMLURLAtIndexPath:(NSIndexPath *)indexPath;

@end
