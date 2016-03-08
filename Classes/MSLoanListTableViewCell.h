//
//	MSLoanListTableViewCell.h
//	Cash
//
//	Created by xbm on 15/5/20.
//	Copyright (c) 2015年 MSFINANCE. All rights reserved.
//
//  申请列表Cell

#import <UIKit/UIKit.h>

__attribute__((deprecated("This class is unavailable")))

@interface MSLoanListTableViewCell : UITableViewCell

/*
 * 更新cell
 * model：MSFApplyList
 *type：0，马上贷布局；1，麻辣带布局
 */
- (void)bindModel:(id)model type:(int)type;

@end