//
//  MSFSocialCaskApplyTableViewController.m
//  Finance
//
//  Created by xbm on 15/11/20.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFSocialCaskApplyTableViewController.h"
#import <ZSWTappableLabel/ZSWTappableLabel.h>
#import <ZSWTaggedString/ZSWTaggedString.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <KGModal/KGModal.h>
#import "MSFCommandView.h"
#import "MSFXBMCustomHeader.h"
#import "MSFSocialInsuranceCashViewModel.h"
#import "MSFEdgeButton.h"
#import "MSFLoanAgreementViewModel.h"
#import "MSFLoanAgreementController.h"
#import "MSFSocialInsuranceModel.h"
#import "MSFApplicationForms.h"
#import "UIColor+Utils.h"

@interface MSFSocialCaskApplyTableViewController ()<ZSWTappableLabelTapDelegate>

@property (nonatomic, strong) MSFSocialInsuranceCashViewModel *viewModel;

@property (weak, nonatomic) IBOutlet UITextField *cashPuposeTF;
@property (weak, nonatomic) IBOutlet UIButton *cashPurposeBT;

@property (weak, nonatomic) IBOutlet UILabel *liveAreaTF;
@property (weak, nonatomic) IBOutlet UIButton *liveAreaBT;

@property (weak, nonatomic) IBOutlet UITextField *liveAddressTF;

@property (weak, nonatomic) IBOutlet UITextField *companyNameTF;

@property (weak, nonatomic) IBOutlet UITextField *companyAreaTF;
@property (weak, nonatomic) IBOutlet UIButton *companyAreaBT;

@property (weak, nonatomic) IBOutlet UITextField *companyAddressTF;

@property (weak, nonatomic) IBOutlet UITextField *relationTF;
@property (weak, nonatomic) IBOutlet UIButton *relationBT;

@property (weak, nonatomic) IBOutlet UITextField *nameTF;

@property (weak, nonatomic) IBOutlet UITextField *mobileTF;

@property (weak, nonatomic) IBOutlet UITextField *basePayTF;
@property (weak, nonatomic) IBOutlet UIButton *basePayBT;

@property (weak, nonatomic) IBOutlet MSFEdgeButton *submitBT;

//@property (nonatomic, strong) NSString *professional; // 社会身份状态码

@end

@implementation MSFSocialCaskApplyTableViewController

- (instancetype)initWithViewModel:(MSFSocialInsuranceCashViewModel *)viewModel {
	self = [UIStoryboard storyboardWithName:@"SocialCashApply" bundle:nil].instantiateInitialViewController;
	if (!self) {
		return nil;
	}
	_viewModel = viewModel;
	self.professional = viewModel.professional;
	
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	RAC(self, cashPuposeTF.text) = [RACObserve(self, viewModel.cashpurpose) ignore:nil];
	@weakify(self)
	[[self.isLifeInsuranceBT rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
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
	
	self.viewModel.jionLifeInsurance = @"1";
	RAC(self, viewModel.jionLifeInsurance) = [self.lifeInsuranceSwitch.rac_newOnChannel map:^id(NSNumber *value) {

		return value.stringValue;
	}];
	
	if ([self.professional isEqualToString:@"SI05"] || [self.professional isEqualToString:@"SI03"] || [self.professional isEqualToString:@"SI06"]) {//居民
		self.oldMonthsOrYeasLB.text = @"缴费年数";
		self.oldTypeLB.text = @"缴费档次";
		self.medicalTypeLB.text = @"缴费档次";
		self.monthsOrYeasLB.text = @"缴费年数";
		RAC(self, olderStatusTF.text) = [RACObserve(self, viewModel.residentOlderInsuranceStatusTitle) ignore:nil];
		RAC(self, olderBaseTF.text) = [RACObserve(self, viewModel.residentOlderInsuranceMoneyTitle) ignore:nil];
		RAC(self, medicalStatusTF.text) = [RACObserve(self, viewModel.residentMedicalInsuranceStatusTitle) ignore:nil];
		RAC(self, medicalBaseTF.text) = [RACObserve(self, viewModel.residentMedicalInsuranceMoneyTitle) ignore:nil];
		RAC(self.olderDateTF, text) = [RACObserve(self, viewModel.residentOlderInsuranceDate) map:^id(id value) {
			return value;
		}];
		RAC(self.medicalDate, text) = RACObserve(self, viewModel.residentMedicalInsuranceDate);
		
		RACChannelTerminal *residentOlderInsuranceYearsChannel = RACChannelTo(self, viewModel.residentOlderInsuranceYears);
		RAC(self.olderMonthsTF, text) = residentOlderInsuranceYearsChannel;
		[self.olderMonthsTF.rac_textSignal subscribe:residentOlderInsuranceYearsChannel];
		
		RACChannelTerminal *residentMedicalInsuranceYears = RACChannelTo(self, viewModel.residentMedicalInsuranceYears);
		RAC(self.medicalMonths, text) = residentMedicalInsuranceYears;
		[self.medicalMonths.rac_textSignal subscribe:residentMedicalInsuranceYears];
		
		[[self.medicalMonths rac_signalForControlEvents:UIControlEventEditingChanged]
		 subscribeNext:^(UITextField *x) {
			 if (x.text.length > 2) {
				 x.text = [x.text substringToIndex:2];
			 }
		 }];
		
		[[self.medicalMonths rac_signalForControlEvents:UIControlEventEditingDidEnd]
		subscribeNext:^(UITextField *x) {
			if (x.text.integerValue < 1) {
				x.text = @"2";
				[SVProgressHUD showErrorWithStatus:@"居民医疗保险实际缴费年数:请输入1-50之间的整数"];
			}
		}];
		
		[[self.olderMonthsTF rac_signalForControlEvents:UIControlEventEditingChanged]
		 subscribeNext:^(UITextField *x) {
			 if (x.text.length > 2) {
				 x.text = [x.text substringToIndex:2];
			 }
		 }];
		
		[[self.olderMonthsTF rac_signalForControlEvents:UIControlEventEditingDidEnd]
		 subscribeNext:^(UITextField *x) {
			 if (x.text.integerValue < 1) {
				 x.text = @"2";
				 [SVProgressHUD showErrorWithStatus:@"居民养老保险实际缴费年数:请输入1-50之间的整数"];
			 }
		 }];
		
	} else {//职工
		RAC(self, olderStatusTF.text) = [RACObserve(self, viewModel.employeeOldInsuranceStatusTitle) ignore:nil];
		RAC(self, olderBaseTF.text) = [RACObserve(self, viewModel.employeeOlderModeyTitle) ignore:nil];
		RAC(self, medicalStatusTF.text) = [RACObserve(self, viewModel.employMedicalStatusTitle) ignore:nil];
		RAC(self, medicalBaseTF.text) = [RACObserve(self, viewModel.employeeMedicalMoneyTitle) ignore:nil];
		RAC(self, injuryStatusTF.text) = [RACObserve(self, viewModel.emplyoeeJuryStatusTitle) ignore:nil];
		RAC(self, unEmployTF.text) = [RACObserve(self, viewModel.employeeOutJobStatusTitle) ignore:nil];
		RAC(self, bearTF.text) = [RACObserve(self, viewModel.employeeBearStatusTitle) ignore:nil];
		
		RAC(self.olderDateTF, text) = RACObserve(self, viewModel.employeeOlderDate);
		RAC(self.medicalDate, text) = RACObserve(self, viewModel.employeeMedicalDate);
		
		RACChannelTerminal *employeeOlderMonths = RACChannelTo(self, viewModel.employeeOlderMonths);
		RAC(self.olderMonthsTF, text) = employeeOlderMonths;
		[self.olderMonthsTF.rac_textSignal subscribe:employeeOlderMonths];
		
		RACChannelTerminal *employeeMedicalMonths = RACChannelTo(self, viewModel.employeeMedicalMonths);
		RAC(self.medicalMonths, text) = employeeMedicalMonths;
		[self.medicalMonths.rac_textSignal subscribe:employeeMedicalMonths];
		
		[[self.medicalMonths rac_signalForControlEvents:UIControlEventEditingChanged]
		 subscribeNext:^(UITextField *x) {
			 if (x.text.length > 3) {
				 x.text = [x.text substringToIndex:3];
			 }
		 }];
		
		[[self.medicalMonths rac_signalForControlEvents:UIControlEventEditingDidEnd]
		 subscribeNext:^(UITextField *x) {
			 if (x.text.integerValue < 1) {
				 x.text = @"12";
				 [SVProgressHUD showErrorWithStatus:@"职工医疗保险实际缴费月数:请输入1-600之间的整数"];
			 }
		 }];
		
		[[self.olderMonthsTF rac_signalForControlEvents:UIControlEventEditingChanged]
		 subscribeNext:^(UITextField *x) {
			 if (x.text.length > 3) {
				 x.text = [x.text substringToIndex:3];
			 }
		 }];
		
		[[self.olderMonthsTF rac_signalForControlEvents:UIControlEventEditingDidEnd]
		 subscribeNext:^(UITextField *x) {
			 if (x.text.integerValue < 1) {
				 x.text = @"12";
				 [SVProgressHUD showErrorWithStatus:@"职工养老保险实际缴费月数:请输入1-600之间的整数"];
			 }
		 }];
	}
	
	self.submitBT.rac_command = self.viewModel.executeSaveCommand;
	[self.viewModel.executeSaveCommand.executionSignals subscribeNext:^(RACSignal *signal) {
		@strongify(self)
		[SVProgressHUD showWithStatus:@"正在保存..." maskType:SVProgressHUDMaskTypeClear];
		[signal subscribeNext:^(id x) {
			[SVProgressHUD dismiss];
			MSFLoanAgreementViewModel *viewModel = [[MSFLoanAgreementViewModel alloc] initWithApplicationViewModel:self.viewModel];
			MSFLoanAgreementController *viewController = [[MSFLoanAgreementController alloc] initWithViewModel:viewModel];
			[self.navigationController pushViewController:viewController animated:YES];
		}];
	}];
	[self.viewModel.executeSaveCommand.errors subscribeNext:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

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

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	
	NSString *sectionTitle = [super tableView:tableView titleForHeaderInSection:section];
	if (sectionTitle == nil) {
		return  nil;
	}
	
	UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, self.view.frame.size.height)];
	
	UIView *firstRow = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 44)];
	
	CGFloat labelHeight = 5;
	if (section == 0) {
		[sectionView addSubview:firstRow];
		labelHeight = 44;
	}
	sectionView.backgroundColor = [MSFCommandView getColorWithString:@"#f8f8f8"];
	
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, labelHeight, 200, 22)];
	if ([self.professional isEqualToString:@"SI05"] || [self.professional isEqualToString:@"SI03"] || [self.professional isEqualToString:@"SI06"]) {
		sectionTitle = [sectionTitle stringByReplacingOccurrencesOfString:@"职工" withString:@"居民"];
	}
	titleLabel.text = sectionTitle;
	titleLabel.font = [UIFont systemFontOfSize:14];
	titleLabel.textColor = [MSFCommandView getColorWithString:POINTCOLOR];
	titleLabel.backgroundColor = [UIColor clearColor];
	
	
	[sectionView addSubview:titleLabel];
	
	return sectionView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self.view endEditing:YES];
	switch (indexPath.section) {
		case 0:
			switch (indexPath.row) {
				case 0:
				{
					[self.viewModel.executePurposeCommand execute:nil];
				}
					break;
					
				default:
					break;
			}
			break;
		case 1:
			switch (indexPath.row) {
				case 0:
				{
					if ([self.professional isEqualToString:@"SI05"] || [self.professional isEqualToString:@"SI03"] || [self.professional isEqualToString:@"SI06"]) {
					[self.viewModel.executeResidentOlderInsuranceStatusCommand execute:nil];
					break;
				}
					[self.viewModel.executeEmployeeInsuranceStatusCommand execute:nil];
				}
					break;
				case 1:
					if ([self.professional isEqualToString:@"SI05"] || [self.professional isEqualToString:@"SI03"] || [self.professional isEqualToString:@"SI06"]) {
						[self.viewModel.executeResidentOlderInsuranceMoneyCommand execute:nil];
						break;
					}
					[self.viewModel.executeEmployeeOlderModeyCommand execute:nil];
					break;
				case 2:
					if ([self.professional isEqualToString:@"SI05"] || [self.professional isEqualToString:@"SI03"] || [self.professional isEqualToString:@"SI06"]) {
						[self.viewModel.executeResidentInsuranceDateCommand execute:self.view];
						break;
					}
					[self.viewModel.executeoldInsuranceDateCommand execute:self.view];
					break;
				default:
				case 3:
					break;
					break;
			}
			break;
		case 2:
			switch (indexPath.row) {
				case 0:
					if ([self.professional isEqualToString:@"SI05"] || [self.professional isEqualToString:@"SI03"] || [self.professional isEqualToString:@"SI06"]) {
						[self.viewModel.executeResidentMedicalInsuranceStatusCommand execute:nil];
						break;
					}
					[self.viewModel.executeEmployMedicalStatusCommand execute:nil];
					break;
				case 1:
					if ([self.professional isEqualToString:@"SI05"] || [self.professional isEqualToString:@"SI03"] || [self.professional isEqualToString:@"SI06"]) {
						[self.viewModel.executeResidentMedicalInsuranceMoneyCommand execute:nil];
						break;
					}
					[self.viewModel.executeEmployeeMedicalMoneyCommand execute:nil];
					break;
				case 2:
					if ([self.professional isEqualToString:@"SI05"] || [self.professional isEqualToString:@"SI03"] || [self.professional isEqualToString:@"SI06"]) {
						[self.viewModel.executeResidentMedicalDateCommand execute:self.view];
						break;
					}
					[self.viewModel.executeoldMedicalDateCommand execute:self.view];
					break;
				default:
					break;
			}
			break;
		case 3:
			switch (indexPath.row) {
				case 0:
					[self.viewModel.executeEmplyoeeJuryStatusCommand execute:nil];
					break;
				case 1:
					[self.viewModel.executeEmployeeOutJobStatusCommand execute:nil];
					break;
				case 2:
					[self.viewModel.executeEmployeeBearStatusCommand execute:nil];
					break;
					
				default:
					break;
			}
		break;
			
  default:
			break;
	}
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if ([self.professional isEqualToString:@"SI05"] || [self.professional isEqualToString:@"SI03"] || [self.professional isEqualToString:@"SI06"]) {
		return 3;
	}
	return 4;
	
}

#pragma mark - ZSWTappableLabelTapDelegate

- (void)tappableLabel:(ZSWTappableLabel *)tappableLabel tappedAtIndex:(NSInteger)idx withAttributes:(NSDictionary *)attributes {
}

@end
