//
//  MSFCashHomePageViewController.m
//  Finance
//
//  Created by xbm on 15/10/2.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFCashHomePageViewController.h"
#import "MSFEdgeButton.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Masonry/Masonry.h>
#import "MSFApplyCashVIewModel.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "MSFCheckAllowApply.h"
#import "MSFCirculateCashViewModel.h"
#import "MSFCirculateCashTableViewController.h"
#import "MSFProductViewController.h"
#import "MSFDeviceGet.h"
#import "UIColor+Utils.h"

#import "MSFClient+MSFProductType.h"
#import "MSFApplyView.h"


@interface MSFCashHomePageViewController ()

@property (weak, nonatomic) IBOutlet UIButton *nextBT;
@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;

@end

@implementation MSFCashHomePageViewController

- (instancetype)initWithViewModel:(MSFApplyCashVIewModel *)viewModel {
	self = [UIStoryboard storyboardWithName:@"CashHomePage" bundle:nil].instantiateInitialViewController;
	if (!self) {
		return nil;
	}
	_viewModel = viewModel;
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	UIView *topLayoutGuide = (id)self.topLayoutGuide;
	UIView *bottomLayoutGuide = (id)self.bottomLayoutGuide;
	/*
	MSFApplyView *ms = [[MSFApplyView alloc] initWithStatus:MSFApplyViewTypeMS];
	[self.view addSubview:ms];
	MSFApplyView *ml = [[MSFApplyView alloc] initWithStatus:MSFApplyViewTypeML];
	[self.view addSubview:ml];
	[ms mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(topLayoutGuide.mas_bottom);
		make.left.right.equalTo(self.view);
	}];
	[ml mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(ms.mas_bottom);
		make.bottom.equalTo(bottomLayoutGuide.mas_top);
		make.left.right.equalTo(self.view);
		make.height.equalTo(ms);
	}];
	*/
	MSFApplyView *ms_full = [[MSFApplyView alloc] initWithStatus:MSFApplyViewTypeMSFull];
	[self.view addSubview:ms_full];
	[ms_full mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(topLayoutGuide.mas_bottom);
		make.bottom.equalTo(bottomLayoutGuide.mas_top);
		make.left.right.equalTo(self.view);
	}];
	
	return;
	
	
	DeviceTypeNum deviceType = [MSFDeviceGet deviceNum];
	if (deviceType &( IPHONE4 | IPHONE4S)) {
		self.bgImgView.contentMode = UIViewContentModeCenter;
	}
	
	self.automaticallyAdjustsScrollViewInsets = NO;
	self.edgesForExtendedLayout = UIRectEdgeNone;
	self.nextBT.rac_command = self.viewModel.executeAllowCashCommand;
	
	[self.viewModel.executeAllowCashCommand.executionSignals subscribeNext:^(RACSignal *signal) {
		[SVProgressHUD showWithStatus:@"正在加载..." maskType:SVProgressHUDMaskTypeClear];
		[signal subscribeNext:^(MSFCheckAllowApply *model) {
			[SVProgressHUD dismiss];
			if (model.processing == 1) {
				
					MSFProductViewController *productViewController = [[MSFProductViewController alloc] initWithViewModel:self.viewModel];
				  [productViewController setHidesBottomBarWhenPushed:YES];
					[self.navigationController pushViewController:productViewController animated:YES];

				
			} else {
				[[[UIAlertView alloc] initWithTitle:@"提示"
																		message:@"您目前还有一笔贷款正在进行中，暂不能申请贷款。"
																	 delegate:nil
													cancelButtonTitle:@"确认"
													otherButtonTitles:nil] show];
			}
			
		}];
	}];
	[self.viewModel.executeAllowCashCommand.errors subscribeNext:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
