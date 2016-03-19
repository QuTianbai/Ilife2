//
//  MSFInputMoneyViewcontrollerTableViewController.h
//  Finance
//
//  Created by 胥佰淼 on 16/3/19.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSFTransactionsViewModel.h"

@interface MSFInputMoneyViewcontrollerTableViewController : UITableViewController

- (instancetype)initWithViewModel:(id <MSFTransactionsViewModel>)viewModel;

@end
