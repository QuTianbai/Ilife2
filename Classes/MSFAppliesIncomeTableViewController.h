//
//  MSFAppliesIncomeTableViewController.h
//  Cash
//
//  Created by xbm on 15/5/23.
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSFReactiveView.h"

// 基本信息
@interface MSFAppliesIncomeTableViewController : UITableViewController <MSFReactiveView>

@property(weak, nonatomic) IBOutlet UITextField *monthInComeTF;
@property(weak, nonatomic) IBOutlet UITextField *repayMonthTF;

@property(weak, nonatomic) IBOutlet UITextField *familyOtherIncomeYF;
@property(weak, nonatomic) IBOutlet UITextField *homeTelTF;
@property(weak, nonatomic) IBOutlet UITextField *homeLineCodeTF;

@property(weak, nonatomic) IBOutlet UITextField *emailTF;
@property(weak, nonatomic) IBOutlet UITextField *townTF;
@property(weak, nonatomic) IBOutlet UITextField *currentStreetTF;
@property(weak, nonatomic) IBOutlet UITextField *currentCommunityTF;
@property(weak, nonatomic) IBOutlet UITextField *currentApartmentTF;

@property(weak, nonatomic) IBOutlet UITextField *passwordTF;
@property(weak, nonatomic) IBOutlet UITableViewCell *taobaoOrJDPasswordCell;
@property(weak, nonatomic) IBOutlet UITextField *otherUserNameTF;
@property(weak, nonatomic) IBOutlet UITextField *otherPasswordTF;
@property(weak, nonatomic) IBOutlet UITextField *provinceTF;
@property(weak, nonatomic) IBOutlet UIButton *selectAreasBT;

@end
