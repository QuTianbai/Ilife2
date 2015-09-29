//
// MSFBasicViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "RVMViewModel.h"
#import "MSFViewModelServices.h"

@class MSFApplicationForms;
@class MSFFormsViewModel;
@class MSFAddressViewModel;
@class RACCommand;

/**
 *	基本信息
*/
@interface MSFPersonalViewModel : RVMViewModel


@property (nonatomic, strong) NSString *houseTypeTitle;
@property (nonatomic, strong) NSString *marriageTitle;

@property (nonatomic, readonly) MSFAddressViewModel *addressViewModel;
@property (nonatomic, weak, readonly) id <MSFViewModelServices> services;
@property (nonatomic, strong, readonly) NSString *address;
@property (nonatomic, strong, readonly) MSFFormsViewModel *formsViewModel;
@property (nonatomic, strong, readonly) MSFApplicationForms *model;
@property (nonatomic, strong, readonly) RACCommand *executeAlterAddressCommand;
@property (nonatomic, strong, readonly) RACCommand *executeCommitCommand;
@property (nonatomic, strong, readonly) RACCommand *executeHouseValuesCommand;
@property (nonatomic, strong, readonly) RACCommand *executeMarryValuesCommand;

- (instancetype)initWithFormsViewModel:(MSFFormsViewModel *)viewModel addressViewModel:(MSFAddressViewModel *)addressViewModel;

- (NSString *)checkForm;

@end
