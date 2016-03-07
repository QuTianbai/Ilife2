//
// MSFAuthenticateViewController.m
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFAuthenticateViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "SHSPhoneTextField.h"
#import "MSFAuthorizeViewModel.h"
#import "MSFUser.h"
#import "MSFClient.h"

@interface MSFAuthenticateViewController ()

@property (nonatomic, weak) IBOutlet UITextField *username;
@property (nonatomic, weak) IBOutlet UITextField *userident;
@property (nonatomic, weak) IBOutlet UITextField *bankaddrs;
@property (nonatomic, weak) IBOutlet UITextField *bankcard;
@property (nonatomic, weak) IBOutlet UILabel *promptLabel;
@property (nonatomic, weak) IBOutlet UIImageView *promptLogo;
@property (nonatomic, weak) IBOutlet UIButton *addressButton;
@property (nonatomic, weak) IBOutlet UIButton *commitButton;

@property (nonatomic, strong) MSFAuthorizeViewModel *viewModel;

@end

@implementation MSFAuthenticateViewController

#pragma mark - NSObject

- (instancetype)initWithViewModel:(id)viewModel {
	self = [[UIStoryboard storyboardWithName:@"login" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([MSFAuthenticateViewController class])];
	if (!self) return nil;
	_viewModel = viewModel;
	return self;
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	self.addressButton.rac_command = self.viewModel.executeAlterAddressCommand;
	self.commitButton.rac_command = self.viewModel.executeAuthenticateCommand;
	RAC(self, bankaddrs.text) = RACObserve(self, viewModel.address);
	RAC(self, viewModel.username) = self.username.rac_textSignal;
	RAC(self, viewModel.card) = self.userident.rac_textSignal;
	
	@weakify(self)
	[[(SHSPhoneTextField *)self.bankcard formatter] setDefaultOutputPattern:@"#### #### #### #### ###"];
	((SHSPhoneTextField *)self.bankcard).textDidChangeBlock = ^(UITextField *textField){
		@strongify(self)
		self.viewModel.banknumber = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
	};
	
	[self.viewModel.executeAuthenticateCommand.executionSignals subscribeNext:^(RACSignal *signal) {
		@strongify(self)
		[SVProgressHUD showWithStatus:@"正在提交..."];
		[signal subscribeNext:^(id x) {
			[SVProgressHUD dismiss];
			[[self.viewModel.services.httpClient user] mergeValueForKey:@keypath(MSFUser.new, hasChecked) fromModel:[[MSFUser alloc] initWithDictionary:@{@keypath(MSFUser.new, hasChecked): @"1"} error:nil]];
			[self dismissViewControllerAnimated:YES completion:nil];
		}];
	}];
	[self.viewModel.executeAuthenticateCommand.errors subscribeNext:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];
	
	if (self.navigationController.viewControllers.count == 1) {
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStyleDone target:nil action:nil];
		self.navigationItem.rightBarButtonItem.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
			@strongify(self)
			[self dismissViewControllerAnimated:YES completion:nil];
			return [RACSignal empty];
		}];
	}
}

@end