//
//  MSFSubmitAlertView.h
//  MSFAlertViewDemo
//
//  Created by tian.xu on 15/7/30.
//  Copyright (c) 2015年 xutian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSFSubmitAlertView : UIView
@property (weak, nonatomic) IBOutlet UIView *loanConfirmAlertView;
@property (weak, nonatomic) IBOutlet UILabel *loanConfirmLabel;
@property (weak, nonatomic) IBOutlet UILabel *loanAccountLabel;
@property (weak, nonatomic) IBOutlet UILabel *loanNper;
@property (weak, nonatomic) IBOutlet UILabel *loanUse;
@property (weak, nonatomic) IBOutlet UILabel *loanPayBack;

@end
