//
//  MSFWalletRepayTableViewCell.h
//  Finance
//
//  Created by Wyc on 16/3/17.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSFWalletRepayTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *loanTerm;
@property (weak, nonatomic) IBOutlet UILabel *lastestDueMoney;
@property (weak, nonatomic) IBOutlet UILabel *lastDueDate;

@end
