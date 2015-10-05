//
//  MSFCirculateCashTableViewController.h
//  Finance
//
//  Created by xbm on 15/10/1.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "MSFViewModelServices.h"

@class MSFCirculateCashViewModel;

@interface MSFCirculateCashTableViewController : UITableViewController

- (instancetype)initWithViewModel:(MSFCirculateCashViewModel *)viewModel;

@end
