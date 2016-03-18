//
// MSFFindPasswordViewController.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSFReactiveView.h"
#import "MSFGroupTableViewController.h"

@interface MSFFindPasswordViewController : MSFGroupTableViewController <MSFReactiveView>

- (instancetype)initWithModel:(id)viewModel;

@end
