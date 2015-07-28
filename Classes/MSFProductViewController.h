//
//	MSFProductViewController.h
//
//	Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MSFProductViewModel;

@interface MSFProductViewController : UITableViewController

@property (nonatomic, strong, readonly) MSFProductViewModel *viewModel;

- (instancetype)initWithViewModel:(MSFProductViewModel *)viewModel;

@end
