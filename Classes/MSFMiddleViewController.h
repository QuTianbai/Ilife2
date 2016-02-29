//
// MSFMiddleViewController.h
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSFReactiveView.h"

@interface MSFMiddleViewController : UIViewController <MSFReactiveView>

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UIView *contentView;

@property (nonatomic, weak) IBOutlet UIButton *applyButton;
@property (nonatomic, weak) IBOutlet UIButton *repayButton;
@property (nonatomic, weak) IBOutlet UILabel *amountLabel;
@property (nonatomic, weak) IBOutlet UILabel *subtitleLabel;

@end
