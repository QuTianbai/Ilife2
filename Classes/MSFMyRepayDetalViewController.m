//
//  MSFMyRepayDetalViewController.m
//  Finance
//
//  Created by xbm on 16/2/29.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFMyRepayDetalViewController.h"
#import "MSFBlurButton.h"

@interface MSFMyRepayDetalViewController ()
@property (weak, nonatomic) IBOutlet UILabel *repayMoneyCountLB;
@property (weak, nonatomic) IBOutlet UIButton *repayBT;
@property (weak, nonatomic) IBOutlet UILabel *contractTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *repayDay;
@property (weak, nonatomic) IBOutlet UITableView *repayDetalTableView;
@property (weak, nonatomic) IBOutlet MSFBlurButton *repayMoneyBT;

@end

@implementation MSFMyRepayDetalViewController

- (instancetype)initWithViewModel:(id)viewModel {
	self = [[UIStoryboard storyboardWithName:@"MSFMyRepayContainerViewController" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([MSFMyRepayDetalViewController class])];
	if (!self) {
		return nil;
	}
	
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	
}

@end
