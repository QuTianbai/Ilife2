//
//  MSFCirculateCashTableViewController.h
//  Finance
//
//  Created by xbm on 15/10/1.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSFViewModelServices.h"

@interface MSFCirculateCashTableViewController : UITableViewController

@property (nonatomic, assign) id<MSFViewModelServices> services;

@end
