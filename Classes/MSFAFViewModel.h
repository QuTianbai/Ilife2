//
// MSFAFViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "RVMViewModel.h"

@class MSFCheckEmployee;
@class MSFApplyInfo;
@class MSFClient;

/**
 *  Application Form ViewModel
 */
@interface MSFAFViewModel : RVMViewModel

@property(nonatomic,strong,readonly) MSFClient *client;
@property(nonatomic,strong,readonly) MSFCheckEmployee *productSet;
@property(nonatomic,strong,readonly) MSFApplyInfo *model;

- (instancetype)initWithModel:(MSFApplyInfo *)model;
- (instancetype)initWithModel:(MSFApplyInfo *)model productSet:(MSFCheckEmployee *)productSet;

@end
