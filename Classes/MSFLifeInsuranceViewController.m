//
//  MSFLifeInsuranceViewController.m
//  Finance
//
//  Created by xbm on 15/10/13.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFLifeInsuranceViewController.h"
#import "MSFLifeInsuranceViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface MSFLifeInsuranceViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *lifeInsuranceWebView;
@property (nonatomic, strong) MSFLifeInsuranceViewModel *viewModel;

@end

@implementation MSFLifeInsuranceViewController

- (instancetype)initWithViewModel:(id)viewModel {
	self = [UIStoryboard storyboardWithName:@"LifeInsurance" bundle:nil].instantiateInitialViewController;
	if (!self) {
		return nil;
	}
	_viewModel = viewModel;
	
	return self;
	
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"寿险协议";
	self.edgesForExtendedLayout = UIRectEdgeNone;
	
	//RACSignal *signal = [self.viewModel]
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
