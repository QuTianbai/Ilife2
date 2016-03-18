//
// MSFHeaderViewController.h
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSFReactiveView.h"

@interface MSFHeaderViewController : UIViewController <MSFReactiveView>

@property (nonatomic, weak) IBOutlet UIView *applyView;
@property (nonatomic, weak) IBOutlet UIView *repayView;

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *subtitleLabel;

@property (nonatomic, weak) IBOutlet UILabel *totalLabel;
@property (nonatomic, weak) IBOutlet UILabel *validLabel;
@property (nonatomic, weak) IBOutlet UILabel *usedLabel;
@property (nonatomic, weak) IBOutlet UILabel *ratesLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;

@property (nonatomic, weak) IBOutlet UIButton *button;

@end
