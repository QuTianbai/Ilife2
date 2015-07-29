//
// MSFWebViewController.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSFWebViewController : UIViewController

- (instancetype)initWithHTMLURL:(NSURL *)URL;
- (instancetype)initWithViewModel:(id)viewModel;

@end
