//
//  MSFCreditHeaderViewController.h
//  Finance
//
//  Created by Wyc on 16/3/8.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSFReactiveView.h"

@interface MSFCreditHeaderViewController : UIViewController <MSFReactiveView>

@property (weak, nonatomic) IBOutlet UIView *applyView;//审核之后的页面
@property (weak, nonatomic) IBOutlet UIView *beforeApplyView;//没有审核之前页面
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *button;

@property (weak, nonatomic) IBOutlet UILabel *repayLabel;//每月还款的金额
@property (weak, nonatomic) IBOutlet UILabel *applyLabel;//申请的金额
@property (weak, nonatomic) IBOutlet UILabel *applyMonthLabel;//借款期限

@end
