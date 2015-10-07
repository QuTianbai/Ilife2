//
//  MSFCashHomePageViewController.h
//  Finance
//
//  Created by xbm on 15/10/2.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MSFApplyCashVIewModel;

@interface MSFCashHomePageViewController : UIViewController

@property (nonatomic, strong, readonly) MSFApplyCashVIewModel *viewModel;

- (instancetype)initWithViewModel:(MSFApplyCashVIewModel *)viewModel;

@end
