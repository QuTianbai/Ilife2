//
//  MSFCashHomeLoanLimit.h
//  Finance
//
//  Created by 赵勇 on 11/23/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSFCashHomeLoanLimit : UIView

@property (nonatomic, strong, readonly) UIButton *withdrawButton;
@property (nonatomic, strong, readonly) UIButton *repayButton;

- (void)setAvailableCredit:(NSString *)ac usedCredit:(NSString *)uc;

@end
