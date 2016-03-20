//
//  MSFCartViewController.h
//  Finance
//
//  Created by 赵勇 on 12/23/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSFViewModelServices.h"

// 商品贷下单界面
@interface MSFCartViewController : UITableViewController

- (instancetype)initWithViewModel:(id)viewModel;

@end
