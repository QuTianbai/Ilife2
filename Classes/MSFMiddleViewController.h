//
// MSFMiddleViewController.h
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSFReactiveView.h"

@interface MSFMiddleViewController : UIViewController <MSFReactiveView>

@property (nonatomic, weak) IBOutlet UILabel *groundLabel;
@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (nonatomic, weak) IBOutlet UIView *groundView;
@property (nonatomic, weak) IBOutlet UIView *contentView;

@property (nonatomic, weak) IBOutlet UIButton *applyButton;
@property (nonatomic, weak) IBOutlet UIButton *repayButton;
@property (nonatomic, weak) IBOutlet UILabel *amountLabel;
@property (nonatomic, weak) IBOutlet UILabel *subtitleLabel;

@end
