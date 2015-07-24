//
//	MSFRepaymentTableViewCell.h
//	Cash
//
//	Created by xutian on 15/5/17.
//	Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSFRepaymentTableViewCell : UITableViewCell
/**
 *	合同编号
 */
@property (strong, nonatomic) UILabel *contractNum;
/**
 *	合同状态
 */
@property (strong, nonatomic) UILabel *contractStatus;
/**
 *	应还金额
 */
@property (strong, nonatomic) UILabel *shouldAmount;
/**
 *	截止日期
 */
@property (strong, nonatomic) UILabel *asOfDate;

/**
 *	合同编号Label
 */
@property (strong, nonatomic) UILabel *contractNumLabel;
/**
 *	合同状态Label
 */
@property (strong, nonatomic) UILabel *contractStatusLabel;
/**
 *	应还金额Label
 */
@property (strong, nonatomic) UILabel *shouldAmountLabel;
/**
 *	截止日期Label
 */
@property (strong, nonatomic) UILabel *asOfDateLabel;

@property (strong, nonatomic) UILabel *arrowHead;

@end