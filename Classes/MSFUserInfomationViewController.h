//
//  MSFUserInfomationViewController.h
//  Finance
//
//  Created by 赵勇 on 9/29/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSFViewModelServices.h"

@interface MSFUserInfomationViewController : UIViewController

@property (nonatomic, assign) BOOL showNextStep;

- (instancetype)initWithViewModel:(id)viewModel
												 services:(id<MSFViewModelServices>)services;

@end
