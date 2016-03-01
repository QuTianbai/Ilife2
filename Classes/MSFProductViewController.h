//
//	MSFProductViewController.h
//
//	Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MSFApplyCashViewModel;

@interface MSFProductViewController : UITableViewController

@property (nonatomic, strong, readonly) MSFApplyCashViewModel *viewModel;

- (instancetype)initWithViewModel:(MSFApplyCashViewModel *)viewModel;

@end
