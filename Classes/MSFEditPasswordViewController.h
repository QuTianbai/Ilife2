//
// MSFEditUserinfoViewController.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSFReactiveView.h"
#import "MSFGroupTableViewController.h"

@interface MSFEditPasswordViewController : MSFGroupTableViewController <MSFReactiveView>

- (instancetype)initWithViewModel:(id)viewModel;

@end
