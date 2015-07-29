//
//	MSFProductViewController.m
//
//	Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFProductViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/extobjc.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "MSFUtils.h"
#import "MSFMarket.h"
#import "MSFProduct.h"
#import "MSFTeams.h"
#import "MSFApplicationForms.h"
#import "MSFEdgeButton.h"
#import "MSFSelectKeyValues.h"
#import "MSFApplicationResponse.h"
#import "MSFSelectionViewModel.h"
#import "MSFSelectionViewController.h"
#import "MSFProductViewModel.h"
#import "MSFWebViewController.h"
#import "MSFAgreementViewModel.h"
#import "MSFAgreement.h"
#import "MSFLoanAgreementController.h"
#import "MSFFormsViewModel.h"
#import "MSFLoanAgreementViewModel.h"
#import "UIColor+Utils.h"
#import "MSFSlider.h"
#import <Masonry/Masonry.h>
#import "MSFPeriodsCollectionViewCell.h"
#import "MSFCommandView.h"
#import "MSFXBMCustomHeader.h"

static NSString *const MSFAutoinputDebuggingEnvironmentKey = @"INPUT_AUTO_DEBUG";

@interface MSFProductViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,MSFSliderDelegate>
@property (nonatomic,strong) MSFMarket *market;
@property (nonatomic, strong) MSFSelectionViewModel *selectViewModel;
@property (nonatomic, strong) NSArray *loanPeriodsAry;
@property (weak, nonatomic) IBOutlet UICollectionView *monthCollectionView;
@property (weak, nonatomic) IBOutlet UITableViewCell *moneyCell;
//@property (nonatomic,strong) UICollectionView *periodsCollectionView;

@property (weak, nonatomic) IBOutlet MSFSlider *moneySlider;
@property (weak, nonatomic) IBOutlet UITextField *applyCashNumTF;
@property (weak, nonatomic) IBOutlet UIButton *applyMonthsBT;
@property (weak, nonatomic) IBOutlet UITextField *applyMonthsTF;
@property (weak, nonatomic) IBOutlet UIButton *moneyUsedBT;
@property (weak, nonatomic) IBOutlet UITextField *moneyUsesTF;
@property (weak, nonatomic) IBOutlet UISwitch *isInLifeInsurancePlaneSW;
@property (weak, nonatomic) IBOutlet UILabel *repayMoneyMonth;
@property (weak, nonatomic) IBOutlet UIButton *nextPageBT;
@property (weak, nonatomic) IBOutlet UIButton *lifeInsuranceButton;


@property (nonatomic, strong) RACCommand *executePurposeCommand;
@property (nonatomic, strong) RACCommand *executeTermCommand;
@property (nonatomic, strong) RACCommand *executeNextCommand;
@property (nonatomic, strong) RACCommand *executeLifeInsuranceCommand;
@property (nonatomic, strong, readwrite) MSFProductViewModel *viewModel;

@end

@implementation MSFProductViewController

#pragma mark - Lifecycle

- (instancetype)initWithViewModel:(MSFProductViewModel *)viewModel {
	self = [UIStoryboard storyboardWithName:@"product" bundle:nil].instantiateInitialViewController;
  if (!self) {
    return nil;
  }
	
	_viewModel = viewModel;
  
  return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
  
  UICollectionViewFlowLayout *collectionFlowLayout = [[UICollectionViewFlowLayout alloc]init];
  
  [collectionFlowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
  self.monthCollectionView.collectionViewLayout = collectionFlowLayout;
  self.monthCollectionView.showsHorizontalScrollIndicator = NO;
  self.monthCollectionView.delegate = self;
  self.monthCollectionView.dataSource = self;
  [self.monthCollectionView setBackgroundColor:[UIColor clearColor]];
  self.monthCollectionView.showsVerticalScrollIndicator = NO;
  [self.monthCollectionView registerNib:[UINib nibWithNibName:@"MSFPeriodsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MSFPeriodsCollectionViewCell"];
  
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
	label.text = @"贷款申请";
	label.textColor = [UIColor fontHighlightedColor];
	label.font = [UIFont boldSystemFontOfSize:17];
	label.textAlignment = NSTextAlignmentCenter;
	self.navigationItem.titleView = label;
	self.applyMonthsTF.placeholder = @"请选择期数";
	self.moneyUsesTF.placeholder = @"请选择贷款用途";
	
	@weakify(self)
	RAC(self, viewModel.insurance) = self.isInLifeInsurancePlaneSW.rac_newOnChannel;
	
	RAC(self.applyCashNumTF, placeholder) = RACObserve(self, viewModel.totalAmountPlacholder);
	RAC(self.repayMoneyMonth, text) = RACObserve(self, viewModel.termAmountText);
	RAC(self.moneyUsesTF, text) = RACObserve(self, viewModel.purposeText);
	RAC(self.applyMonthsTF, text) = RACObserve(self, viewModel.productTitle);
	
  RAC(self.moneySlider, minimumValue) = [RACObserve(self.viewModel, minMoney) map:^id(id value) {
    if (!value) {
      return @0;
    }
    return value;
  }];
  RAC(self.moneySlider, maximumValue) = [RACObserve(self.viewModel, maxMoney) map:^id(id value) {
    if (!value) {
      return @0;
    }
    return value;
  }];
  self.moneySlider.delegate = self;
	RAC(self.viewModel, totalAmount) = [[self.moneySlider rac_newValueChannelWithNilValue:@0] map:^id(NSNumber *value) {
    
	 return [NSNumber numberWithInteger:value.integerValue / 100 * 100 ];
	}] ;
	self.applyMonthsBT.rac_command = self.executeTermCommand;
	[self.executeTermCommand.executionSignals subscribeNext:^(RACSignal *signal) {
		@strongify(self)
		[signal subscribeNext:^(id x) {
			self.viewModel.product = x;
		}];
	}];
	[self.executeTermCommand.errors subscribeNext:^(NSError *error) {
		[SVProgressHUD showInfoWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];
	
	self.moneyUsedBT.rac_command = self.executePurposeCommand;
	[self.executePurposeCommand.executionSignals subscribeNext:^(RACSignal *signal) {
		@strongify(self)
		[signal subscribeNext:^(id x) {
			self.viewModel.purpose = x;
		}];
	}];
	
	self.nextPageBT.rac_command = self.executeNextCommand;
	[self.executeNextCommand.errors subscribeNext:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];
	
	self.lifeInsuranceButton.rac_command = self.executeLifeInsuranceCommand;
}

#pragma mark - Private

- (RACCommand *)executePurposeCommand {
	if (_executePurposeCommand) {
		return _executePurposeCommand;
	}
	@weakify(self)
	_executePurposeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		[self.view endEditing:YES];
		MSFSelectionViewModel *viewModel = [MSFSelectionViewModel selectViewModelWithFilename:@"moneyUse"];
		MSFSelectionViewController *selectionViewController = [[MSFSelectionViewController alloc] initWithViewModel:viewModel];
		selectionViewController.title = @"选择贷款用途";
		[self.navigationController pushViewController:selectionViewController animated:YES];
		@weakify(selectionViewController)
		return [selectionViewController.selectedSignal doNext:^(id x) {
			@strongify(selectionViewController)
			[selectionViewController.navigationController popViewControllerAnimated:YES];
		}];
	}];
	_executePurposeCommand.allowsConcurrentExecution = YES;
	
	return _executePurposeCommand;
}

- (RACCommand *)executeTermCommand {
	if (_executeTermCommand) {
		return _executeTermCommand;
	}
	
	@weakify(self)
	_executeTermCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
			[self.view endEditing:YES];
//				if (self.applyCashNumTF.text.integerValue % 100 != 0) {
//				[subscriber sendError:[NSError errorWithDomain:@"MSFProductViewController" code:0 userInfo:@{
//					NSLocalizedFailureReasonErrorKey: @"贷款金额必须为100的整数倍"
//				}]];
//				return nil;
//			}
			if (self.viewModel.market.teams.count == 0) {
				[subscriber sendError:[NSError errorWithDomain:@"MSFProductViewController" code:0 userInfo:@{
					NSLocalizedFailureReasonErrorKey: @"网络繁忙请稍后再试"
				}]];
				return nil;
			}
			MSFSelectionViewModel *viewModel = [MSFSelectionViewModel monthsViewModelWithProducts:self.viewModel.market total:self.viewModel.totalAmount.integerValue];
			if ([viewModel numberOfItemsInSection:0] == 0) {
				NSString *string;
				NSMutableArray *region = [[NSMutableArray alloc] init];
       // [region addObject:[NSString stringWithFormat:@"%@ 到 %@ 之间", self.viewModel.mar]];
				[self.viewModel.market.teams enumerateObjectsUsingBlock:^(MSFTeams *obj, NSUInteger idx, BOOL *stop) {
					[region addObject:[NSString stringWithFormat:@"%@ 到 %@ 之间", obj.minAmount,obj.maxAmount]];
				}];
        string = [NSString stringWithFormat:@"请输入贷款金额范围在 %@ 到 %@ 之间的数字", self.viewModel.market.allMinAmount,self.viewModel.market.allMaxAmount];
        
				//string = [NSString stringWithFormat:@"请输入贷款金额范围在  %@ 的数字", [region componentsJoinedByString:@","]];
				
				[subscriber sendError:[NSError errorWithDomain:@"MSFProductViewController" code:0 userInfo:@{
					NSLocalizedFailureReasonErrorKey: string,
				}]];
				return nil;
			}
			MSFSelectionViewController *selectionViewController = [[MSFSelectionViewController alloc] initWithViewModel:viewModel];
			selectionViewController.title = @"选择贷款期数";
			[self.navigationController pushViewController:selectionViewController animated:YES];
			@weakify(selectionViewController)
			[selectionViewController.selectedSignal subscribeNext:^(id x) {
				[subscriber sendNext:x];
				@strongify(selectionViewController)
				[selectionViewController.navigationController popViewControllerAnimated:YES];
			}];
			
			return nil;
		}];
	}];
	_executeTermCommand.allowsConcurrentExecution = YES;
	
	return _executeTermCommand;
}

- (RACCommand *)executeNextCommand {
	if (_executeNextCommand) {
		return _executeNextCommand;
	}
	@weakify(self)
	_executeNextCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
			@strongify(self)
			if (!self.viewModel.product) {
				[subscriber sendError:[NSError errorWithDomain:@"MSFProductViewController" code:0 userInfo:@{
					NSLocalizedFailureReasonErrorKey: @"请选择贷款期数",
				}]];
				return nil;
			}
			if (!self.viewModel.purpose) {
				[subscriber sendError:[NSError errorWithDomain:@"MSFProductViewController" code:0 userInfo:@{
					NSLocalizedFailureReasonErrorKey: @"请选择贷款用途",
				}]];
				return nil;
			}
			MSFLoanAgreementController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MSFLoanAgreementWebView"];
			vc.hidesBottomBarWhenPushed = YES;
			MSFLoanAgreementViewModel *viewModel = [[MSFLoanAgreementViewModel alloc] initWithFromsViewModel:self.viewModel.formsViewModel product:self.viewModel.product];
			[vc bindViewModel:viewModel];
			[self.navigationController pushViewController:vc animated:YES];
			[subscriber sendCompleted];
			return nil;
		}];
	}];
	
	return _executeNextCommand;
}

- (RACCommand *)executeLifeInsuranceCommand {
	if (_executeLifeInsuranceCommand) {
		return _executeLifeInsuranceCommand;
	}
		@weakify(self)
	_executeLifeInsuranceCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
			@strongify(self)
			MSFWebViewController *webViewController = [[MSFWebViewController alloc] initWithHTMLURL:
			[MSFUtils.agreementViewModel.agreement lifeInsuranceURL]];
			webViewController.hidesBottomBarWhenPushed = YES;
			[self.navigationController pushViewController:webViewController animated:YES];
			return nil;
		}];
	}];
	_executeLifeInsuranceCommand.allowsConcurrentExecution = YES;
	
	return _executeLifeInsuranceCommand;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
		[cell setSeparatorInset:UIEdgeInsetsZero];
	}

	if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
		[cell setLayoutMargins:UIEdgeInsetsZero];
	}
}

- (void)viewDidLayoutSubviews {
	if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
		[self.tableView setSeparatorInset:UIEdgeInsetsZero];
	}
	if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
		[self.tableView setLayoutMargins:UIEdgeInsetsZero];
	}
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  NSLog(@"%ld", self.selectViewModel.numberOfSections);
  NSLog(@"%ld", [self.selectViewModel numberOfItemsInSection:section]);
  return [self.selectViewModel numberOfItemsInSection:section];
  //return _loanPeriodsAry.count;
}

- (MSFPeriodsCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellID = @"MSFPeriodsCollectionViewCell";
  
  MSFPeriodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
  cell.layer.borderColor   = [UIColor grayColor].CGColor;
  cell.layer.borderWidth   = 1;
  cell.layer.cornerRadius  = 7;
  cell.layer.masksToBounds = YES;
  cell.loacPeriodsLabel.backgroundColor = [UIColor clearColor];
  cell.loacPeriodsLabel.textColor = [UIColor grayColor];
  cell.loacPeriodsLabel.text = [self.selectViewModel titleForIndexPath:indexPath];
  return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  return CGSizeMake(([UIScreen mainScreen].bounds.size.width - 15 * 2 - 5 * 5 ) / 4, self.monthCollectionView.frame.size.height / 2);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
  return UIEdgeInsetsMake(10, 15, 20, 15);
}

#pragma mark - UICollectionViewDelegate

//UICollectionView被选中时调用的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 self.viewModel.product = [self.selectViewModel modelForIndexPath:indexPath]; 
  MSFPeriodsCollectionViewCell *cell = (MSFPeriodsCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
  cell.loacPeriodsLabel.textColor = [UIColor tintColor];
  cell.layer.borderColor   = [UIColor tintColor].CGColor;
}

//UICollectionView取消选中时调用的方法
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
  
  MSFPeriodsCollectionViewCell *cell = (MSFPeriodsCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
  cell.loacPeriodsLabel.textColor = [UIColor grayColor];
  cell.layer.borderColor   = [UIColor grayColor].CGColor;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  return YES;
}
#pragma mark - MSFSlider Delegate
- (void)getStringValue:(NSString *)stringvalue {
  self.selectViewModel = [MSFSelectionViewModel monthsViewModelWithProducts:self.viewModel.market total:stringvalue.integerValue / 100 * 100];
  [self.monthCollectionView reloadData];
}

@end
