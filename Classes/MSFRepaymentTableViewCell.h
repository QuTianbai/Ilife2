//
//	MSFRepaymentTableViewCell.h
//	Cash
//
//	Created by xutian on 15/5/17.
//	Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSFReactiveView.h"

@class MSFEdgeButton;

@interface MSFRepaymentTableViewCell : UITableViewCell
<MSFReactiveView>

@property (strong, nonatomic) MSFEdgeButton *repayButton;//还款按钮，逾期时才可主动还款

@end