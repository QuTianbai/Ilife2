//
//  MSFBankCardListTableViewController.h
//  Finance
//
//  Created by xbm on 15/9/29.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSFViewModelServices.h"

@interface MSFBankCardListTableViewController : UITableViewController

@property (nonatomic, assign) id<MSFViewModelServices> services;

- (instancetype)initWithViewModel:(id)viewModel;

@end
