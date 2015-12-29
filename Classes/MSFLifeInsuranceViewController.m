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
#import <SVProgressHUD/SVProgressHUD.h>

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
	[SVProgressHUD showWithStatus:@"正在加载..."];
	[[[self.lifeInsuranceWebView
		rac_liftSelector:@selector(loadHTMLString:baseURL:)
		withSignalOfArguments:[RACSignal combineLatest:@[
			self.viewModel.lifeInsuranceHTMLSignal,
			[RACSignal return:nil]
		]]]
		deliverOn:RACScheduler.mainThreadScheduler]
		subscribeNext:^(id x) {
			[SVProgressHUD dismiss];
		}
		error:^(NSError *error) {
			[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
		}];
}

@end
