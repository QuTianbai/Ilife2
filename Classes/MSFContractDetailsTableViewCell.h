//
//  MSFContractDetailsTableViewCell.h
//  Cash
//
//  Created by xutian on 15/5/18.
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

/**
 *  合同Cell
 */
#import <UIKit/UIKit.h>

@interface MSFContractDetailsTableViewCell : UITableViewCell

/**
 *  截止日期
 */
@property(strong,nonatomic) UILabel *asOfDateLabel;
/**
 *  应还金额
 */
@property(strong,nonatomic) UILabel *shouldAmountLabel;
/**
 *  款项
 */
@property(strong,nonatomic) UILabel *paymentLabel;
/**
 *  状态
 */
@property(strong,nonatomic) UILabel *stateLabel;

@end