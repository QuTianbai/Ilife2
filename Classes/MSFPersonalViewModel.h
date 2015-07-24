//
// MSFBasicViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "RVMViewModel.h"

@class MSFApplicationForms;
@class MSFFormsViewModel;
@class MSFAddressViewModel;
@class RACCommand;

/**
 *	基本信息
*/
@interface MSFPersonalViewModel : RVMViewModel

@property (nonatomic, strong, readonly) NSString *address;
@property (nonatomic, strong, readonly) MSFFormsViewModel *formsViewModel;
@property (nonatomic, strong, readonly) MSFApplicationForms *model;
@property (nonatomic, strong, readonly) RACCommand *executeAlterAddressCommand;
@property (nonatomic, strong, readonly) RACCommand *executeCommitCommand;

- (instancetype)initWithFormsViewModel:(MSFFormsViewModel *)viewModel addressViewModel:(MSFAddressViewModel *)addressViewModel;

@end
