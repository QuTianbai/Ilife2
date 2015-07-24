//
//	MSLoanListTableViewCell.h
//	Cash
//
//	Created by xbm on 15/5/20.
//	Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MSFCellButton;

@interface MSLoanListTableViewCell : UITableViewCell

@property (strong, nonatomic) UILabel *moneyLabel;
@property (strong, nonatomic) UILabel *monthsLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UIButton *checkLabel;

@end