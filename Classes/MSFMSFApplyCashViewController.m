//
//	MSFProductViewController.m
//
//	Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFMSFApplyCashViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Mantle/EXTScope.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "MSFEdgeButton.h"
#import "MSFSelectKeyValues.h"
#import "MSFSelectionViewModel.h"
#import "MSFSelectionViewController.h"
#import "MSFWebViewController.h"
#import "MSFLoanAgreementController.h"
#import "MSFLoanAgreementViewModel.h"
#import "UIColor+Utils.h"
#import "MSFSlider.h"
#import <Masonry/Masonry.h>
#import "MSFPeriodsCollectionViewCell.h"
#import "MSFCommandView.h"
#import "MSFXBMCustomHeader.h"
#import "MSFCounterLabel.h"
#import "SVProgressHUD.h"
#import <KGModal/KGModal.h>
#import <ZSWTappableLabel/ZSWTappableLabel.h>
#import <ZSWTaggedString/ZSWTaggedString.h>
#import "MSFDeviceGet.h"

#import "MSFApplyCashViewModel.h"

static const CGFloat heightOfAboveCell = 303;//上面cell总高度259
static const CGFloat heightOfNavigationANDTabbar = 64 + 44;//navigationbar和tabbar的高度
static const CGFloat heightOfRepayView = 90;//预计每期还款金额的高度
static const CGFloat heightOfPlace = 30;//button与下方tabbar的空白高度
static const CGFloat heightOfButton = 44;

static NSString *const MSFAutoinputDebuggingEnvironmentKey = @"INPUT_AUTO_DEBUG";

@interface MSFMSFApplyCashViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,MSFSliderDelegate, ZSWTappableLabelTapDelegate>

@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *repayConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *footerVer;
@property (weak, nonatomic) IBOutlet UILabel *moneyInsuranceLabel;
@property (weak, nonatomic) IBOutlet UIView *repayMoneyBackgroundView;
@property (nonatomic, assign) BOOL isSelectedRow;

@property (nonatomic, strong) MSFMarket *market;
@property (nonatomic, strong) MSFSelectionViewModel *selectViewModel;
@property (nonatomic, strong) NSArray *loanPeriodsAry;
@property (weak, nonatomic) IBOutlet UICollectionView *monthCollectionView;
@property (weak, nonatomic) IBOutlet UITableViewCell *moneyCell;

@property (weak, nonatomic) IBOutlet MSFSlider *moneySlider;
@property (weak, nonatomic) IBOutlet UIButton *moneyUsedBT;
@property (weak, nonatomic) IBOutlet UITextField *moneyUsesTF;
@property (weak, nonatomic) IBOutlet UISwitch *isInLifeInsurancePlaneSW;
@property (weak, nonatomic) IBOutlet MSFCounterLabel *repayMoneyMonth;
@property (weak, nonatomic) IBOutlet UIButton *nextPageBT;
@property (weak, nonatomic) IBOutlet UIButton *lifeInsuranceButton;
@property (weak, nonatomic) IBOutlet UILabel *bankCard;

@property (nonatomic, assign) BOOL master;

@property (nonatomic, strong, readwrite) MSFApplyCashViewModel *viewModel;

@end

@implementation MSFMSFApplyCashViewController

#pragma mark - Lifecycle

- (void)dealloc {
	NSLog(@"MSFProductViewController `-dealloc`");
}

- (instancetype)initWithViewModel:(MSFApplyCashViewModel *)viewModel {
	self = [UIStoryboard storyboardWithName:@"product" bundle:nil].instantiateInitialViewController;
  if (!self) {
    return nil;
  }
	_viewModel = viewModel;
	
  return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
  @weakify(self)
	DeviceTypeNum deviceType = [MSFDeviceGet deviceNum];
	if (litter6 & deviceType) {
		self.repayConstraint.constant = 40;
		self.footerVer.constant = 40;
	} else if ((IPHONE6P | IPHONE6SP) & deviceType) {
		self.footerView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - heightOfAboveCell  - heightOfNavigationANDTabbar - heightOfPlace);
		self.footerVer.constant = 0;
		self.repayConstraint.constant = ([UIScreen mainScreen].bounds.size.height - heightOfAboveCell - heightOfPlace - heightOfButton - heightOfNavigationANDTabbar - heightOfRepayView ) / 2 ;
	}
	
  [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"RepayMoneyMonthNotifacation" object:nil]
		takeUntil:self.rac_willDeallocSignal]
		subscribeNext:^(id x) {
			@strongify(self)
			[self setRepayMoneyBackgroundViewAniMation:NO];
		}];
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
	label.text = @"申请贷款";
	label.textColor = [UIColor tintColor];
	label.font = [UIFont boldSystemFontOfSize:17];
	label.textAlignment = NSTextAlignmentCenter;
	self.navigationItem.titleView = label;
	self.moneyUsesTF.placeholder = @"请选择贷款用途";
	
	RAC(self, bankCard.text) = [RACObserve(self, viewModel.masterBankCardNameAndNO) map:^id(id value) {
		if ([value isEqualToString:@""] || value == nil) {
			self.master = NO;
			[self.tableView reloadData];
			return @"";
		}
		self.master = YES;
		[self.tableView reloadData];
		return value;
	}];
	
	self.viewModel.jionLifeInsurance = @"1";
	RAC(self, viewModel.jionLifeInsurance) = [self.isInLifeInsurancePlaneSW.rac_newOnChannel map:^id(NSNumber *value) {
		if (value.integerValue == 0) {
			self.moneyInsuranceLabel.hidden = YES;
			//self.moneyInsuranceLabel.text = @"";
		} else {
			self.moneyInsuranceLabel.hidden = NO;
		}
		
		return value.stringValue;
	}];
  RAC(self.moneyInsuranceLabel, text) = [RACObserve(self.viewModel, lifeInsuranceAmt) map:^id(NSString *value) {
    return (value ==nil || [value isEqualToString:@"0.00"])?@"" : [NSString stringWithFormat:@"寿险金额：%@元", value];
  }];
	
	RAC(self.repayMoneyMonth, valueText) = RACObserve(self, viewModel.loanFixedAmt);
	RAC(self.moneyUsesTF, text) = RACObserve(self, viewModel.purposeText);
	self.moneySlider.delegate = self;
  RAC(self.moneySlider, minimumValue) = [RACObserve(self.viewModel, minMoney) map:^id(id value) {
    if (!value) {
      return @0;
    }
		self.viewModel.appLmt = value;
    return value;
  }];
  RAC(self.moneySlider, maximumValue) = [RACObserve(self.viewModel, maxMoney) map:^id(id value) {
    if (!value) {
      return @0;
    }
    return value;
  }];
	
	RAC(self, viewModel.appLmt) = [[self.moneySlider rac_newValueChannelWithNilValue:@0] map:^id(NSString *value) {
		self.viewModel.product = nil;
		return [NSString stringWithFormat:@"%ld", value.integerValue < 100 ?(long)self.moneySlider.minimumValue : (long)value.integerValue / 100 * 100];
	}] ;
	self.moneyUsedBT.rac_command = self.viewModel.executePurposeCommand;
	self.nextPageBT.rac_command = self.viewModel.executeNextCommand;
	[self.viewModel.executeNextCommand.errors subscribeNext:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];
	
	[[self.lifeInsuranceButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
		@strongify(self)
		UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 390)];
		contentView.backgroundColor = [UIColor whiteColor];
		
		UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 10, 80, 20)];
		titleLabel.textColor = [UIColor themeColorNew];
		titleLabel.font = [UIFont boldSystemFontOfSize:18];
		titleLabel.text = @"寿险条约";
		[contentView addSubview:titleLabel];
		
		UIView *line = [[UIView alloc] initWithFrame:CGRectMake(8, 40, contentView.frame.size.width-16, 1)];
		line.backgroundColor = [UIColor themeColorNew];
		[contentView addSubview:line];
		
		NSString *path = [[NSBundle mainBundle] pathForResource:@"life-insurance" ofType:nil];
		NSString *string = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
		ZSWTappableLabel *label = [[ZSWTappableLabel alloc] initWithFrame:CGRectMake(8, 40, contentView.frame.size.width-8, contentView.frame.size.height-40)];
		label.numberOfLines = 0;
		label.font = [UIFont systemFontOfSize:15];
		label.tapDelegate = self;
		
		ZSWTaggedStringOptions *options = [ZSWTaggedStringOptions defaultOptions];
		[options setAttributes:@{
			ZSWTappableLabelTappableRegionAttributeName: @YES,
			ZSWTappableLabelHighlightedBackgroundAttributeName: [UIColor lightGrayColor],
			ZSWTappableLabelHighlightedForegroundAttributeName: [UIColor whiteColor],
			NSForegroundColorAttributeName: [UIColor themeColorNew],
			NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),
			@"URL": [NSURL URLWithString:@"http://www.msxf.com/msfinance/page/about/insuranceInfo.htm"],
		} forTagName:@"link"];
		label.attributedText = [[ZSWTaggedString stringWithString:string] attributedStringWithOptions:options];
		[contentView addSubview:label];
		[[KGModal sharedInstance] setCloseButtonLocation:KGModalCloseButtonLocationRight];
		[[KGModal sharedInstance] setModalBackgroundColor:[UIColor whiteColor]];
		[[KGModal sharedInstance] showWithContentView:contentView andAnimated:YES];
	}];
	[[self rac_signalForSelector:@selector(tappableLabel:tappedAtIndex:withAttributes:) fromProtocol:@protocol(ZSWTappableLabelTapDelegate)] subscribeNext:^(id x) {
		@strongify(self)
		[[KGModal sharedInstance] hideWithCompletionBlock:^{
			[self.viewModel.executeLifeInsuranceCommand execute:nil];
		}];
	}];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
		[cell setSeparatorInset:UIEdgeInsetsZero];
	}

	if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
		[cell setLayoutMargins:UIEdgeInsetsZero];
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (self.master) {
		return 3;
	}
	return 2;
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
  return [self.selectViewModel numberOfItemsInSection:section];
}

- (MSFPeriodsCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  MSFPeriodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MSFPeriodsCollectionViewCell" forIndexPath:indexPath];
	
  cell.text = [self.selectViewModel titleForIndexPath:indexPath];
	cell.locked = self.moneySlider.tracking;
  return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  if ([self.selectViewModel numberOfItemsInSection:0] > 4) {
    return CGSizeMake(([UIScreen mainScreen].bounds.size.width - 15 * 2 - 5 * 5 ) / 4.5, self.monthCollectionView.frame.size.height / 2);
  }
  return CGSizeMake(([UIScreen mainScreen].bounds.size.width - 15 * 2 - 5 * 5 ) / 4, self.monthCollectionView.frame.size.height / 2);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
  return UIEdgeInsetsMake(10, 15, 20, 15);
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  [self setRepayMoneyBackgroundViewAniMation:YES];
	self.viewModel.product = [self.selectViewModel modelForIndexPath:indexPath];
}

#pragma mark - MSFSlider Delegate

- (void)startSliding {
  if (self.moneySlider.maximumValue == 0) {
    [SVProgressHUD showInfoWithStatus:@"系统繁忙，请稍后再试"];
  }
	//self.viewModel.termAmount = 0;
	[self.monthCollectionView reloadData];
}

- (void)getStringValue:(NSString *)stringvalue {
  if (stringvalue.integerValue == 0) {
    self.viewModel.product = nil;
  } else {
    [self setRepayMoneyBackgroundViewAniMation:YES];
  }
	
	self.selectViewModel = [MSFSelectionViewModel monthsVIewModelWithMarkets:self.viewModel.markets total:stringvalue.integerValue];
  [self.monthCollectionView reloadData];
 
  if ([self.selectViewModel numberOfItemsInSection:0] != 0) {
		NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.selectViewModel numberOfItemsInSection:0] - 1 inSection:0];
      [self.monthCollectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
      self.viewModel.product = [self.selectViewModel modelForIndexPath:indexPath];
  }
}

- (void)setRepayMoneyBackgroundViewAniMation:(BOOL)isHiddin {
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDuration:0.3];
  if (isHiddin) {
    [UIView setAnimationDuration:0];
    self.repayMoneyBackgroundView.alpha = 0.2;
  } else {
    self.repayMoneyBackgroundView.alpha = 1;
  }
  [UIView commitAnimations];
}

#pragma mark - ZSWTappableLabelTapDelegate

- (void)tappableLabel:(ZSWTappableLabel *)tappableLabel tappedAtIndex:(NSInteger)idx withAttributes:(NSDictionary *)attributes {
}

@end
