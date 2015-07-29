//
// MSFBannersViewController.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSFReactiveView.h"

@interface MSFBannersViewController : UIViewController <MSFReactiveView>

- (void)bindViewModel:(id)viewModel;

@end
