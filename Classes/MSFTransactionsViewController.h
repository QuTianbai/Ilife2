//
// MSFPaymentViewController.h
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSFTransactionsViewModel.h"

// 支付界面
@interface MSFTransactionsViewController : UITableViewController

- (instancetype)initWithViewModel:(id <MSFTransactionsViewModel>)viewModel;

@end
