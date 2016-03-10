//
//  MSFCreditMiddleViewController.h
//  Finance
//
//  Created by Wyc on 16/3/8.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSFReactiveView.h"

@interface MSFCreditMiddleViewController : UIViewController <MSFReactiveView>
@property (weak, nonatomic) IBOutlet UIView *beforeApply;
@property (weak, nonatomic) IBOutlet UIView *applyView;
@property (weak, nonatomic) IBOutlet UILabel *orderNum;
@property (weak, nonatomic) IBOutlet UILabel *applyReason;
@property (weak, nonatomic) IBOutlet UILabel *applyAmount;
@property (weak, nonatomic) IBOutlet UILabel *dayLimit;

@end
