//
//  MSFSupportBankListTableViewCell.h
//  Finance
//
//  Created by Wyc on 16/3/15.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSFSupportBankListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *BankpicImageView;

@property (weak, nonatomic) IBOutlet UILabel *BankName;
@property (weak, nonatomic) IBOutlet UILabel *singleAmountLimit;
@property (weak, nonatomic) IBOutlet UIView *BankType;
@property (weak, nonatomic) IBOutlet UILabel *dayAmountLimit;

@end
