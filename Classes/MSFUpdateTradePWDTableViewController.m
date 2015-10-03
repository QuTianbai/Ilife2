//
//  MSFUpdateTradePWDTableViewController.m
//  Finance
//
//  Created by xbm on 15/10/3.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFUpdateTradePWDTableViewController.h"
#import "MSFEdgeButton.h"
#import "MSFAuthorizeViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface MSFUpdateTradePWDTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *oldpwdTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet UITextField *surepwdTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet MSFEdgeButton *submitBT;
@property (weak, nonatomic) IBOutlet UIImageView *codebgimg;
@property (weak, nonatomic) IBOutlet UILabel *codeLB;
@property (weak, nonatomic) IBOutlet UIButton *codeBT;

@property (nonatomic, strong) MSFAuthorizeViewModel *viewModel;

@end

@implementation MSFUpdateTradePWDTableViewController

- (instancetype)initWithViewModel:(id)viewModel {
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UpdateTradePWD" bundle:nil];
	self = storyboard.instantiateInitialViewController;
	if (!self) {
		return nil;
	}
	_viewModel = viewModel;
	
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	RAC(self, viewModel.oldTradePWD) = self.oldpwdTF.rac_textSignal;
	RAC(self, viewModel.TradePassword) = self.pwdTF.rac_textSignal;
	RAC(self, viewModel.smsCode) = self.codeTF.rac_textSignal;
	RAC(self, viewModel.againTradePWD) = self.surepwdTF.rac_textSignal;
	
	self.codeBT.rac_command = self.viewModel.executeCaptcha;
	
	RAC(self, codeLB.text) = RACObserve(self, viewModel.counter);
	
	@weakify(self)
	[self.codeBT.rac_command.executionSignals subscribeNext:^(RACSignal *captchaSignal) {
		@strongify(self)
		[self.view endEditing:YES];
		[SVProgressHUD showWithStatus:@"正在获取验证码" maskType:SVProgressHUDMaskTypeClear];
		[captchaSignal subscribeNext:^(id x) {
			[SVProgressHUD dismiss];
		}];
	}];
	
	[self.codeBT.rac_command.errors subscribeNext:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];
	
	
	[self.viewModel.captchaRequestValidSignal subscribeNext:^(NSNumber *value) {
		@strongify(self)
		self.codeLB.textColor = value.boolValue ? UIColor.whiteColor: [UIColor blackColor];
		self.codebgimg.image = value.boolValue ? self.viewModel.captchaNomalImage : self.viewModel.captchaHighlightedImage;
	}];
	
	self.submitBT.rac_command = self.viewModel.executeUpdateTradePwd;
	
	[self.viewModel.executeUpdateTradePwd.executionSignals subscribeNext:^(RACSignal *signal) {
		[SVProgressHUD showWithStatus:@"正在提交数据..."];
		[signal subscribeNext:^(id x) {
			[SVProgressHUD showSuccessWithStatus:@"交易密码修改成功"];
			[self.navigationController popViewControllerAnimated:YES];
		}];
	}];
	
	[self.viewModel.executeUpdateTradePwd.errors subscribeNext:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
