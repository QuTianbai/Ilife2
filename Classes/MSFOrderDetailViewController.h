//
//  MSFOrderDetailViewController.h
//  Finance
//
//  Created by 赵勇 on 12/22/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSFViewModelServices.h"

@interface MSFOrderDetailViewController : UITableViewController

- (instancetype)initWithModel:(id)model services:(id<MSFViewModelServices>)services;

@end
