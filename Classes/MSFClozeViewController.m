//
// MSFComplementViewController.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFClozeViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Mantle/EXTScope.h>
#import "MSFClozeViewModel.h"
#import "MSFUtils.h"
#import "MSFSelectionViewModel.h"
#import "MSFSelectionViewController.h"
#import "MSFSelectKeyValues.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <ActionSheetPicker-3.0/ActionSheetDatePicker.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Mantle/EXTScope.h>
#import <REFormattedNumberField/REFormattedNumberField.h>
#import "NSDateFormatter+MSFFormattingAdditions.h"
#import "NSCharacterSet+MSFCharacterSetAdditions.h"
#import "NSDate+UTC0800.h"
#import "MSFBankInfoModel.h"

static NSString *bankCardShowInfoStrA = @"目前只支持工商银行、农业银行、中国银行、建设银行、招商银行、邮政储蓄银行、兴业银行、光大银行、民生银行、中信银行、广发银行的借记卡。请换卡再试。";
static NSString *bankCardShowStrB = @"目前不支持非借记卡类型的银行卡，请换卡再试。";
static NSString *bankCardShowStrC = @"你的银行卡号长度有误，请修改后再试";

@interface MSFClozeViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *bankNameLB;
@property (weak, nonatomic) IBOutlet UILabel *BankCardTypeLB;
@property (weak, nonatomic) IBOutlet UILabel *showInfoLB;
@property (nonatomic, strong) MSFClozeViewModel *viewModel;

@property (nonatomic, assign) BOOL isFindBankCard;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bankInfoCS;

@end

@implementation MSFClozeViewController

#pragma mark - Lifecycle

- (instancetype)initWithViewModel:(id)viewModel {
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"login" bundle:nil];
	self = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass(MSFClozeViewController.class)];
  if (!self) {
    return nil;
  }
	_viewModel = viewModel;
  
  return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	NSMutableAttributedString *bankCardShowInfoAttributeStr = [[NSMutableAttributedString alloc] initWithString:bankCardShowInfoStrA];
	NSRange redRange = [bankCardShowInfoStrA rangeOfString:@"工商银行、农业银行、中国银行、建设银行、招商银行、邮政储蓄银行、兴业银行、光大银行、民生银行、中信银行、广发银行"];
	[bankCardShowInfoAttributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:redRange];
	
	_bankArcView.layer.cornerRadius = 8;
	_bankArcView.layer.masksToBounds = YES;
  _bankArcView.layer.borderWidth = 1;
	_bankArcView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
	
	_personArcView.layer.cornerRadius = 8;
	_personArcView.layer.masksToBounds = YES;
	_personArcView.layer.borderWidth = 1;
	_personArcView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
	
	self.edgesForExtendedLayout = UIRectEdgeNone;
	self.bankNameLB.alpha = 0;
	RAC(self.bankNameLB, text) = RACObserve(self.viewModel, bankName);
	[RACObserve(self.viewModel, bankName) subscribeNext:^(NSString *bankName) {
		if (bankName != nil && ![bankName isEqualToString:@""]) {
			[UIView beginAnimations:nil context:nil];
			[UIView setAnimationDuration:0.3];
			self.bankNameLB.alpha = 1.0;
			[UIView commitAnimations];
		} else {
			self.bankNameLB.alpha = 0;
		}
		
	}];
	RAC(self.BankCardTypeLB, text) = [[RACObserve(self.viewModel, bankType) ignore:nil] map:^id(id value) {
		return value;
	}];
	[[RACObserve(self.viewModel, bankType) ignore:nil] subscribeNext:^(NSString *type) {
		if (type != nil && ![type isEqualToString:@""] ) {
			[UIView beginAnimations:nil context:nil];
			[UIView setAnimationDuration:0.3];
			self.BankCardTypeLB.alpha = 1.0;
			[UIView commitAnimations];
		} else {
			self.BankCardTypeLB.alpha = 0;
		}
		
	}];
	[RACObserve(self.viewModel, bankInfo.support) subscribeNext:^(NSString *support) {
		CGFloat alpha = 0;
		switch (support.intValue) {
			case 1:
				alpha = 1.0;
				[self.showInfoLB setAttributedText:bankCardShowInfoAttributeStr];
				self.bankInfoCS.constant = 100;
			break;
			case 2:
				alpha = 1.0;
				self.showInfoLB.text = bankCardShowStrB;
				self.bankInfoCS.constant = 50;
			break;
				case 0:
				case 3:
				self.showInfoLB.text = @"";
				self.bankInfoCS.constant = 25;
				break;
		default:
    break;
		}

		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.3];
		self.showInfoLB.alpha = alpha;
		[UIView commitAnimations];
		
	}];
	RAC(self.viewModel, name) = self.name.rac_textSignal;//姓名
	RAC(self.viewModel, card) = self.card.rac_textSignal;//身份证
	RAC(self.viewModel, bankNO) = self.bankNO.rac_textSignal;//银行卡号
	
	
	// Submit
	self.submitButton.rac_command = self.viewModel.executeAuth;
	@weakify(self)
	[self.submitButton.rac_command.executionSignals subscribeNext:^(RACSignal *authSignal) {
		@strongify(self)
		[self.view endEditing:YES];
		[SVProgressHUD showWithStatus:@"正在提交..." maskType:SVProgressHUDMaskTypeClear];
		[authSignal subscribeNext:^(id x) {
			
			[SVProgressHUD showSuccessWithStatus:@"恭喜,您的实名认证已通过!"];
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
				[[NSNotificationCenter defaultCenter] postNotificationName:@"MSFClozeViewModelDidUpdateNotification" object:x];
			});
		}];
	}];
	[self.submitButton.rac_command.errors subscribeNext:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];
	RAC(self.permanentButton, selected) = RACObserve(self.viewModel, permanent);
	
	[[self.permanentButton rac_signalForControlEvents:UIControlEventTouchUpInside]
	 subscribeNext:^(id x) {
		 self.datePickerButton.enabled = NO;
		 self.expired.enabled = NO;
		 }];
	
	RAC(self.datePickerButton, enabled) =
	[RACSignal
		combineLatest:@[RACObserve(self.viewModel, permanent)]
		reduce:^id(NSNumber *permanent){
			return @(!permanent.boolValue);
		}];
	[RACObserve(self.viewModel, permanent) subscribeNext:^(NSNumber *permanent) {
		@strongify(self)
		if (permanent.boolValue) {
			self.expired.text = @"";
			[self.expired setBackgroundColor:[UIColor colorWithWhite:0.902 alpha:1.000]];
		} else {
			[self.expired setBackgroundColor:[UIColor whiteColor]];
		}
	}];
	self.permanentButton.rac_command = self.viewModel.executePermanent;
	
	// Left Bar button
	UIBarButtonItem *item = [[UIBarButtonItem alloc]
		initWithImage:[UIImage imageNamed:@"left_arrow"] style:UIBarButtonItemStyleDone target:nil action:nil];
	item.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		if (self.navigationController.viewControllers.count != 1) {
			// 通过注册到这里，但是没有完成实名认证
			[[NSNotificationCenter defaultCenter] postNotificationName:@"MSFClozeViewModelDidUpdateNotification" object:[self.viewModel services].httpClient];
			[self.navigationController popViewControllerAnimated:YES];
		} else {
			// 已登录用户, 进入实名认证, 未完成认证退出
			[self dismissViewControllerAnimated:YES completion:nil];
		}
		
		return [RACSignal empty];
	}];
	self.navigationItem.leftBarButtonItem = item;
	
	// Bank name
	//RAC(self.bankName, text) = RACObserve(self.viewModel, bankName);
//	[[self.bankNameButton rac_signalForControlEvents:UIControlEventTouchUpInside]
//		subscribeNext:^(id x) {
//			[self.view endEditing:YES];
//			MSFSelectionViewModel *viewModel = [MSFSelectionViewModel selectKeyValuesViewModel:[MSFSelectKeyValues getSelectKeys:@"json_banks"]];
//			MSFSelectionViewController *selectViewController = [[MSFSelectionViewController alloc] initWithViewModel:viewModel];
//			selectViewController.title = @"选择银行";
//			[self.navigationController pushViewController:selectViewController animated:YES];
//			
//			[selectViewController.selectedSignal subscribeNext:^(MSFSelectKeyValues *selectValue) {
//				[selectViewController.navigationController popViewControllerAnimated:YES];
//				self.viewModel.bankName = selectValue.text;
//				self.viewModel.bankCode = selectValue.code;
//			}];
//		}];
	
	// Bank Address
	RAC(self.bankAddress, text) = RACObserve(self.viewModel, bankAddress);
	self.bankAddressButton.rac_command = self.viewModel.executeSelected;
	
	// Bank No button
//	[[self.bankNOButton rac_signalForControlEvents:UIControlEventTouchUpInside]
//		subscribeNext:^(id x) {
//			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
//				message:@"为保证账户资金安全,仅支持本人的储蓄卡(借记卡)收款"
//				delegate:nil
//				cancelButtonTitle:@"￼知道了"
//				otherButtonTitles:nil];
//			[alertView show];
//		}];
	
	// common init
	[[self.datePickerButton rac_signalForControlEvents:UIControlEventTouchUpInside]
		subscribeNext:^(id x) {
			@strongify(self)
			[self.view endEditing:YES];
			NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
			NSDate *currentDate = [NSDate msf_date];
			NSDateComponents *comps = [[NSDateComponents alloc] init];
			[comps setYear:100];
			NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
			[comps setYear:0];
			NSDate *minDate = [NSDate msf_date];
			
			NSDate *date = self.viewModel.expired ?: [NSDate msf_date];
			
			[ActionSheetDatePicker
				showPickerWithTitle:@""
				datePickerMode:UIDatePickerModeDate
				selectedDate:date
				minimumDate:minDate
				maximumDate:maxDate
				doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
					self.expired.text = [NSDateFormatter msf_stringFromDate:[NSDate msf_date:selectedDate]];
					self.viewModel.expired = selectedDate;
				} cancelBlock:^(ActionSheetDatePicker *picker) {
				} origin:self.view];
	}];
	
	self.name.delegate = self;
	self.card.delegate = self;
	self.card.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
	[(REFormattedNumberField *)self.bankNO setFormat:@"XXXX XXXX XXXX XXXX XXX"];
	
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
	if ([textField isEqual:self.card]) {
		textField.text = [textField.text uppercaseString];
	}
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	if ([textField isEqual:self.name]) {
		NSCharacterSet *blockedCharacters = [[NSCharacterSet letterCharacterSet] invertedSet];
    NSCharacterSet *blockedCharatersSquared = [NSCharacterSet characterSetWithCharactersInString:@"➋➌➍➎➏➐➑➒"];
		return ([string rangeOfCharacterFromSet:blockedCharacters].location == NSNotFound) || ([string rangeOfCharacterFromSet:blockedCharatersSquared].location != NSNotFound);
	} else if ([textField isEqual:self.card]) {
		if (range.location > 17) {
			return NO;
		}
		if (range.location == 17) {
			NSCharacterSet *blockedCharacters = [[NSCharacterSet identifyCardCharacterSet] invertedSet];
			
			return ([string rangeOfCharacterFromSet:blockedCharacters].location == NSNotFound);
		}
		NSCharacterSet *blockedCharacters = [[NSCharacterSet numberCharacterSet] invertedSet];
		
		return ([string rangeOfCharacterFromSet:blockedCharacters].location == NSNotFound);
	}
	
	return YES;
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

	UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
	
	[label setBackgroundColor:[UIColor whiteColor]];
	
	[label setText:@"    银行信息"];
	if (section == 1) {
	return label;
	}
	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	if (section == 1) {
		return 44;
	}
	return 0;
}

@end
