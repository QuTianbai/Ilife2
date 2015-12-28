//
//  MSFFaceMaskPhtoViewController.m
//  Finance
//
//  Created by xbm on 15/12/28.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFFaceMaskPhtoViewController.h"
#import "MSFEdgeButton.h"
#import "MSFFaceMaskViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFAttachment.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "MSFInventoryViewController.h"
#import "MSFInventoryViewModel.h"

@interface MSFFaceMaskPhtoViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *faceImagView;
@property (weak, nonatomic) IBOutlet MSFEdgeButton *clickPhotoBT;
@property (weak, nonatomic) IBOutlet MSFEdgeButton *updatePhotoBT;

@property (nonatomic, strong) MSFFaceMaskViewModel *viewModel;

@end

@implementation MSFFaceMaskPhtoViewController

- (instancetype)initWithViewModel:(id)viewModel {
	self = [UIStoryboard storyboardWithName:@"faceMaskStoryboard" bundle:nil].instantiateInitialViewController;
	if (!self) {
		return nil;
	}
	_viewModel = viewModel;
	
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.updatePhotoBT.hidden = YES;
	self.clickPhotoBT.rac_command = self.viewModel.takeFaceMaskPhotoCommand;
	[self.viewModel.takeFaceMaskPhotoCommand.executionSignals subscribeNext:^(id x) {
		self.updatePhotoBT.hidden = NO;
		self.clickPhotoBT.hidden = YES;
	}];
	self.updatePhotoBT.rac_command = self.viewModel.updateImageCommand;
	RAC(self, faceImagView.image) = [[RACObserve(self, viewModel.imgFilePath) ignore:nil] map:^id(id value) {
		return [UIImage imageWithContentsOfFile:value];
	}];
	[self.viewModel.updateImageCommand.executionSignals subscribeNext:^(RACSignal *signal) {
		[SVProgressHUD showWithStatus:@"正在提交..." maskType:SVProgressHUDMaskTypeClear];
		[signal subscribeNext:^(id x) {
			[SVProgressHUD showSuccessWithStatus:@"上传成功"];
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
				MSFInventoryViewModel *viewModel = [[MSFInventoryViewModel alloc] initWithApplicationViewModel:self.viewModel.applicationViewModel AndAttachment:self.viewModel.attachment];
						MSFInventoryViewController *viewController = [[MSFInventoryViewController alloc] initWithViewModel:viewModel];
				[self.navigationController pushViewController:viewController animated:YES];
			});
		}];
	}];
	
	[self.viewModel.updateImageCommand.errors subscribeNext:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];
	
	
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	
}

@end
