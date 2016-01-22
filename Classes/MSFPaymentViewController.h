//
// MSFPaymentViewController.h
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSFPaymentViewModel.h"

@interface MSFPaymentViewController : UITableViewController

- (instancetype)initWithViewModel:(id <MSFPaymentViewModel>)viewModel;

@end
