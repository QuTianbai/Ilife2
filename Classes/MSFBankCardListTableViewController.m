//
//  MSFBankCardListTableViewController.m
//  Finance
//
//  Created by xbm on 15/9/29.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFBankCardListTableViewController.h"
#import "MSFBankCardListTableViewCell.h"
#import "MSFAddBankCardTableViewCell.h"
#import "MSFCommandView.h"
#import "MSFAddBankCardTableViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFUtils.h"
#import "MSFClient+MSFBankCardList.h"
#import "MSFBankCardListModel.h"
#import "MSFCheckHasTradePassword.h"
#import "MSFUtils.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "MSFInputTradePasswordViewController.h"
#import "MSFInputTradePasswordView.h"
//#import "MSFInputTradePasswordViewController.h"
#import "MSFBankCardListViewModel.h"
#import "MSFCheckHasTradePasswordModel.h"
#import "MSFSetTradePasswordTableViewController.h"

#import "MSFAuthorizeViewModel.h"
#import "AppDelegate.h"

@interface MSFBankCardListTableViewController ()<MSFInputTradePasswordDelegate>

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) MSFBankCardListViewModel *viewModel;

@property (nonatomic, strong) MSFCheckHasTradePassword *checkTPViewModel;

@property (nonatomic, strong) MSFInputTradePasswordViewController *inputTradePassword;

@property (nonatomic, copy) NSString *tradePwd;

@end

@implementation MSFBankCardListTableViewController

- (instancetype)initWithViewModel:(id)viewModel {
	self = [super init];
	if (!self) {
		return nil;
	}
	//_viewModel = viewModel;
	
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.tableView.backgroundColor = [MSFCommandView getColorWithString:@"#F6F6F6"];
	self.title = @"银行卡";
	_tradePwd = @"";
	self.dataArray = [[NSArray alloc] init];
	_viewModel = [[MSFBankCardListViewModel alloc] initWithServices:self.services];
	
	_inputTradePassword = [UIStoryboard storyboardWithName:@"InputTradePassword" bundle:nil].instantiateInitialViewController;
	_inputTradePassword.delegate = self;
	
	RAC(self, viewModel.pwd) = RACObserve(self, tradePwd);
	
	RACSignal *signal = [[MSFUtils.httpClient fetchBankCardList].collect replayLazily];
	[signal subscribeNext:^(id x) {
		for (NSObject *ob in x) {
			if ([ob isEqual:[NSNull null]]) {
				return ;
			}
		}
		self.dataArray = x;
		[self.tableView reloadData];
	}error:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];
	
	self.checkTPViewModel = [[MSFCheckHasTradePassword alloc] initWithServices:self.services];
	
	[[self.checkTPViewModel.executeChenkTradePassword execute:nil] subscribeNext:^(MSFCheckHasTradePasswordModel *model) {
		[MSFUtils setisTradePassword:model.hasTransPwd];
	} error:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	if (section == 1) {
		return 1;
	}
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 1) {
		MSFAddBankCardTableViewCell *addCell = [[NSBundle mainBundle] loadNibNamed:@"MSFAddBankCardTableViewCell" owner:nil options:nil].firstObject;
		return addCell;
	}
	static NSString *cellIdentifier = @"BnkCardCell";
	MSFBankCardListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil) {
		cell = [[NSBundle mainBundle] loadNibNamed:@"MSFBankCardListTableViewCell" owner:nil options:nil].firstObject;
	}

	
	if (indexPath.row == 0) {
			cell.isMaster.hidden = NO;
			cell.setMasterBT.hidden = YES;
			cell.unBindMaster.hidden = YES;
	} else {
			cell.isMaster.hidden = YES;
			cell.setMasterBT.hidden = NO;
			cell.unBindMaster.hidden = NO;
		}
	MSFBankCardListModel *model = self.dataArray[indexPath.row];
	cell.bankIconImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", [self getImgString:model.bankCode]]];
	cell.bankName.text = model.bankName;
	cell.BankType.text = [NSString stringWithFormat:@"%@ %@", [model.bankCardNo substringFromIndex:model.bankCardNo.length - 4], [self bankType:model.bankCardType]];
	if (model.master) {
		cell.isMaster.hidden = NO;
		cell.setMasterBT.hidden = YES;
		cell.unBindMaster.hidden = YES;
	} else {
		if (![model.bankCardType isEqualToString:@"1"]) {
			cell.setMasterBT.layer.borderColor = UIColor.lightGrayColor.CGColor;
			cell.setMasterBT.titleLabel.textColor = UIColor.lightGrayColor;
			cell.setMasterBT.layer.cornerRadius = 7.0f;
			cell.setMasterBT.layer.masksToBounds = NO;
			cell.setMasterBT.layer.borderWidth = 0.0f;
			cell.setMasterBT.backgroundColor = [UIColor lightGrayColor];
		}
		cell.isMaster.hidden = YES;
		cell.setMasterBT.hidden = NO;
		cell.unBindMaster.hidden = NO;
	}
	
	@weakify(self)
	[[[cell.setMasterBT rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
		@strongify(self)
		if (![model.bankCardType isEqualToString:@"1"]) {
			[SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"主卡暂不支持%@", [self bankType:model.bankCardType]]];
			return ;
		}
		if ([MSFUtils.isSetTradePassword isEqualToString:@"NO"]) {
					
					UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
																													message:@"请先设置交易密码" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
					[alert show];
					[alert.rac_buttonClickedSignal subscribeNext:^(NSNumber *index) {
						if (index.intValue == 1) {
							AppDelegate *delegate = [UIApplication sharedApplication].delegate;
							MSFAuthorizeViewModel *viewModel = delegate.authorizeVewModel;
							MSFSetTradePasswordTableViewController *setTradePasswordVC = [[MSFSetTradePasswordTableViewController alloc] initWithViewModel:viewModel];
							
							[self.navigationController pushViewController:setTradePasswordVC animated:YES];
						}
						
					}];
				} else {
					self.inputTradePassword.type = 0;
					self.viewModel.bankCardID = model.bankCardId;
					[[UIApplication sharedApplication].keyWindow addSubview:self.inputTradePassword.view];
				}
		
	}];
	[[[cell.unBindMaster rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
		@strongify(self)
		if ([MSFUtils.isSetTradePassword isEqualToString:@"NO"]) {
			
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
																											message:@"请先设置交易密码" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
			[alert show];
			[alert.rac_buttonClickedSignal subscribeNext:^(NSNumber *index) {
				if (index.intValue == 1) {
					AppDelegate *delegate = [UIApplication sharedApplication].delegate;
					MSFAuthorizeViewModel *viewModel = delegate.authorizeVewModel;
					MSFSetTradePasswordTableViewController *setTradePasswordVC = [[MSFSetTradePasswordTableViewController alloc] initWithViewModel:viewModel];
					
					[self.navigationController pushViewController:setTradePasswordVC animated:YES];
				}
				
			}];
		} else {
			self.inputTradePassword.type = 1;
			self.viewModel.bankCardID = model.bankCardId;
			[[UIApplication sharedApplication].keyWindow addSubview:self.inputTradePassword.view];
		}
		
		
	}];
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 1) {
		return 44;
	}
	return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	if (section == 0) {
		return 20;
	}
	return 10;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
		[cell setSeparatorInset:UIEdgeInsetsZero];
		
		if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
			[cell setLayoutMargins:UIEdgeInsetsZero];
		}
	}
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	UIView *footerView = [[UIView alloc] init];
	footerView.backgroundColor = [MSFCommandView getColorWithString:@"#F6F6F6"];
	float width = [[UIScreen mainScreen] bounds].size.width;
	UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 0.5)];
	topLine.backgroundColor = [UIColor lightGrayColor];
	[footerView addSubview:topLine];
	if (section == 0) {
		UIView *bottom = [[UIView alloc] initWithFrame:CGRectMake(0, 19.5, width, 0.5)];
		bottom.backgroundColor = [UIColor lightGrayColor];
		[footerView addSubview:bottom];
	}
	
	return footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 1) {
		if ([MSFUtils.isSetTradePassword isEqualToString:@"NO"]) {
			
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
																											message:@"请先设置交易密码" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
			[alert show];
			[alert.rac_buttonClickedSignal subscribeNext:^(NSNumber *index) {
				if (index.intValue == 1) {
					AppDelegate *delegate = [UIApplication sharedApplication].delegate;
					MSFAuthorizeViewModel *viewModel = delegate.authorizeVewModel;
					MSFSetTradePasswordTableViewController *setTradePasswordVC = [[MSFSetTradePasswordTableViewController alloc] initWithViewModel:viewModel];
					
					[self.navigationController pushViewController:setTradePasswordVC animated:YES];
				}
				
			}];
			
		} else {
			MSFAddBankCardTableViewController *vc =  [UIStoryboard storyboardWithName:@"AddBankCard" bundle:nil].instantiateInitialViewController;
			BOOL isFirstBankCard = NO;
			if (self.dataArray.count > 0) {
				isFirstBankCard = YES;
			}
			vc.viewModel =  [[MSFAddBankCardVIewModel alloc] initWithServices:self.services andIsFirstBankCard:isFirstBankCard];
			[self.navigationController pushViewController:vc animated:YES];
		}
		
	}
}

#pragma mark - MSFInputTradePasswordDelegate

- (void)getTradePassword:(NSString *)pwd type:(int)type {
	self.tradePwd = pwd;
	if (type == 0) {
		[[self.viewModel.executeSetMaster execute:nil]
		 subscribeNext:^(id x) {
			 [SVProgressHUD showSuccessWithStatus:@"主卡设置成功"];
			 RACSignal *signal = [[MSFUtils.httpClient fetchBankCardList].collect replayLazily];
			 [signal subscribeNext:^(id x) {
				 self.dataArray = x;
				 [self.tableView reloadData];
			 }error:^(NSError *error) {
				 [SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
			 }];
		 } error:^(NSError *error) {
			 [SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
		 }];
	} else if (type == 1) {
		[[self.viewModel.executeUnbind execute:nil]
		 subscribeNext:^(id x) {
			 [SVProgressHUD showSuccessWithStatus:@"银行卡解绑成功"];
			 RACSignal *signal = [[MSFUtils.httpClient fetchBankCardList].collect replayLazily];
			 [signal subscribeNext:^(id x) {
				 self.dataArray = x;
				 [self.tableView reloadData];
			 }error:^(NSError *error) {
				 [SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
			 }];
		 } error:^(NSError *error) {
			 [SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
		 }];
	}
	
}

- (NSString *)getImgString:(NSString *)code {
	if ([code isEqualToString:@"0103"]) {
		return @"ABC";//农业1
	} else if ([code isEqualToString:@"0303"]) {
		return @"guangda";//光大2
	} else if ([code isEqualToString:@"0308"]) {
		return @"CMBC";//招商3
	} else if ([code isEqualToString:@"0102"]) {
		return @"ICBC";//工商4
	} else if ([code isEqualToString:@"0305"]) {
		//民生5
		return @"CMSB";
	} else if ([code isEqualToString:@"0105"]) {
		//建设6
		return @"CBC";
	} else if ([code isEqualToString:@"0302"]) {
		 return @"zhongxin";//中信7
	} else if ([code isEqualToString:@"0309"]) {
		return @"xingye";//兴业8
	} else if ([code isEqualToString:@"0104"]) {
		return @"china";//中国9
	} else if ([code isEqualToString:@"0100"]) {
		return @"youzheng";//邮政10
	} else if ([code isEqualToString:@"0306"]) {
		return @"guangfa";//广发11
	}
	
	return @"";
	
}

- (NSString *)bankType:(NSString *)type {
	switch (type.intValue) {
  case 1:
			return @"借记卡";
			break;
	case 2:
			return @"贷记卡";
			break;
	case 3:
			return @"准贷记卡";
	case 4:
			return @"预付费卡";
			break;
			
  default:
			break;
	}
	
	return @"";
}

@end
