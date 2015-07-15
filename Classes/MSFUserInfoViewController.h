//
// MSFUserInfoViewController.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MSFUserViewModel;

@interface MSFUserInfoViewController : UITableViewController

- (instancetype)initWithViewModel:(MSFUserViewModel *)viewModel;

@end
