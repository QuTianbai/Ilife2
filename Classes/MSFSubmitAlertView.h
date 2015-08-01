//
//  MSFSubmitAlertView.h
//  MSFAlertViewDemo
//
//  Created by tian.xu on 15/7/30.
//  Copyright (c) 2015年 xutian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSFSubmitAlertView : UIView
/**
 *	整个alertview
 */
@property (weak, nonatomic) IBOutlet UIView *loanConfirmAlertView;
/**
 *	贷款确认四个字
 */
@property (weak, nonatomic) IBOutlet UILabel *loanConfirmLabel;
/**
 *	贷款金额
 */
@property (weak, nonatomic) IBOutlet UILabel *loanAccountLabel;
/**
 *	贷款期数
 */
@property (weak, nonatomic) IBOutlet UILabel *loanNper;
/**
 *	贷款用途
 */
@property (weak, nonatomic) IBOutlet UILabel *loanUse;
/**
 *	每期还款
 */
@property (weak, nonatomic) IBOutlet UILabel *loanPayBack;
/**
 *	取消按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
/**
 *	提交按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@end
