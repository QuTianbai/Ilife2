//
// MSFLoginViewController.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSFLoginSwapController.h"

@class MSFLoginSwapController;

@interface MSFLoginViewController : UIViewController

@property (nonatomic, strong, readonly) MSFLoginSwapController *loginSwapController;

- (instancetype)initWithViewModel:(id)viewModel loginType:(MSFLoginType)loginType;

@end
