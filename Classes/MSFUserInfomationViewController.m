//
//  MSFUserInfomationViewController.m
//  Finance
//
//  Created by 赵勇 on 9/29/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFUserInfomationViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <Masonry/Masonry.h>

#import "MSFUserInfoCircleView.h"

#import "MSFPersonalViewModel.h"
#import "MSFRelationshipViewModel.h"
#import "MSFProfessionalViewModel.h"
#import "MSFApplyCashViewModel.h"
#import "MSFFormsViewModel.h"
#import "MSFApplicationForms.h"
#import "MSFAddressViewModel.h"

#import "MSFClient+ApplyInfo.h"
#import "UIColor+Utils.h"

#import "MSFUser.h"
#import "MSFInventoryViewModel.h"
#import "MSFInventoryViewController.h"
#import "AppDelegate.h"
#import "MSFSetTradePasswordTableViewController.h"
#import "MSFAddBankCardTableViewController.h"

#import "MSFProductViewController.h"
#import "MSFSocialInsuranceCashViewModel.h"
#import "MSFSocialCaskApplyTableViewController.h"

#import "MSFCommodityCashViewModel.h"
#import "MSFDistinguishViewModel.h"
#import "MSFFaceMaskViewModel.h"
#import "MSFFaceMaskPhtoViewController.h"
#import "MSFCartViewModel.h"
#import "MSFAuthorizeViewModel.h"
#import "MSFAuthenticateViewController.h"
#import "MSFAuxiliaryViewController.h"
#import "MSFUserViewModel.h"
#import "MSFPersonal.h"
#import "MSFProfessional.h"
#import "MSFAuxiliaryViewModel.h"

@interface MSFUserInfomationViewController ()

@property (nonatomic, strong) MSFUserViewModel *viewModel;
@property (nonatomic, weak) IBOutlet UILabel *authenticatedLabel;
@property (nonatomic, weak) IBOutlet UILabel *personalLabel;
@property (nonatomic, weak) IBOutlet UILabel *professionalLabel;
@property (nonatomic, weak) IBOutlet UILabel *profilesLabel;

@end

@implementation MSFUserInfomationViewController

#pragma mark - NSObject

- (instancetype)initWithViewModel:(id)viewModel {
	self = [[UIStoryboard storyboardWithName:NSStringFromClass([MSFUserInfomationViewController class]) bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([MSFUserInfomationViewController class])];
	if (self) {
		self.hidesBottomBarWhenPushed = YES;
		_viewModel = viewModel;
	}
	return self;
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"完善信息";
	RAC(self.authenticatedLabel, textColor) = [RACObserve(self.viewModel, isAuthenticated) map:^id(id value) {
		return [value boolValue] ? [UIColor colorWithRed:0.251 green:0.714 blue:0.941 alpha:1.000] : [UIColor orangeColor];
	}];
	RAC(self.authenticatedLabel, text) = [RACObserve(self.viewModel, isAuthenticated) map:^id(id value) {
		return [value boolValue] ? @"已完成" : @"未完成";
	}];
	RAC(self.personalLabel, textColor) = [RACObserve(self.viewModel, model.personal.houseCondition) map:^id(id value) {
		return value ? [UIColor colorWithRed:0.251 green:0.714 blue:0.941 alpha:1.000] : [UIColor orangeColor];
	}];
	RAC(self.personalLabel, text) = [RACObserve(self.viewModel, model.personal.houseCondition) map:^id(id value) {
		return value ? @"已完成" : @"未完成";
	}];
	RAC(self.professionalLabel, textColor) = [RACObserve(self.viewModel, model.professional.socialIdentity) map:^id(id value) {
		return value ? [UIColor colorWithRed:0.251 green:0.714 blue:0.941 alpha:1.000] : [UIColor orangeColor];
	}];
	RAC(self.professionalLabel, text) = [RACObserve(self.viewModel, model.professional.socialIdentity) map:^id(id value) {
		return value ? @"已完成" : @"未完成";
	}];
	RAC(self.profilesLabel, textColor) = [RACObserve(self.viewModel, model.profiles) map:^id(id value) {
		return value ? [UIColor colorWithRed:0.251 green:0.714 blue:0.941 alpha:1.000] : [UIColor orangeColor];
	}];
	RAC(self.profilesLabel, text) = [RACObserve(self.viewModel, model.profiles) map:^id(id value) {
		return value ? @"已完成" : @"未完成";
	}];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.viewModel.active = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	self.viewModel.active = NO;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	if (indexPath.section == 0) {
		if (self.viewModel.isAuthenticated) {
			[SVProgressHUD showSuccessWithStatus:@"已完善实名认证"];
			return;
		}
		MSFAuthorizeViewModel *viewModel = [[MSFAuthorizeViewModel alloc] initWithServices:self.viewModel.services];
		MSFAuthenticateViewController *vc = [[MSFAuthenticateViewController alloc] initWithViewModel:viewModel];
		[self.navigationController pushViewController:vc animated:YES];
		return;
	}
	if (indexPath.section == 1) {
		switch (indexPath.row) {
			case 0: {
				MSFPersonalViewModel *viewModel = [[MSFPersonalViewModel alloc] initWithServices:self.viewModel.services];
				[self.viewModel.services pushViewModel:viewModel];
				break;
			}
			case 1: {
				MSFProfessionalViewModel *viewModel = [[MSFProfessionalViewModel alloc] initWithServices:self.viewModel.services];
				[self.viewModel.services pushViewModel:viewModel];
				break;
			}
		}
	}
}

@end
