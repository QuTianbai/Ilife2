//
//	MSFAppliesIncomeTableViewController.h
//	Cash
//
//	Created by xbm on 15/5/23.
//	Copyright (c) 2015年 MSFINANCE. All rights reserved.
//
//  基本信息

#import <UIKit/UIKit.h>
#import "MSFReactiveView.h"

@interface MSFPersonalViewController : UITableViewController <MSFReactiveView>

- (instancetype)initWithViewModel:(id)viewModel;

@end
