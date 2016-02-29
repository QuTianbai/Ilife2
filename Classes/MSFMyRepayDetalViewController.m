//
//  MSFMyRepayDetalViewController.m
//  Finance
//
//  Created by xbm on 16/2/29.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFMyRepayDetalViewController.h"

@interface MSFMyRepayDetalViewController ()

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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
