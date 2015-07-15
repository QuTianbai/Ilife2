//
// MSFUserViewController.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *	用户中心
 */
@class MSFUserViewModel;

@interface MSFUserViewController : UITableViewController

@property (nonatomic, strong, readonly) MSFUserViewModel *viewModel;

- (instancetype)initWithViewModel:(MSFUserViewModel *)viewModel;

@end
