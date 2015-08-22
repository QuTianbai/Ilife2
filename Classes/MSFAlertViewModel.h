//
// MSFAlertViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "RVMViewModel.h"

@class MSFFormsViewModel;
@class MSFUser;

@interface MSFAlertViewModel : RVMViewModel

@property (nonatomic, strong, readonly) NSString *amount;
@property (nonatomic, strong, readonly) NSString *terms;
@property (nonatomic, strong, readonly) NSString *useage;
@property (nonatomic, strong, readonly) NSString *repayment;
@property (nonatomic, strong, readonly) NSString *bankNumber;

@property (nonatomic, strong, readonly) RACSignal *buttonClickedSignal;

- (instancetype)initWithFormsViewModel:(MSFFormsViewModel *)formsViewModel user:(MSFUser *)user;

@end
