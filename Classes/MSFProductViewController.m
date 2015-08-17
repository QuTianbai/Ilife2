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
#import "MSFCounterLabel.h"
#import "SVProgressHUD.h"
#import <KGModal/KGModal.h>
#import <ZSWTappableLabel/ZSWTappableLabel.h>
#import <ZSWTaggedString/ZSWTaggedString.h>
#import "MSFDeviceGet.h"

//static NSString *const DeviceModel = [UIDevice currentDevice].model;
static const CGFloat heightOfAboveCell = 259;//上面cell总高度
static const CGFloat heightOfNavigationANDTabbar = 64 + 44;//navigationbar和tabbar的高度
static const CGFloat heightOfRepayView = 90;//预计每期还款金额的高度
static const CGFloat heightOfPlace = 30;//button与下方tabbar的空白高度
static const CGFloat heightOfButton = 44;

static NSString *const MSFAutoinputDebuggingEnvironmentKey = @"INPUT_AUTO_DEBUG";

@interface MSFProductViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,MSFSliderDelegate, ZSWTappableLabelTapDelegate>
@property (weak, nonatomic) IBOutlet UILabel *warningLabel;
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
//@property (nonatomic,strong) UICollectionView *periodsCollectionView;

@property (weak, nonatomic) IBOutlet MSFSlider *moneySlider;
//@property (weak, nonatomic) IBOutlet UITextField *applyCashNumTF;
@property (weak, nonatomic) IBOutlet UIButton *applyMonthsBT;
@property (weak, nonatomic) IBOutlet UITextField *applyMonthsTF;
@property (weak, nonatomic) IBOutlet UIButton *moneyUsedBT;
@property (weak, nonatomic) IBOutlet UITextField *moneyUsesTF;
@property (weak, nonatomic) IBOutlet UISwitch *isInLifeInsurancePlaneSW;
@property (weak, nonatomic) IBOutlet MSFCounterLabel *repayMoneyMonth;
@property (weak, nonatomic) IBOutlet UIButton *nextPageBT;
@property (weak, nonatomic) IBOutlet UIButton *lifeInsuranceButton;

@property (nonatomic, strong, readwrite) MSFProductViewModel *viewModel;

@end

@implementation MSFProductViewController

#pragma mark - Lifecycle

- (void)dealloc {
	NSLog(@"MSFProductViewController `-dealloc`");
}

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
  @weakify(self)
	DeviceTypeNum deviceType = [MSFDeviceGet deviceNum];
	if (litter6 & deviceType) {
		self.repayConstraint.constant = 40;
		self.footerVer.constant = 40;
	} else if (bigger6 & deviceType) {
		self.footerView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - heightOfAboveCell  - heightOfNavigationANDTabbar - heightOfPlace);
		self.footerVer.constant = 0;
		self.repayConstraint.constant = ([UIScreen mainScreen].bounds.size.height - heightOfAboveCell - heightOfPlace - heightOfButton - heightOfNavigationANDTabbar - heightOfRepayView ) / 2;
	}
	
	self.warningLabel.numberOfLines = 0;
	
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
	label.text = @"贷款申请";
	label.textColor = [UIColor tintColor];
	label.font = [UIFont boldSystemFontOfSize:17];
	label.textAlignment = NSTextAlignmentCenter;
	self.navigationItem.titleView = label;
	//self.applyMonthsTF.placeholder = @"请选择期数";
	self.moneyUsesTF.placeholder = @"请选择贷款用途";
	
	RAC(self, viewModel.insurance) = self.isInLifeInsurancePlaneSW.rac_newOnChannel;
  RAC(self.moneyInsuranceLabel, text) = [RACObserve(self.viewModel, moneyInsurance) map:^id(NSString *value) {
    return (value ==nil || [value isEqualToString:@"0.00"])?@"" : [NSString stringWithFormat:@"寿险金额：%@元", value];
  }];
	
	//RAC(self.applyCashNumTF, placeholder) = RACObserve(self, viewModel.totalAmountPlacholder);
	RAC(self.repayMoneyMonth, valueText) = RACObserve(self, viewModel.termAmountText);
	RAC(self.moneyUsesTF, text) = RACObserve(self, viewModel.purposeText);
	RAC(self.applyMonthsTF, text) = RACObserve(self, viewModel.productTitle);
	self.moneySlider.delegate = self;
  RAC(self.moneySlider, minimumValue) = [RACObserve(self.viewModel, minMoney) map:^id(id value) {
    if (!value) {
      return @0;
    }
		self.viewModel.totalAmount = value;
    return value;
  }];
  RAC(self.moneySlider, maximumValue) = [RACObserve(self.viewModel, maxMoney) map:^id(id value) {
    if (!value) {
      return @0;
    }
    return value;
  }];
	
	RAC(self.viewModel, totalAmount) = [[self.moneySlider rac_newValueChannelWithNilValue:@0] map:^id(NSString *value) {
		return [NSString stringWithFormat:@"%ld", (long)value.integerValue / 100 * 100];
	 //return [NSNumber numberWithInteger:value.integerValue / 100 * 100 ];
	}] ;
	self.moneyUsedBT.rac_command = self.viewModel.executePurposeCommand;
	self.nextPageBT.rac_command = self.viewModel.executeNextCommand;
//	[[self.nextPageBT rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//		if (self.viewModel.formsViewModel.pending) {
//			[[[UIAlertView alloc] initWithTitle:@"提示"
//																			message:@"您的提交的申请已经在审核中，请耐心等待!"
//																		 delegate:nil
//														cancelButtonTitle:@"确认"
//														otherButtonTitles:nil] show];
//		} else {
//			[self.viewModel.executeNextCommand execute:nil];
//		}
//	}];
	[self.viewModel.executeNextCommand.errors subscribeNext:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];
	
	[[self.lifeInsuranceButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
		@strongify(self)
		UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 330)];
		contentView.backgroundColor = [UIColor whiteColor];
		NSString *path = [[NSBundle mainBundle] pathForResource:@"life-insurance" ofType:nil];
		NSString *string = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
		ZSWTappableLabel *label = [[ZSWTappableLabel alloc] initWithFrame:contentView.bounds];
		label.numberOfLines = 0;
		label.font = [UIFont systemFontOfSize:15];
		label.tapDelegate = self;
		
		ZSWTaggedStringOptions *options = [ZSWTaggedStringOptions defaultOptions];
		[options setAttributes:@{
			ZSWTappableLabelTappableRegionAttributeName: @YES,
			ZSWTappableLabelHighlightedBackgroundAttributeName: [UIColor lightGrayColor],
			ZSWTappableLabelHighlightedForegroundAttributeName: [UIColor whiteColor],
			NSForegroundColorAttributeName: [UIColor blueColor],
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

- (void)viewWillAppear:(BOOL)animated {
 //  self.selectViewModel = [MSFSelectionViewModel monthsViewModelWithProducts:self.viewModel.market total:self.viewModel.totalAmount.integerValue / 100 * 100];
}

- (void)setEmptyMoney {
//  self.moneySlider.value = 0;
//  self.moneySlider.moneyNumLabel.text = @"0元";
//  self.viewModel.totalAmount = @"0";
//  [self getStringValue:@"0"];
 
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
  NSLog(@"%ld", (long)self.selectViewModel.numberOfSections);
  NSLog(@"%ld", (long)[self.selectViewModel numberOfItemsInSection:section]);
  return [self.selectViewModel numberOfItemsInSection:section];
  //return _loanPeriodsAry.count;
}

- (MSFPeriodsCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  MSFPeriodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MSFPeriodsCollectionViewCell" forIndexPath:indexPath];
//  MSFProduct *model = [self.selectViewModel modelForIndexPath:indexPath];
//  if ([self.viewModel.product.productId isEqualToString:model.productId]) {
//    self.viewModel.product = model;
//  } else {
//    if (indexPath.row == [self.selectViewModel numberOfItemsInSection:0]) {
//      self.viewModel.product = [self.selectViewModel modelForIndexPath:indexPath];
//    }
//  }
  
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

//UICollectionView被选中时调用的方法
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
    //return;
  } else {
    [self setRepayMoneyBackgroundViewAniMation:YES];
  }
  self.selectViewModel = [MSFSelectionViewModel monthsViewModelWithProducts:self.viewModel.market total:stringvalue.integerValue / 100 * 100];
  [self.monthCollectionView reloadData];
 
  if ([self.selectViewModel numberOfItemsInSection:0] != 0) {
    if (self.viewModel.product == nil) {
      NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.selectViewModel numberOfItemsInSection:0] - 1 inSection:0];
      [self.monthCollectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
      self.viewModel.product = [self.selectViewModel modelForIndexPath:indexPath];
     // self.viewModel.product = [self.selectViewModel modelForIndexPath:indexPath];
    } else {
      for (int i = 0; i<[self.selectViewModel numberOfItemsInSection:0]; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        MSFProduct *model = [self.selectViewModel modelForIndexPath:indexPath];
        if ([self.viewModel.product.productId isEqualToString:model.productId]) {
           [self.monthCollectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
          self.viewModel.product = [self.selectViewModel modelForIndexPath:indexPath];
          break;
				} else if (i == [self.selectViewModel numberOfItemsInSection:0] - 1) {
					[self.monthCollectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
					self.viewModel.product = [self.selectViewModel modelForIndexPath:indexPath];
				}
      }
    }
    
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
