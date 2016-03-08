//
//  MSFCashHomeLoanLimit.h
//  Finance
//
//  Created by 赵勇 on 11/23/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//
//  使用MSFLoanLimitView封装的一个包含还款提现按钮的视图，在我的马上tab中使用

#import <UIKit/UIKit.h>

__attribute__((deprecated("This class is unavailable")))

@interface MSFCashHomeLoanLimit : UIView

//提现按钮
@property (nonatomic, strong, readonly) UIButton *withdrawButton;
//还款按钮
@property (nonatomic, strong, readonly) UIButton *repayButton;

//设置可用额度 ac，已用额度 uc，刷新视图
- (void)setAvailableCredit:(NSString *)ac usedCredit:(NSString *)uc;

@end
