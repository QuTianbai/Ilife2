//
//  MSFLoanLimitView.h
//  Finance
//
//  Created by 赵勇 on 9/28/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//
//  2.0版本添加。展示在首页及随借随还页面的信用额度圆环控件

#import <UIKit/UIKit.h>

@interface MSFLoanLimitView : UIView

//设置可用额度及已用额度
//调用此方法改变展示数字并触发动画
- (void)setAvailableCredit:(NSString *)ac usedCredit:(NSString *)uc;

@end