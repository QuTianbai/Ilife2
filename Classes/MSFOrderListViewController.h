//
//  MSFOrderListViewController.h
//  Finance
//
//  Created by 赵勇 on 12/22/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSFViewModelServices.h"

@interface MSFOrderListViewController : UITableViewController

- (instancetype)initWithServices:(id<MSFViewModelServices>)services;
- (instancetype)initWithViewModel:(id)viewModel;

@end
