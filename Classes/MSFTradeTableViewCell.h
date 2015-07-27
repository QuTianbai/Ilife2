//
//	MSFTradeTableViewCell.h
//	Cash
//
//	Created by xutian on 15/5/17.
//	Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSFTradeTableViewCell : UITableViewCell

@property (strong, nonatomic) UILabel *date;
@property (strong, nonatomic) UILabel *tradeDescription;
@property (strong, nonatomic) UILabel *amount;

@end