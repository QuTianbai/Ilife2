//
//  MSFDrawCashTableViewController.h
//  Finance
//
//  Created by xbm on 15/10/1.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MSFDrawCashViewModel;
@interface MSFDrawCashTableViewController : UITableViewController

@property (nonatomic, strong) MSFDrawCashViewModel *viewModel;

@property (nonatomic, assign) int type;

@end
