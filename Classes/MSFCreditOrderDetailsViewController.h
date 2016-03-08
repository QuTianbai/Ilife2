//
//  MSFCreditOrderDetailsViewController.h
//  Finance
//
//  Created by Wyc on 16/3/4.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSFViewModelServices.h"
@interface MSFCreditOrderDetailsViewController : UIViewController
- (instancetype)initWithServices:(id<MSFViewModelServices>)services;
- (instancetype)initWithViewModel:(id)viewModel;
@end
