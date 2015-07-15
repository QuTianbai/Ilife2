//
//	MSFProductViewController.h
//
//	Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSFReactiveView.h"

@class MSFProductViewModel;

@interface MSFProductViewController : UITableViewController <MSFReactiveView>

@property (nonatomic, strong, readonly) MSFProductViewModel *viewModel;

- (instancetype)initWithViewModel:(MSFProductViewModel *)viewModel;

@end
