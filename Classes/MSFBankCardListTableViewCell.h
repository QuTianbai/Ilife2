//
//  MSFBankCardListTableViewCell.h
//  Finance
//
//  Created by xbm on 15/9/29.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSFCellButton.h"

@interface MSFBankCardListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *bankIconImg;
@property (weak, nonatomic) IBOutlet UILabel *bankName;
@property (weak, nonatomic) IBOutlet UILabel *BankType;
@property (weak, nonatomic) IBOutlet MSFCellButton *unBindMaster;
@property (weak, nonatomic) IBOutlet MSFCellButton *setMasterBT;
@property (weak, nonatomic) IBOutlet UILabel *isMaster;

@end
