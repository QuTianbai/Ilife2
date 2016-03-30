//
//	MSFProductViewController.m
//
//	Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFApplyCashViewController.h"
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
#import "MSFClient+CalculateMonthRepay.h"
#import "MSFPlan.h"
#import "MSFLoanType.h"
#import "MSFCalculatemMonthRepayModel.h"
#import "MSFApplyCashViewModel.h"
#import "MSFPlanViewModel.h"
#import "MSFAmortize.h"
#import "MSFOrganize.h"
#import "MSFPlan.h"
#import "MSFPlanView.h"

static const CGFloat heightOfAboveCell = 303;//上面cell总高度259
static const CGFloat heightOfNavigationANDTabbar = 64 + 44;//navigationbar和tabbar的高度
static const CGFloat heightOfRepayView = 90;//预计每期还款金额的高度
static const CGFloat heightOfPlace = 30;//button与下方tabbar的空白高度
static const CGFloat heightOfButton = 44;

static NSString *const MSFAutoinputDebuggingEnvironmentKey = @"INPUT_AUTO_DEBUG";

@interface MSFApplyCashViewController () <MSFSliderDelegate, ZSWTappableLabelTapDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *repayConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *footerVer;
@property (weak, nonatomic) IBOutlet UILabel *moneyInsuranceLabel;
@property (weak, nonatomic) IBOutlet UIView *repayMoneyBackgroundView;
@property (nonatomic, assign) BOOL isSelectedRow;

@property (nonatomic, strong) MSFMarket *market;
@property (nonatomic, strong) MSFSelectionViewModel *selectViewModel DEPRECATED_ATTRIBUTE;
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
@property (weak, nonatomic) IBOutlet UILabel *bankCardLabel;

@property (weak, nonatomic) IBOutlet UIButton *agreeProtocolButton;
@property (weak, nonatomic) IBOutlet UIButton *showProtocolButton;
@property (weak, nonatomic) IBOutlet UIImageView *protocolStatusImage;
@property (nonatomic, weak) IBOutlet UIPickerView *picker;

@property (nonatomic, assign) BOOL master;

@property (nonatomic, strong, readwrite) MSFApplyCashViewModel *viewModel;

@end

@implementation MSFApplyCashViewController

#pragma mark - NSObject

- (void)dealloc {
	NSLog(@"MSFProductViewController `-dealloc`");
}

- (instancetype)initWithViewModel:(MSFApplyCashViewModel *)viewModel {
	self = [UIStoryboard storyboardWithName:@"product" bundle:nil].instantiateInitialViewController;
  if (!self) {
    return nil;
  }
	_viewModel = viewModel;
	self.hidesBottomBarWhenPushed = YES;
	
  return self;
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
  @weakify(self)
	
	RAC(self, protocolStatusImage.highlighted) = RACObserve(self, agreeProtocolButton.selected);
	self.showProtocolButton.rac_command = self.viewModel.executeAgreementCommand;
	[[self.agreeProtocolButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
		@strongify(self)
		self.agreeProtocolButton.selected = !self.agreeProtocolButton.selected;
	}];
	
	DeviceTypeNum deviceType = [MSFDeviceGet deviceNum];
	if (litter6 & deviceType) {
		self.repayConstraint.constant = 40;
		self.footerVer.constant = 40;
	} else if ((IPHONE6P | IPHONE6SP) & deviceType) {
		self.footerView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - heightOfAboveCell  - heightOfNavigationANDTabbar - heightOfPlace);
		self.footerVer.constant = 0;
		self.repayConstraint.constant = ([UIScreen mainScreen].bounds.size.height - heightOfAboveCell - heightOfPlace - heightOfButton - heightOfNavigationANDTabbar - heightOfRepayView ) / 2 ;
	}
	
	self.title = @"申请贷款";
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
    self.viewModel.isPush = NO;
    self.viewModel.isChangTerm = NO;
		if (value.integerValue == 0) {
			self.moneyInsuranceLabel.hidden = YES;
			//self.moneyInsuranceLabel.text = @"";
		} else {
			self.moneyInsuranceLabel.hidden = NO;
		}
		
		return value.stringValue;
	}];
	RAC(self, bankCardLabel.text) = RACObserve(self, viewModel.masterBankCardNameAndNO);
  RAC(self.moneyInsuranceLabel, text) = [RACObserve(self.viewModel, lifeInsuranceAmt) map:^id(NSString *value) {
    return (value ==nil || [value isEqualToString:@"0.00"])?@"" : [NSString stringWithFormat:@"寿险金额：%@元", value];
  }];
	
	RAC(self.repayMoneyMonth, valueText) = RACObserve(self, viewModel.loanFixedAmt);
	RAC(self.moneyUsesTF, text) = RACObserve(self, viewModel.purposeText);
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
	
	// 根据首页的选择更新
	self.moneySlider.value = self.viewModel.appLmt.integerValue;
	[self.picker selectRow:self.viewModel.homepageIndex inComponent:0 animated:YES];
	
	RAC(self, viewModel.appLmt) = [[self.moneySlider rac_signalForControlEvents:UIControlEventTouchUpInside] map:^id(UISlider *slider) {
    self.viewModel.isPush = NO;
    self.viewModel.isChangTerm = NO;
    if (slider.value == slider.minimumValue) {
      return [NSString stringWithFormat:@"%d", (int)slider.minimumValue];
    }
    if (slider.value > slider.maximumValue-((int)slider.maximumValue % 500) || slider.value == slider.maximumValue) {
      return [NSString stringWithFormat:@"%d", (int)slider.maximumValue];
    }
		return [NSString stringWithFormat:@"%d", slider.value == slider.minimumValue? (int)slider.minimumValue : ((int)slider.value / 500 + 1) * 500];
	}] ;
	self.moneyUsedBT.rac_command = self.viewModel.executePurposeCommand;
	
	[[self.nextPageBT rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
		@strongify(self)
		if (!self.protocolStatusImage.highlighted) {
			[SVProgressHUD showInfoWithStatus:@"请同意贷款协议"];
			return;
		}
		if (!self.viewModel.purposeText) {
			[SVProgressHUD showInfoWithStatus:@"选择贷款用途"];
			return;
		}
		[self.viewModel.executeNextCommand execute:x];
	}];
	
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
	
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn-back-nav"] style:UIBarButtonItemStyleDone target:nil action:nil];
	self.navigationItem.leftBarButtonItem.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		self.viewModel.jionLifeInsurance = @"0";
		[self.navigationController popViewControllerAnimated:YES];
		return [RACSignal empty];
	}];
	
	[RACObserve(self, viewModel.viewModels) subscribeNext:^(id x) {
        @strongify(self);
        [self.picker reloadAllComponents];
    if (!self.viewModel.isPush) {
      [self.picker selectRow:self.viewModel.viewModels.count - 1 inComponent:0 animated:NO];
      self.viewModel.trial =((MSFPlanViewModel *)self.viewModel.viewModels.lastObject).model;
      
    } else {
      
      self.viewModel.trial =((MSFPlanViewModel *)self.viewModel.viewModels[self.viewModel.homepageIndex]).model;
      [self.picker selectRow:self.viewModel.homepageIndex inComponent:0 animated:NO];
      
    }
    
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

- (void)viewDidLayoutSubviews {
	if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
		[self.tableView setSeparatorInset:UIEdgeInsetsZero];
	}
	if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
		[self.tableView setLayoutMargins:UIEdgeInsetsZero];
	}
}

#pragma mark - MSFSlider Delegate

- (void)startSliding {
}

- (void)getStringValue:(NSString *)stringvalue {

}

#pragma mark - ZSWTappableLabelTapDelegate

- (void)tappableLabel:(ZSWTappableLabel *)tappableLabel tappedAtIndex:(NSInteger)idx withAttributes:(NSDictionary *)attributes {
}

#pragma mark - UIPickerViewDelegate UIPickerViewDataSource

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return self.viewModel.viewModels.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
	return 30.00;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
	MSFPlanView *label = (MSFPlanView *)view;
	if (!label) label = [[MSFPlanView alloc] init];
	[label bindViewModel:self.viewModel.viewModels[row]];

	return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
  self.viewModel.homepageIndex = row;
  self.viewModel.isChangTerm = YES;
	self.viewModel.trial = [(MSFPlanViewModel *)self.viewModel.viewModels[row] model];
}

@end
