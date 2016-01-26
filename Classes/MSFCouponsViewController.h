//
// MSFCouponsViewController.h
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSFReactiveView.h"

@interface MSFCouponsViewController : UITableViewController <MSFReactiveView>

- (instancetype)initWithViewModel:(id)viewModel;

@end
