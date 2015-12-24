//
//  MSFOrderEditViewController.h
//  Finance
//
//  Created by 赵勇 on 12/23/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSFViewModelServices.h"

@interface MSFOrderEditViewController : UITableViewController

- (instancetype)initWithOrderId:(NSString *)orderId
											 services:(id<MSFViewModelServices>)services;

@end
