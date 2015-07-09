//
// MSFFormsViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "RVMViewModel.h"

/**
 *  Application Form ViewModel
 */

@class MSFCheckEmployee;
@class MSFApplyInfo;
@class MSFClient;

@interface MSFFormsViewModel : RVMViewModel

@property(nonatomic,strong,readonly) MSFClient *client;
@property(nonatomic,strong,readonly) MSFApplyInfo *model;
@property(nonatomic,strong,readonly) MSFCheckEmployee *market;
@property(nonatomic,strong,readonly) RACSignal *updatedContentSignal;

- (instancetype)initWithClient:(MSFClient *)client;

- (RACSignal *)submitSignalWithPage:(NSInteger)page;

@end
