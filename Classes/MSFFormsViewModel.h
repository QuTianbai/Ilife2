//
// MSFFormsViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "RVMViewModel.h"

/**
 *  Application Form ViewModel
 */

@class MSFMarket;
@class MSFApplicationForms;
@class MSFClient;

@interface MSFFormsViewModel : RVMViewModel

@property(nonatomic,strong,readonly) MSFClient *client;
@property(nonatomic,strong,readonly) MSFApplicationForms *model;
@property(nonatomic,strong,readonly) MSFMarket *market;
@property(nonatomic,strong,readonly) RACSignal *updatedContentSignal;

- (RACSignal *)submitSignalWithPage:(NSInteger)page;

@end
