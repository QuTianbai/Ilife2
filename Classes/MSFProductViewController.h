//
//	MSFProductViewController.h
//
//	Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MSFApplyCashVIewModel;

@interface MSFProductViewController : UITableViewController

@property (nonatomic, strong, readonly) MSFApplyCashVIewModel *viewModel;

- (instancetype)initWithViewModel:(MSFApplyCashVIewModel *)viewModel;

@end
